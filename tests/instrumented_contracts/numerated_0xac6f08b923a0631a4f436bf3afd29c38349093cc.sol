1 //SPDX-License-Identifier: MIT
2 //
3 //___________.__               ________.__        ___.          .__    ________  .__       .__  __         .__    
4 //\__    ___/|  |__   ____    /  _____/|  |   ____\_ |__ _____  |  |   \______ \ |__| ____ |__|/  |______  |  |   
5 //  |    |   |  |  \_/ __ \  /   \  ___|  |  /  _ \| __ \\__  \ |  |    |    |  \|  |/ ___\|  \   __\__  \ |  |   
6 //  |    |   |   Y  \  ___/  \    \_\  \  |_(  <_> ) \_\ \/ __ \|  |__  |    `   \  / /_/  >  ||  |  / __ \|  |__ 
7 //  |____|   |___|  /\___  >  \______  /____/\____/|___  (____  /____/ /_______  /__\___  /|__||__| (____  /____/ 
8 //                \/     \/          \/                \/     \/               \/  /_____/               \/       
9 //__________.__       .__     __           _________ .__                   __                                     
10 //\______   \__| ____ |  |___/  |_  ______ \_   ___ \|  |__ _____ ________/  |_  ___________                      
11 // |       _/  |/ ___\|  |  \   __\/  ___/ /    \  \/|  |  \\__  \\_  __ \   __\/ __ \_  __ \                     
12 // |    |   \  / /_/  >   Y  \  |  \___ \  \     \___|   Y  \/ __ \|  | \/|  | \  ___/|  | \/                     
13 // |____|_  /__\___  /|___|  /__| /____  >  \______  /___|  (____  /__|   |__|  \___  >__|                        
14 //        \/  /_____/      \/          \/          \/     \/     \/                 \/            
15 //
16 //The Global Digital Rights Charter
17 //VERSION 1.0 - MARCH 2023
18 //
19 //Preamble
20 //
21 //These truths are self-evident:
22 //
23 //- the digital realm, consisting of computers, mobile phones, the internet, augmented and virtual reality, the metaverse and other related technologies, is a permanent and important part of human society.
24 //- people are endowed with certain inalienable rights that apply in the digital realm, just as they apply in the physical realm.
25 //- people have the right to live their lives in the digital realm, with the same freedom, dignity, and personal sovereignty as in the physical realm.
26 //- rights in the digital realm shall not be abridged without due process of law. Any abridgment of digital rights must further a compelling government interest and be narrowly tailored to achieve that interest.
27 //
28 //The Digital Rights
29 //
30 //1. Everyone has the right to life, liberty, and the pursuit of happiness in the digital realm.
31 //2. Everyone has the right to own, and hold in their own direct and exclusive possession and control, digital objects, without unreasonable burdens. The government shall not have the right to store or access passwords or private keys without due process of law. All other legal or natural persons shall not have the right to store or access passwords or private keys without explicit permission.
32 //3. Everyone has the right to be free to transact digital objects, without unreasonable burdens.
33 //4. Everyone has the right to use decentralized applications, without unreasonable burdens.
34 //5. Everyone has the right to be secure against unreasonable searches and seizures of their digital objects and no warrants shall issue, but upon probable cause, supported by oath or affirmation, and particularly describing the place to be searched, and the persons or things to be seized. This right extends to digital objects and information a person provides to a third party, whether intentionally or unintentionally. The government may not search or seize such digital objects or information without complying with the requirements of the foregoing sentence.
35 //6. Everyone has the right to participate in the creation and maintenance of digital public commons, such as open-source software and public blockchains and distributed ledgers. No one shall be held responsible for the actions of others in a digital public commons that is not under that person's control.
36 //7. Everyone has the right to privacy in their digital life. The right to privacy also includes the right of everyone to use encryption that is free from back doors or other intentional weaknesses or circumventions in the encryption that are accessible by the government or private companies or individuals. Interpretations of this right should be read broadly and to favor an individual's right to privacy.
37 //8. Everyone has the right to be treated in a non-discriminatory manner regardless of sex, race, color, ethnic or social origin, genetic features, language, religion or other belief, political opinion, membership of a national minority, property, birth, disability, age, gender or sexual orientation.
38 //9. Everyone has the right to exit from any digital service by claiming their personal digital data. Digital services that utilize data held on a public blockchain are presumed compliant with this clause. Digital services that hold data in a private database must make such data available for export in common formats, in reasonable timeframes, using reasonable methods.
39 //10. Everyone in the digital realm has the right to speak, assemble, practice their religion, conduct scientific and academic research, and petition the government.
40 //11. Everyone has the right to define contractual rights in the digital realm and allow exercise of those rights in a personal or automated manner.
41 //12. Everyone is free from collective punishment in the digital realm.
42 //13. Everyone has the right to act in the digital realm through anonymous identities, pseudonymous identities and/or software agents, so long as each person maintains personal responsibility for the actions of all their identities and agents.
43 //14. The rights enumerated above cannot be abridged, except when narrowly tailored to further a legitimate and compelling government interest and after due process of law. In any proceeding to abridge the rights enumerated above, the defendant shall have the right to legal representation and shall enjoy the presumption of innocence. National security exceptions to the above should be time- and scope-limited and supervised by a competent court with a presumption that hearings should be public. In no case should national security exemptions be applied to collective societal restrictions of digital rights.
44 //15. Everyone has the obligation to comply with the relevant laws and regulations of their respective state and community, in a manner consistent with the rights enumerated above, and to respect the rights of others to conduct their digital lives peacefully.
45 //
46 //Signatories to the Charter will make an effort to implement these principles.
47 //
48 //1. Political entities should standardize their implementations of Global Digital Rights Charter to the greatest extent possible to promote international cooperation and friendship.
49 //2. Individuals and organizations should aim to promote digital rights in their personal and organizational actions and in their political community.
50 
51 pragma solidity >=0.6.0 <=0.8.5;
52 
53 /*
54  * @dev Provides information about the current execution context, including the
55  * sender of the transaction and its data. While these are generally available
56  * via msg.sender and msg.data, they should not be accessed in such a direct
57  * manner, since when dealing with GSN meta-transactions the account sending and
58  * paying for execution may not be the actual sender (as far as an application
59  * is concerned).
60  *
61  * This contract is only required for intermediate, library-like contracts.
62  */
63 abstract contract Context {
64     function _msgSender() internal view virtual returns (address) {
65         return msg.sender;
66     }
67 
68     function _msgData() internal view virtual returns (bytes memory) {
69         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
70         return msg.data;
71     }
72 }
73 
74 // File: @openzeppelin/contracts/introspection/IERC165.sol
75 
76 
77 pragma solidity >=0.6.0 <=0.8.5;
78 
79 /**
80  * @dev Interface of the ERC165 standard, as defined in the
81  * https://eips.ethereum.org/EIPS/eip-165[EIP].
82  *
83  * Implementers can declare support of contract interfaces, which can then be
84  * queried by others ({ERC165Checker}).
85  *
86  * For an implementation, see {ERC165}.
87  */
88 interface IERC165 {
89     /**
90      * @dev Returns true if this contract implements the interface defined by
91      * `interfaceId`. See the corresponding
92      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
93      * to learn more about how these ids are created.
94      *
95      * This function call must use less than 30 000 gas.
96      */
97     function supportsInterface(bytes4 interfaceId) external view returns (bool);
98 }
99 
100 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
101 
102 
103 
104 pragma solidity >=0.6.0 <=0.8.5;
105 
106 
107 /**
108  * @dev Required interface of an ERC721 compliant contract.
109  */
110 interface IERC721 is IERC165 {
111     /**
112      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
113      */
114     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
115 
116     /**
117      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
118      */
119     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
120 
121     /**
122      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
123      */
124     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
125 
126     /**
127      * @dev Returns the number of tokens in ``owner``'s account.
128      */
129     function balanceOf(address owner) external view returns (uint256 balance);
130 
131     /**
132      * @dev Returns the owner of the `tokenId` token.
133      *
134      * Requirements:
135      *
136      * - `tokenId` must exist.
137      */
138     function ownerOf(uint256 tokenId) external view returns (address owner);
139 
140     /**
141      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
142      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
143      *
144      * Requirements:
145      *
146      * - `from` cannot be the zero address.
147      * - `to` cannot be the zero address.
148      * - `tokenId` token must exist and be owned by `from`.
149      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
150      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
151      *
152      * Emits a {Transfer} event.
153      */
154     function safeTransferFrom(address from, address to, uint256 tokenId) external;
155 
156     /**
157      * @dev Transfers `tokenId` token from `from` to `to`.
158      *
159      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
160      *
161      * Requirements:
162      *
163      * - `from` cannot be the zero address.
164      * - `to` cannot be the zero address.
165      * - `tokenId` token must be owned by `from`.
166      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
167      *
168      * Emits a {Transfer} event.
169      */
170     function transferFrom(address from, address to, uint256 tokenId) external;
171 
172     /**
173      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
174      * The approval is cleared when the token is transferred.
175      *
176      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
177      *
178      * Requirements:
179      *
180      * - The caller must own the token or be an approved operator.
181      * - `tokenId` must exist.
182      *
183      * Emits an {Approval} event.
184      */
185     function approve(address to, uint256 tokenId) external;
186 
187     /**
188      * @dev Returns the account approved for `tokenId` token.
189      *
190      * Requirements:
191      *
192      * - `tokenId` must exist.
193      */
194     function getApproved(uint256 tokenId) external view returns (address operator);
195 
196     /**
197      * @dev Approve or remove `operator` as an operator for the caller.
198      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
199      *
200      * Requirements:
201      *
202      * - The `operator` cannot be the caller.
203      *
204      * Emits an {ApprovalForAll} event.
205      */
206     function setApprovalForAll(address operator, bool _approved) external;
207 
208     /**
209      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
210      *
211      * See {setApprovalForAll}
212      */
213     function isApprovedForAll(address owner, address operator) external view returns (bool);
214 
215     /**
216       * @dev Safely transfers `tokenId` token from `from` to `to`.
217       *
218       * Requirements:
219       *
220       * - `from` cannot be the zero address.
221       * - `to` cannot be the zero address.
222       * - `tokenId` token must exist and be owned by `from`.
223       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
224       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
225       *
226       * Emits a {Transfer} event.
227       */
228     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
229 }
230 
231 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
232 
233 
234 
235 pragma solidity >=0.6.0 <=0.8.5;
236 
237 
238 /**
239  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
240  * @dev See https://eips.ethereum.org/EIPS/eip-721
241  */
242 interface IERC721Metadata is IERC721 {
243 
244     /**
245      * @dev Returns the token collection name.
246      */
247     function name() external view returns (string memory);
248 
249     /**
250      * @dev Returns the token collection symbol.
251      */
252     function symbol() external view returns (string memory);
253 
254     /**
255      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
256      */
257     function tokenURI(uint256 tokenId) external view returns (string memory);
258 }
259 
260 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
261 
262 
263 
264 pragma solidity >=0.6.0 <=0.8.5;
265 
266 
267 /**
268  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
269  * @dev See https://eips.ethereum.org/EIPS/eip-721
270  */
271 interface IERC721Enumerable is IERC721 {
272 
273     /**
274      * @dev Returns the total amount of tokens stored by the contract.
275      */
276     function totalSupply() external view returns (uint256);
277 
278     /**
279      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
280      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
281      */
282     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
283 
284     /**
285      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
286      * Use along with {totalSupply} to enumerate all tokens.
287      */
288     function tokenByIndex(uint256 index) external view returns (uint256);
289 }
290 
291 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
292 
293 
294 
295 pragma solidity >=0.6.0 <=0.8.5;
296 
297 /**
298  * @title ERC721 token receiver interface
299  * @dev Interface for any contract that wants to support safeTransfers
300  * from ERC721 asset contracts.
301  */
302 interface IERC721Receiver {
303     /**
304      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
305      * by `operator` from `from`, this function is called.
306      *
307      * It must return its Solidity selector to confirm the token transfer.
308      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
309      *
310      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
311      */
312     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
313 }
314 
315 // File: @openzeppelin/contracts/introspection/ERC165.sol
316 
317 
318 
319 pragma solidity >=0.6.0 <=0.8.5;
320 
321 
322 /**
323  * @dev Implementation of the {IERC165} interface.
324  *
325  * Contracts may inherit from this and call {_registerInterface} to declare
326  * their support of an interface.
327  */
328 abstract contract ERC165 is IERC165 {
329     /*
330      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
331      */
332     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
333 
334     /**
335      * @dev Mapping of interface ids to whether or not it's supported.
336      */
337     mapping(bytes4 => bool) private _supportedInterfaces;
338 
339     constructor () internal {
340         // Derived contracts need only register support for their own interfaces,
341         // we register support for ERC165 itself here
342         _registerInterface(_INTERFACE_ID_ERC165);
343     }
344 
345     /**
346      * @dev See {IERC165-supportsInterface}.
347      *
348      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
349      */
350     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
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
366         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
367         _supportedInterfaces[interfaceId] = true;
368     }
369 }
370 
371 // File: @openzeppelin/contracts/math/SafeMath.sol
372 
373 
374 
375 pragma solidity >=0.6.0 <=0.8.5;
376 
377 /**
378  * @dev Wrappers over Solidity's arithmetic operations with added overflow
379  * checks.
380  *
381  * Arithmetic operations in Solidity wrap on overflow. This can easily result
382  * in bugs, because programmers usually assume that an overflow raises an
383  * error, which is the standard behavior in high level programming languages.
384  * `SafeMath` restores this intuition by reverting the transaction when an
385  * operation overflows.
386  *
387  * Using this library instead of the unchecked operations eliminates an entire
388  * class of bugs, so it's recommended to use it always.
389  */
390 library SafeMath {
391     /**
392      * @dev Returns the addition of two unsigned integers, with an overflow flag.
393      *
394      * _Available since v3.4._
395      */
396     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
397         uint256 c = a + b;
398         if (c < a) return (false, 0);
399         return (true, c);
400     }
401 
402     /**
403      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
404      *
405      * _Available since v3.4._
406      */
407     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
408         if (b > a) return (false, 0);
409         return (true, a - b);
410     }
411 
412     /**
413      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
414      *
415      * _Available since v3.4._
416      */
417     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
418         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
419         // benefit is lost if 'b' is also tested.
420         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
421         if (a == 0) return (true, 0);
422         uint256 c = a * b;
423         if (c / a != b) return (false, 0);
424         return (true, c);
425     }
426 
427     /**
428      * @dev Returns the division of two unsigned integers, with a division by zero flag.
429      *
430      * _Available since v3.4._
431      */
432     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
433         if (b == 0) return (false, 0);
434         return (true, a / b);
435     }
436 
437     /**
438      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
439      *
440      * _Available since v3.4._
441      */
442     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
443         if (b == 0) return (false, 0);
444         return (true, a % b);
445     }
446 
447     /**
448      * @dev Returns the addition of two unsigned integers, reverting on
449      * overflow.
450      *
451      * Counterpart to Solidity's `+` operator.
452      *
453      * Requirements:
454      *
455      * - Addition cannot overflow.
456      */
457     function add(uint256 a, uint256 b) internal pure returns (uint256) {
458         uint256 c = a + b;
459         require(c >= a, "SafeMath: addition overflow");
460         return c;
461     }
462 
463     /**
464      * @dev Returns the subtraction of two unsigned integers, reverting on
465      * overflow (when the result is negative).
466      *
467      * Counterpart to Solidity's `-` operator.
468      *
469      * Requirements:
470      *
471      * - Subtraction cannot overflow.
472      */
473     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
474         require(b <= a, "SafeMath: subtraction overflow");
475         return a - b;
476     }
477 
478     /**
479      * @dev Returns the multiplication of two unsigned integers, reverting on
480      * overflow.
481      *
482      * Counterpart to Solidity's `*` operator.
483      *
484      * Requirements:
485      *
486      * - Multiplication cannot overflow.
487      */
488     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
489         if (a == 0) return 0;
490         uint256 c = a * b;
491         require(c / a == b, "SafeMath: multiplication overflow");
492         return c;
493     }
494 
495     /**
496      * @dev Returns the integer division of two unsigned integers, reverting on
497      * division by zero. The result is rounded towards zero.
498      *
499      * Counterpart to Solidity's `/` operator. Note: this function uses a
500      * `revert` opcode (which leaves remaining gas untouched) while Solidity
501      * uses an invalid opcode to revert (consuming all remaining gas).
502      *
503      * Requirements:
504      *
505      * - The divisor cannot be zero.
506      */
507     function div(uint256 a, uint256 b) internal pure returns (uint256) {
508         require(b > 0, "SafeMath: division by zero");
509         return a / b;
510     }
511 
512     /**
513      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
514      * reverting when dividing by zero.
515      *
516      * Counterpart to Solidity's `%` operator. This function uses a `revert`
517      * opcode (which leaves remaining gas untouched) while Solidity uses an
518      * invalid opcode to revert (consuming all remaining gas).
519      *
520      * Requirements:
521      *
522      * - The divisor cannot be zero.
523      */
524     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
525         require(b > 0, "SafeMath: modulo by zero");
526         return a % b;
527     }
528 
529     /**
530      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
531      * overflow (when the result is negative).
532      *
533      * CAUTION: This function is deprecated because it requires allocating memory for the error
534      * message unnecessarily. For custom revert reasons use {trySub}.
535      *
536      * Counterpart to Solidity's `-` operator.
537      *
538      * Requirements:
539      *
540      * - Subtraction cannot overflow.
541      */
542     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
543         require(b <= a, errorMessage);
544         return a - b;
545     }
546 
547     /**
548      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
549      * division by zero. The result is rounded towards zero.
550      *
551      * CAUTION: This function is deprecated because it requires allocating memory for the error
552      * message unnecessarily. For custom revert reasons use {tryDiv}.
553      *
554      * Counterpart to Solidity's `/` operator. Note: this function uses a
555      * `revert` opcode (which leaves remaining gas untouched) while Solidity
556      * uses an invalid opcode to revert (consuming all remaining gas).
557      *
558      * Requirements:
559      *
560      * - The divisor cannot be zero.
561      */
562     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
563         require(b > 0, errorMessage);
564         return a / b;
565     }
566 
567     /**
568      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
569      * reverting with custom message when dividing by zero.
570      *
571      * CAUTION: This function is deprecated because it requires allocating memory for the error
572      * message unnecessarily. For custom revert reasons use {tryMod}.
573      *
574      * Counterpart to Solidity's `%` operator. This function uses a `revert`
575      * opcode (which leaves remaining gas untouched) while Solidity uses an
576      * invalid opcode to revert (consuming all remaining gas).
577      *
578      * Requirements:
579      *
580      * - The divisor cannot be zero.
581      */
582     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
583         require(b > 0, errorMessage);
584         return a % b;
585     }
586 }
587 
588 // File: @openzeppelin/contracts/utils/Address.sol
589 
590 
591 
592 pragma solidity >=0.6.0 <=0.8.5;
593 
594 /**
595  * @dev Collection of functions related to the address type
596  */
597 library Address {
598     /**
599      * @dev Returns true if `account` is a contract.
600      *
601      * [IMPORTANT]
602      * ====
603      * It is unsafe to assume that an address for which this function returns
604      * false is an externally-owned account (EOA) and not a contract.
605      *
606      * Among others, `isContract` will return false for the following
607      * types of addresses:
608      *
609      *  - an externally-owned account
610      *  - a contract in construction
611      *  - an address where a contract will be created
612      *  - an address where a contract lived, but was destroyed
613      * ====
614      */
615     function isContract(address account) internal view returns (bool) {
616         // This method relies on extcodesize, which returns 0 for contracts in
617         // construction, since the code is only stored at the end of the
618         // constructor execution.
619 
620         uint256 size;
621         // solhint-disable-next-line no-inline-assembly
622         assembly { size := extcodesize(account) }
623         return size > 0;
624     }
625 
626     /**
627      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
628      * `recipient`, forwarding all available gas and reverting on errors.
629      *
630      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
631      * of certain opcodes, possibly making contracts go over the 2300 gas limit
632      * imposed by `transfer`, making them unable to receive funds via
633      * `transfer`. {sendValue} removes this limitation.
634      *
635      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
636      *
637      * IMPORTANT: because control is transferred to `recipient`, care must be
638      * taken to not create reentrancy vulnerabilities. Consider using
639      * {ReentrancyGuard} or the
640      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
641      */
642     function sendValue(address payable recipient, uint256 amount) internal {
643         require(address(this).balance >= amount, "Address: insufficient balance");
644 
645         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
646         (bool success, ) = recipient.call{ value: amount }("");
647         require(success, "Address: unable to send value, recipient may have reverted");
648     }
649 
650     /**
651      * @dev Performs a Solidity function call using a low level `call`. A
652      * plain`call` is an unsafe replacement for a function call: use this
653      * function instead.
654      *
655      * If `target` reverts with a revert reason, it is bubbled up by this
656      * function (like regular Solidity function calls).
657      *
658      * Returns the raw returned data. To convert to the expected return value,
659      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
660      *
661      * Requirements:
662      *
663      * - `target` must be a contract.
664      * - calling `target` with `data` must not revert.
665      *
666      * _Available since v3.1._
667      */
668     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
669       return functionCall(target, data, "Address: low-level call failed");
670     }
671 
672     /**
673      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
674      * `errorMessage` as a fallback revert reason when `target` reverts.
675      *
676      * _Available since v3.1._
677      */
678     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
679         return functionCallWithValue(target, data, 0, errorMessage);
680     }
681 
682     /**
683      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
684      * but also transferring `value` wei to `target`.
685      *
686      * Requirements:
687      *
688      * - the calling contract must have an ETH balance of at least `value`.
689      * - the called Solidity function must be `payable`.
690      *
691      * _Available since v3.1._
692      */
693     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
694         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
695     }
696 
697     /**
698      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
699      * with `errorMessage` as a fallback revert reason when `target` reverts.
700      *
701      * _Available since v3.1._
702      */
703     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
704         require(address(this).balance >= value, "Address: insufficient balance for call");
705         require(isContract(target), "Address: call to non-contract");
706 
707         // solhint-disable-next-line avoid-low-level-calls
708         (bool success, bytes memory returndata) = target.call{ value: value }(data);
709         return _verifyCallResult(success, returndata, errorMessage);
710     }
711 
712     /**
713      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
714      * but performing a static call.
715      *
716      * _Available since v3.3._
717      */
718     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
719         return functionStaticCall(target, data, "Address: low-level static call failed");
720     }
721 
722     /**
723      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
724      * but performing a static call.
725      *
726      * _Available since v3.3._
727      */
728     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
729         require(isContract(target), "Address: static call to non-contract");
730 
731         // solhint-disable-next-line avoid-low-level-calls
732         (bool success, bytes memory returndata) = target.staticcall(data);
733         return _verifyCallResult(success, returndata, errorMessage);
734     }
735 
736     /**
737      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
738      * but performing a delegate call.
739      *
740      * _Available since v3.4._
741      */
742     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
743         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
744     }
745 
746     /**
747      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
748      * but performing a delegate call.
749      *
750      * _Available since v3.4._
751      */
752     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
753         require(isContract(target), "Address: delegate call to non-contract");
754 
755         // solhint-disable-next-line avoid-low-level-calls
756         (bool success, bytes memory returndata) = target.delegatecall(data);
757         return _verifyCallResult(success, returndata, errorMessage);
758     }
759 
760     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
761         if (success) {
762             return returndata;
763         } else {
764             // Look for revert reason and bubble it up if present
765             if (returndata.length > 0) {
766                 // The easiest way to bubble the revert reason is using memory via assembly
767 
768                 // solhint-disable-next-line no-inline-assembly
769                 assembly {
770                     let returndata_size := mload(returndata)
771                     revert(add(32, returndata), returndata_size)
772                 }
773             } else {
774                 revert(errorMessage);
775             }
776         }
777     }
778 }
779 
780 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
781 
782 
783 
784 pragma solidity >=0.6.0 <=0.8.5;
785 
786 /**
787  * @dev Library for managing
788  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
789  * types.
790  *
791  * Sets have the following properties:
792  *
793  * - Elements are added, removed, and checked for existence in constant time
794  * (O(1)).
795  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
796  *
797  * ```
798  * contract Example {
799  *     // Add the library methods
800  *     using EnumerableSet for EnumerableSet.AddressSet;
801  *
802  *     // Declare a set state variable
803  *     EnumerableSet.AddressSet private mySet;
804  * }
805  * ```
806  *
807  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
808  * and `uint256` (`UintSet`) are supported.
809  */
810 library EnumerableSet {
811     // To implement this library for multiple types with as little code
812     // repetition as possible, we write it in terms of a generic Set type with
813     // bytes32 values.
814     // The Set implementation uses private functions, and user-facing
815     // implementations (such as AddressSet) are just wrappers around the
816     // underlying Set.
817     // This means that we can only create new EnumerableSets for types that fit
818     // in bytes32.
819 
820     struct Set {
821         // Storage of set values
822         bytes32[] _values;
823 
824         // Position of the value in the `values` array, plus 1 because index 0
825         // means a value is not in the set.
826         mapping (bytes32 => uint256) _indexes;
827     }
828 
829     /**
830      * @dev Add a value to a set. O(1).
831      *
832      * Returns true if the value was added to the set, that is if it was not
833      * already present.
834      */
835     function _add(Set storage set, bytes32 value) private returns (bool) {
836         if (!_contains(set, value)) {
837             set._values.push(value);
838             // The value is stored at length-1, but we add 1 to all indexes
839             // and use 0 as a sentinel value
840             set._indexes[value] = set._values.length;
841             return true;
842         } else {
843             return false;
844         }
845     }
846 
847     /**
848      * @dev Removes a value from a set. O(1).
849      *
850      * Returns true if the value was removed from the set, that is if it was
851      * present.
852      */
853     function _remove(Set storage set, bytes32 value) private returns (bool) {
854         // We read and store the value's index to prevent multiple reads from the same storage slot
855         uint256 valueIndex = set._indexes[value];
856 
857         if (valueIndex != 0) { // Equivalent to contains(set, value)
858             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
859             // the array, and then remove the last element (sometimes called as 'swap and pop').
860             // This modifies the order of the array, as noted in {at}.
861 
862             uint256 toDeleteIndex = valueIndex - 1;
863             uint256 lastIndex = set._values.length - 1;
864 
865             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
866             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
867 
868             bytes32 lastvalue = set._values[lastIndex];
869 
870             // Move the last value to the index where the value to delete is
871             set._values[toDeleteIndex] = lastvalue;
872             // Update the index for the moved value
873             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
874 
875             // Delete the slot where the moved value was stored
876             set._values.pop();
877 
878             // Delete the index for the deleted slot
879             delete set._indexes[value];
880 
881             return true;
882         } else {
883             return false;
884         }
885     }
886 
887     /**
888      * @dev Returns true if the value is in the set. O(1).
889      */
890     function _contains(Set storage set, bytes32 value) private view returns (bool) {
891         return set._indexes[value] != 0;
892     }
893 
894     /**
895      * @dev Returns the number of values on the set. O(1).
896      */
897     function _length(Set storage set) private view returns (uint256) {
898         return set._values.length;
899     }
900 
901    /**
902     * @dev Returns the value stored at position `index` in the set. O(1).
903     *
904     * Note that there are no guarantees on the ordering of values inside the
905     * array, and it may change when more values are added or removed.
906     *
907     * Requirements:
908     *
909     * - `index` must be strictly less than {length}.
910     */
911     function _at(Set storage set, uint256 index) private view returns (bytes32) {
912         require(set._values.length > index, "EnumerableSet: index out of bounds");
913         return set._values[index];
914     }
915 
916     // Bytes32Set
917 
918     struct Bytes32Set {
919         Set _inner;
920     }
921 
922     /**
923      * @dev Add a value to a set. O(1).
924      *
925      * Returns true if the value was added to the set, that is if it was not
926      * already present.
927      */
928     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
929         return _add(set._inner, value);
930     }
931 
932     /**
933      * @dev Removes a value from a set. O(1).
934      *
935      * Returns true if the value was removed from the set, that is if it was
936      * present.
937      */
938     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
939         return _remove(set._inner, value);
940     }
941 
942     /**
943      * @dev Returns true if the value is in the set. O(1).
944      */
945     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
946         return _contains(set._inner, value);
947     }
948 
949     /**
950      * @dev Returns the number of values in the set. O(1).
951      */
952     function length(Bytes32Set storage set) internal view returns (uint256) {
953         return _length(set._inner);
954     }
955 
956    /**
957     * @dev Returns the value stored at position `index` in the set. O(1).
958     *
959     * Note that there are no guarantees on the ordering of values inside the
960     * array, and it may change when more values are added or removed.
961     *
962     * Requirements:
963     *
964     * - `index` must be strictly less than {length}.
965     */
966     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
967         return _at(set._inner, index);
968     }
969 
970     // AddressSet
971 
972     struct AddressSet {
973         Set _inner;
974     }
975 
976     /**
977      * @dev Add a value to a set. O(1).
978      *
979      * Returns true if the value was added to the set, that is if it was not
980      * already present.
981      */
982     function add(AddressSet storage set, address value) internal returns (bool) {
983         return _add(set._inner, bytes32(uint256(uint160(value))));
984     }
985 
986     /**
987      * @dev Removes a value from a set. O(1).
988      *
989      * Returns true if the value was removed from the set, that is if it was
990      * present.
991      */
992     function remove(AddressSet storage set, address value) internal returns (bool) {
993         return _remove(set._inner, bytes32(uint256(uint160(value))));
994     }
995 
996     /**
997      * @dev Returns true if the value is in the set. O(1).
998      */
999     function contains(AddressSet storage set, address value) internal view returns (bool) {
1000         return _contains(set._inner, bytes32(uint256(uint160(value))));
1001     }
1002 
1003     /**
1004      * @dev Returns the number of values in the set. O(1).
1005      */
1006     function length(AddressSet storage set) internal view returns (uint256) {
1007         return _length(set._inner);
1008     }
1009 
1010    /**
1011     * @dev Returns the value stored at position `index` in the set. O(1).
1012     *
1013     * Note that there are no guarantees on the ordering of values inside the
1014     * array, and it may change when more values are added or removed.
1015     *
1016     * Requirements:
1017     *
1018     * - `index` must be strictly less than {length}.
1019     */
1020     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1021         return address(uint160(uint256(_at(set._inner, index))));
1022     }
1023 
1024 
1025     // UintSet
1026 
1027     struct UintSet {
1028         Set _inner;
1029     }
1030 
1031     /**
1032      * @dev Add a value to a set. O(1).
1033      *
1034      * Returns true if the value was added to the set, that is if it was not
1035      * already present.
1036      */
1037     function add(UintSet storage set, uint256 value) internal returns (bool) {
1038         return _add(set._inner, bytes32(value));
1039     }
1040 
1041     /**
1042      * @dev Removes a value from a set. O(1).
1043      *
1044      * Returns true if the value was removed from the set, that is if it was
1045      * present.
1046      */
1047     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1048         return _remove(set._inner, bytes32(value));
1049     }
1050 
1051     /**
1052      * @dev Returns true if the value is in the set. O(1).
1053      */
1054     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1055         return _contains(set._inner, bytes32(value));
1056     }
1057 
1058     /**
1059      * @dev Returns the number of values on the set. O(1).
1060      */
1061     function length(UintSet storage set) internal view returns (uint256) {
1062         return _length(set._inner);
1063     }
1064 
1065    /**
1066     * @dev Returns the value stored at position `index` in the set. O(1).
1067     *
1068     * Note that there are no guarantees on the ordering of values inside the
1069     * array, and it may change when more values are added or removed.
1070     *
1071     * Requirements:
1072     *
1073     * - `index` must be strictly less than {length}.
1074     */
1075     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1076         return uint256(_at(set._inner, index));
1077     }
1078 }
1079 
1080 // File: @openzeppelin/contracts/utils/EnumerableMap.sol
1081 
1082 
1083 
1084 pragma solidity >=0.6.0 <=0.8.5;
1085 
1086 /**
1087  * @dev Library for managing an enumerable variant of Solidity's
1088  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1089  * type.
1090  *
1091  * Maps have the following properties:
1092  *
1093  * - Entries are added, removed, and checked for existence in constant time
1094  * (O(1)).
1095  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1096  *
1097  * ```
1098  * contract Example {
1099  *     // Add the library methods
1100  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1101  *
1102  *     // Declare a set state variable
1103  *     EnumerableMap.UintToAddressMap private myMap;
1104  * }
1105  * ```
1106  *
1107  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1108  * supported.
1109  */
1110 library EnumerableMap {
1111     // To implement this library for multiple types with as little code
1112     // repetition as possible, we write it in terms of a generic Map type with
1113     // bytes32 keys and values.
1114     // The Map implementation uses private functions, and user-facing
1115     // implementations (such as Uint256ToAddressMap) are just wrappers around
1116     // the underlying Map.
1117     // This means that we can only create new EnumerableMaps for types that fit
1118     // in bytes32.
1119 
1120     struct MapEntry {
1121         bytes32 _key;
1122         bytes32 _value;
1123     }
1124 
1125     struct Map {
1126         // Storage of map keys and values
1127         MapEntry[] _entries;
1128 
1129         // Position of the entry defined by a key in the `entries` array, plus 1
1130         // because index 0 means a key is not in the map.
1131         mapping (bytes32 => uint256) _indexes;
1132     }
1133 
1134     /**
1135      * @dev Adds a key-value pair to a map, or updates the value for an existing
1136      * key. O(1).
1137      *
1138      * Returns true if the key was added to the map, that is if it was not
1139      * already present.
1140      */
1141     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1142         // We read and store the key's index to prevent multiple reads from the same storage slot
1143         uint256 keyIndex = map._indexes[key];
1144 
1145         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1146             map._entries.push(MapEntry({ _key: key, _value: value }));
1147             // The entry is stored at length-1, but we add 1 to all indexes
1148             // and use 0 as a sentinel value
1149             map._indexes[key] = map._entries.length;
1150             return true;
1151         } else {
1152             map._entries[keyIndex - 1]._value = value;
1153             return false;
1154         }
1155     }
1156 
1157     /**
1158      * @dev Removes a key-value pair from a map. O(1).
1159      *
1160      * Returns true if the key was removed from the map, that is if it was present.
1161      */
1162     function _remove(Map storage map, bytes32 key) private returns (bool) {
1163         // We read and store the key's index to prevent multiple reads from the same storage slot
1164         uint256 keyIndex = map._indexes[key];
1165 
1166         if (keyIndex != 0) { // Equivalent to contains(map, key)
1167             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1168             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1169             // This modifies the order of the array, as noted in {at}.
1170 
1171             uint256 toDeleteIndex = keyIndex - 1;
1172             uint256 lastIndex = map._entries.length - 1;
1173 
1174             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1175             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1176 
1177             MapEntry storage lastEntry = map._entries[lastIndex];
1178 
1179             // Move the last entry to the index where the entry to delete is
1180             map._entries[toDeleteIndex] = lastEntry;
1181             // Update the index for the moved entry
1182             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1183 
1184             // Delete the slot where the moved entry was stored
1185             map._entries.pop();
1186 
1187             // Delete the index for the deleted slot
1188             delete map._indexes[key];
1189 
1190             return true;
1191         } else {
1192             return false;
1193         }
1194     }
1195 
1196     /**
1197      * @dev Returns true if the key is in the map. O(1).
1198      */
1199     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1200         return map._indexes[key] != 0;
1201     }
1202 
1203     /**
1204      * @dev Returns the number of key-value pairs in the map. O(1).
1205      */
1206     function _length(Map storage map) private view returns (uint256) {
1207         return map._entries.length;
1208     }
1209 
1210    /**
1211     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1212     *
1213     * Note that there are no guarantees on the ordering of entries inside the
1214     * array, and it may change when more entries are added or removed.
1215     *
1216     * Requirements:
1217     *
1218     * - `index` must be strictly less than {length}.
1219     */
1220     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1221         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1222 
1223         MapEntry storage entry = map._entries[index];
1224         return (entry._key, entry._value);
1225     }
1226 
1227     /**
1228      * @dev Tries to returns the value associated with `key`.  O(1).
1229      * Does not revert if `key` is not in the map.
1230      */
1231     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
1232         uint256 keyIndex = map._indexes[key];
1233         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1234         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1235     }
1236 
1237     /**
1238      * @dev Returns the value associated with `key`.  O(1).
1239      *
1240      * Requirements:
1241      *
1242      * - `key` must be in the map.
1243      */
1244     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1245         uint256 keyIndex = map._indexes[key];
1246         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1247         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1248     }
1249 
1250     /**
1251      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1252      *
1253      * CAUTION: This function is deprecated because it requires allocating memory for the error
1254      * message unnecessarily. For custom revert reasons use {_tryGet}.
1255      */
1256     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1257         uint256 keyIndex = map._indexes[key];
1258         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1259         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1260     }
1261 
1262     // UintToAddressMap
1263 
1264     struct UintToAddressMap {
1265         Map _inner;
1266     }
1267 
1268     /**
1269      * @dev Adds a key-value pair to a map, or updates the value for an existing
1270      * key. O(1).
1271      *
1272      * Returns true if the key was added to the map, that is if it was not
1273      * already present.
1274      */
1275     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1276         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1277     }
1278 
1279     /**
1280      * @dev Removes a value from a set. O(1).
1281      *
1282      * Returns true if the key was removed from the map, that is if it was present.
1283      */
1284     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1285         return _remove(map._inner, bytes32(key));
1286     }
1287 
1288     /**
1289      * @dev Returns true if the key is in the map. O(1).
1290      */
1291     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1292         return _contains(map._inner, bytes32(key));
1293     }
1294 
1295     /**
1296      * @dev Returns the number of elements in the map. O(1).
1297      */
1298     function length(UintToAddressMap storage map) internal view returns (uint256) {
1299         return _length(map._inner);
1300     }
1301 
1302    /**
1303     * @dev Returns the element stored at position `index` in the set. O(1).
1304     * Note that there are no guarantees on the ordering of values inside the
1305     * array, and it may change when more values are added or removed.
1306     *
1307     * Requirements:
1308     *
1309     * - `index` must be strictly less than {length}.
1310     */
1311     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1312         (bytes32 key, bytes32 value) = _at(map._inner, index);
1313         return (uint256(key), address(uint160(uint256(value))));
1314     }
1315 
1316     /**
1317      * @dev Tries to returns the value associated with `key`.  O(1).
1318      * Does not revert if `key` is not in the map.
1319      *
1320      * _Available since v3.4._
1321      */
1322     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
1323         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1324         return (success, address(uint160(uint256(value))));
1325     }
1326 
1327     /**
1328      * @dev Returns the value associated with `key`.  O(1).
1329      *
1330      * Requirements:
1331      *
1332      * - `key` must be in the map.
1333      */
1334     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1335         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1336     }
1337 
1338     /**
1339      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1340      *
1341      * CAUTION: This function is deprecated because it requires allocating memory for the error
1342      * message unnecessarily. For custom revert reasons use {tryGet}.
1343      */
1344     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1345         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
1346     }
1347 }
1348 
1349 // File: @openzeppelin/contracts/utils/Strings.sol
1350 
1351 
1352 
1353 pragma solidity >=0.6.0 <=0.8.5;
1354 
1355 /**
1356  * @dev String operations.
1357  */
1358 library Strings {
1359     /**
1360      * @dev Converts a `uint256` to its ASCII `string` representation.
1361      */
1362     function toString(uint256 value) internal pure returns (string memory) {
1363         // Inspired by OraclizeAPI's implementation - MIT licence
1364         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1365 
1366         if (value == 0) {
1367             return "0";
1368         }
1369         uint256 temp = value;
1370         uint256 digits;
1371         while (temp != 0) {
1372             digits++;
1373             temp /= 10;
1374         }
1375         bytes memory buffer = new bytes(digits);
1376         uint256 index = digits - 1;
1377         temp = value;
1378         while (temp != 0) {
1379             buffer[index--] = bytes1(uint8(48 + temp % 10));
1380             temp /= 10;
1381         }
1382         return string(buffer);
1383     }
1384 }
1385 
1386 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1387 
1388 pragma solidity >=0.6.0 <=0.8.5;
1389 
1390 /**
1391  * @title ERC721 Non-Fungible Token Standard basic implementation
1392  * @dev see https://eips.ethereum.org/EIPS/eip-721
1393  */
1394 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1395     using SafeMath for uint256;
1396     using Address for address;
1397     using EnumerableSet for EnumerableSet.UintSet;
1398     using EnumerableMap for EnumerableMap.UintToAddressMap;
1399     using Strings for uint256;
1400 
1401     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1402     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1403     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1404 
1405     // Mapping from holder address to their (enumerable) set of owned tokens
1406     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1407 
1408     // Enumerable mapping from token ids to their owners
1409     EnumerableMap.UintToAddressMap private _tokenOwners;
1410 
1411     // Mapping from token ID to approved address
1412     mapping (uint256 => address) private _tokenApprovals;
1413 
1414     // Mapping from owner to operator approvals
1415     mapping (address => mapping (address => bool)) private _operatorApprovals;
1416 
1417     // Token name
1418     string private _name;
1419 
1420     // Token symbol
1421     string private _symbol;
1422 
1423     // Optional mapping for token URIs
1424     mapping (uint256 => string) private _tokenURIs;
1425 
1426     // Base URI
1427     string private _baseURI;
1428 
1429     /*
1430      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1431      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1432      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1433      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1434      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1435      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1436      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1437      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1438      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1439      *
1440      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1441      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1442      */
1443     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1444 
1445     /*
1446      *     bytes4(keccak256('name()')) == 0x06fdde03
1447      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1448      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1449      *
1450      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1451      */
1452     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1453 
1454     /*
1455      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1456      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1457      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1458      *
1459      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1460      */
1461     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1462 
1463     /**
1464      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1465      */
1466     constructor (string memory name_, string memory symbol_) public {
1467         _name = name_;
1468         _symbol = symbol_;
1469 
1470         // register the supported interfaces to conform to ERC721 via ERC165
1471         _registerInterface(_INTERFACE_ID_ERC721);
1472         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1473         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1474     }
1475 
1476     /**
1477      * @dev See {IERC721-balanceOf}.
1478      */
1479     function balanceOf(address owner) public view virtual override returns (uint256) {
1480         require(owner != address(0), "ERC721: balance query for the zero address");
1481         return _holderTokens[owner].length();
1482     }
1483 
1484     /**
1485      * @dev See {IERC721-ownerOf}.
1486      */
1487     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1488         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1489     }
1490 
1491     /**
1492      * @dev See {IERC721Metadata-name}.
1493      */
1494     function name() public view virtual override returns (string memory) {
1495         return _name;
1496     }
1497 
1498     /**
1499      * @dev See {IERC721Metadata-symbol}.
1500      */
1501     function symbol() public view virtual override returns (string memory) {
1502         return _symbol;
1503     }
1504 
1505     /**
1506      * @dev See {IERC721Metadata-tokenURI}.
1507      */
1508     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1509         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1510 
1511         string memory _tokenURI = _tokenURIs[tokenId];
1512         string memory base = baseURI();
1513 
1514         // If there is no base URI, return the token URI.
1515         if (bytes(base).length == 0) {
1516             return _tokenURI;
1517         }
1518         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1519         if (bytes(_tokenURI).length > 0) {
1520             return string(abi.encodePacked(base, _tokenURI));
1521         }
1522         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1523         return string(abi.encodePacked(base, tokenId.toString()));
1524     }
1525 
1526     /**
1527     * @dev Returns the base URI set via {_setBaseURI}. This will be
1528     * automatically added as a prefix in {tokenURI} to each token's URI, or
1529     * to the token ID if no specific URI is set for that token ID.
1530     */
1531     function baseURI() public view virtual returns (string memory) {
1532         return _baseURI;
1533     }
1534 
1535     /**
1536      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1537      */
1538     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1539         return _holderTokens[owner].at(index);
1540     }
1541 
1542     /**
1543      * @dev See {IERC721Enumerable-totalSupply}.
1544      */
1545     function totalSupply() public view virtual override returns (uint256) {
1546         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1547         return _tokenOwners.length();
1548     }
1549 
1550     /**
1551      * @dev See {IERC721Enumerable-tokenByIndex}.
1552      */
1553     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1554         (uint256 tokenId, ) = _tokenOwners.at(index);
1555         return tokenId;
1556     }
1557 
1558     /**
1559      * @dev See {IERC721-approve}.
1560      */
1561     function approve(address to, uint256 tokenId) public virtual override {
1562         address owner = ERC721.ownerOf(tokenId);
1563         require(to != owner, "ERC721: approval to current owner");
1564 
1565         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1566             "ERC721: approve caller is not owner nor approved for all"
1567         );
1568 
1569         _approve(to, tokenId);
1570     }
1571 
1572     /**
1573      * @dev See {IERC721-getApproved}.
1574      */
1575     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1576         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1577 
1578         return _tokenApprovals[tokenId];
1579     }
1580 
1581     /**
1582      * @dev See {IERC721-setApprovalForAll}.
1583      */
1584     function setApprovalForAll(address operator, bool approved) public virtual override {
1585         require(operator != _msgSender(), "ERC721: approve to caller");
1586 
1587         _operatorApprovals[_msgSender()][operator] = approved;
1588         emit ApprovalForAll(_msgSender(), operator, approved);
1589     }
1590 
1591     /**
1592      * @dev See {IERC721-isApprovedForAll}.
1593      */
1594     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1595         return _operatorApprovals[owner][operator];
1596     }
1597 
1598     /**
1599      * @dev See {IERC721-transferFrom}.
1600      */
1601     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1602         //solhint-disable-next-line max-line-length
1603         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1604 
1605         _transfer(from, to, tokenId);
1606     }
1607 
1608     /**
1609      * @dev See {IERC721-safeTransferFrom}.
1610      */
1611     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1612         safeTransferFrom(from, to, tokenId, "");
1613     }
1614 
1615     /**
1616      * @dev See {IERC721-safeTransferFrom}.
1617      */
1618     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1619         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1620         _safeTransfer(from, to, tokenId, _data);
1621     }
1622 
1623     /**
1624      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1625      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1626      *
1627      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1628      *
1629      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1630      * implement alternative mechanisms to perform token transfer, such as signature-based.
1631      *
1632      * Requirements:
1633      *
1634      * - `from` cannot be the zero address.
1635      * - `to` cannot be the zero address.
1636      * - `tokenId` token must exist and be owned by `from`.
1637      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1638      *
1639      * Emits a {Transfer} event.
1640      */
1641     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1642         _transfer(from, to, tokenId);
1643         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1644     }
1645 
1646     /**
1647      * @dev Returns whether `tokenId` exists.
1648      *
1649      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1650      *
1651      * Tokens start existing when they are minted (`_mint`),
1652      * and stop existing when they are burned (`_burn`).
1653      */
1654     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1655         return _tokenOwners.contains(tokenId);
1656     }
1657 
1658     /**
1659      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1660      *
1661      * Requirements:
1662      *
1663      * - `tokenId` must exist.
1664      */
1665     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1666         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1667         address owner = ERC721.ownerOf(tokenId);
1668         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1669     }
1670 
1671     /**
1672      * @dev Safely mints `tokenId` and transfers it to `to`.
1673      *
1674      * Requirements:
1675      d*
1676      * - `tokenId` must not exist.
1677      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1678      *
1679      * Emits a {Transfer} event.
1680      */
1681     function _safeMint(address to, uint256 tokenId) internal virtual {
1682         _safeMint(to, tokenId, "");
1683     }
1684 
1685     /**
1686      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1687      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1688      */
1689     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1690         _mint(to, tokenId);
1691         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1692     }
1693 
1694     /**
1695      * @dev Mints `tokenId` and transfers it to `to`.
1696      *
1697      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1698      *
1699      * Requirements:
1700      *
1701      * - `tokenId` must not exist.
1702      * - `to` cannot be the zero address.
1703      *
1704      * Emits a {Transfer} event.
1705      */
1706     function _mint(address to, uint256 tokenId) internal virtual {
1707         require(to != address(0), "ERC721: mint to the zero address");
1708         require(!_exists(tokenId), "ERC721: token already minted");
1709 
1710         _beforeTokenTransfer(address(0), to, tokenId);
1711 
1712         _holderTokens[to].add(tokenId);
1713 
1714         _tokenOwners.set(tokenId, to);
1715 
1716         emit Transfer(address(0), to, tokenId);
1717     }
1718 
1719     /**
1720      * @dev Destroys `tokenId`.
1721      * The approval is cleared when the token is burned.
1722      *
1723      * Requirements:
1724      *
1725      * - `tokenId` must exist.
1726      *
1727      * Emits a {Transfer} event.
1728      */
1729     function _burn(uint256 tokenId) internal virtual {
1730         address owner = ERC721.ownerOf(tokenId); // internal owner
1731 
1732         _beforeTokenTransfer(owner, address(0), tokenId);
1733 
1734         // Clear approvals
1735         _approve(address(0), tokenId);
1736 
1737         // Clear metadata (if any)
1738         if (bytes(_tokenURIs[tokenId]).length != 0) {
1739             delete _tokenURIs[tokenId];
1740         }
1741 
1742         _holderTokens[owner].remove(tokenId);
1743 
1744         _tokenOwners.remove(tokenId);
1745 
1746         emit Transfer(owner, address(0), tokenId);
1747     }
1748 
1749     /**
1750      * @dev Transfers `tokenId` from `from` to `to`.
1751      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1752      *
1753      * Requirements:
1754      *
1755      * - `to` cannot be the zero address.
1756      * - `tokenId` token must be owned by `from`.
1757      *
1758      * Emits a {Transfer} event.
1759      */
1760     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1761         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1762         require(to != address(0), "ERC721: transfer to the zero address");
1763 
1764         _beforeTokenTransfer(from, to, tokenId);
1765 
1766         // Clear approvals from the previous owner
1767         _approve(address(0), tokenId);
1768 
1769         _holderTokens[from].remove(tokenId);
1770         _holderTokens[to].add(tokenId);
1771 
1772         _tokenOwners.set(tokenId, to);
1773 
1774         emit Transfer(from, to, tokenId);
1775     }
1776 
1777     /**
1778      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1779      *
1780      * Requirements:
1781      *
1782      * - `tokenId` must exist.
1783      */
1784     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1785         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1786         _tokenURIs[tokenId] = _tokenURI;
1787     }
1788 
1789     /**
1790      * @dev Internal function to set the base URI for all token IDs. It is
1791      * automatically added as a prefix to the value returned in {tokenURI},
1792      * or to the token ID if {tokenURI} is empty.
1793      */
1794     function _setBaseURI(string memory baseURI_) internal virtual {
1795         _baseURI = baseURI_;
1796     }
1797 
1798     /**
1799      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1800      * The call is not executed if the target address is not a contract.
1801      *
1802      * @param from address representing the previous owner of the given token ID
1803      * @param to target address that will receive the tokens
1804      * @param tokenId uint256 ID of the token to be transferred
1805      * @param _data bytes optional data to send along with the call
1806      * @return bool whether the call correctly returned the expected magic value
1807      */
1808     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1809         private returns (bool)
1810     {
1811         if (!to.isContract()) {
1812             return true;
1813         }
1814         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1815             IERC721Receiver(to).onERC721Received.selector,
1816             _msgSender(),
1817             from,
1818             tokenId,
1819             _data
1820         ), "ERC721: transfer to non ERC721Receiver implementer");
1821         bytes4 retval = abi.decode(returndata, (bytes4));
1822         return (retval == _ERC721_RECEIVED);
1823     }
1824 
1825     /**
1826      * @dev Approve `to` to operate on `tokenId`
1827      *
1828      * Emits an {Approval} event.
1829      */
1830     function _approve(address to, uint256 tokenId) internal virtual {
1831         _tokenApprovals[tokenId] = to;
1832         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1833     }
1834 
1835     /**
1836      * @dev Hook that is called before any token transfer. This includes minting
1837      * and burning.
1838      *
1839      * Calling conditions:
1840      *
1841      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1842      * transferred to `to`.
1843      * - When `from` is zero, `tokenId` will be minted for `to`.
1844      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1845      * - `from` cannot be the zero address.
1846      * - `to` cannot be the zero address.
1847      *
1848      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1849      */
1850     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1851 }
1852 
1853 // File: @openzeppelin/contracts/access/Ownable.sol
1854 
1855 pragma solidity >=0.6.0 <=0.8.5;
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
1921 /**
1922  * @title The Global Digital Rights Charter contract
1923  * @dev Extends ERC721 Non-Fungible Token Standard basic implementation
1924  */
1925 
1926 pragma solidity ^0.8.5;
1927 
1928 contract TheGlobalDigitalRightsCharter1 is ERC721, Ownable {
1929     using SafeMath for uint256;
1930 
1931     bool public mintingIsActive = false;
1932 
1933     constructor(string memory name, string memory symbol) ERC721(name, symbol) {
1934     }
1935 
1936     /*     
1937     * Withdraw any funds accidentaly sent to the smart contract
1938     */
1939     function withdraw() public onlyOwner {
1940         uint balance = address(this).balance;
1941         payable(msg.sender).transfer(balance);
1942     }
1943 
1944     /*     
1945     * Set Base URI
1946     */
1947     function setBaseURI(string memory baseURI) public onlyOwner {
1948         _setBaseURI(baseURI);
1949     }
1950 
1951     /*
1952     * Pause minting if active, make active if paused
1953     */
1954     function flipMintingState() public onlyOwner {
1955         mintingIsActive = !mintingIsActive;
1956     }
1957 
1958     /**
1959     * Mints The Global Digital Rights Charter NFTs
1960     */
1961     function mintDigitalRightsCharterTokens(uint numberOfTokens) public payable {
1962         require(mintingIsActive, "Minting must be active to mint");
1963         for(uint i = 0; i < numberOfTokens; i++) {
1964             uint mintIndex = totalSupply();
1965                 _safeMint(msg.sender, mintIndex);
1966         }
1967     }
1968 
1969     /**
1970     * Returns same tokenURI for all tokens
1971     */
1972     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1973         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1974         string memory base = baseURI();
1975         return string(abi.encodePacked(base));
1976     }
1977 
1978 }