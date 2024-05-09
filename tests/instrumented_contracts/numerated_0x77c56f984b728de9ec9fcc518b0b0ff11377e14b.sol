1 //                             ...----....
2 //                         ..-:"''         ''"-..
3 //                      .-'                      '-.
4 //                    .'              .     .       '.
5 //                  .'   .          .    .      .    .''.
6 //                .'  .    .       .   .   .     .   . ..:.
7 //              .' .   . .  .       .   .   ..  .   . ....::.
8 //             ..   .   .      .  .    .     .  ..  . ....:IA.
9 //            .:  .   .    .    .  .  .    .. .  .. .. ....:IA.
10 //           .: .   .   ..   .    .     . . .. . ... ....:.:VHA.
11 //           '..  .  .. .   .       .  . .. . .. . .....:.::IHHB.
12 //          .:. .  . .  . .   .  .  . . . ...:.:... .......:HIHMM.
13 //         .:.... .   . ."::"'.. .   .  . .:.:.:II;,. .. ..:IHIMMA
14 //         ':.:..  ..::IHHHHHI::. . .  ...:.::::.,,,. . ....VIMMHM
15 //        .:::I. .AHHHHHHHHHHAI::. .:...,:IIHHHHHHMMMHHL:. . VMMMM
16 //       .:.:V.:IVHHHHHHHMHMHHH::..:" .:HIHHHHHHHHHHHHHMHHA. .VMMM.
17 //       :..V.:IVHHHHHMMHHHHHHHB... . .:VPHHMHHHMMHHHHHHHHHAI.:VMMI
18 //       ::V..:VIHHHHHHMMMHHHHHH. .   .I":IIMHHMMHHHHHHHHHHHAPI:WMM
19 //       ::". .:.HHHHHHHHMMHHHHHI.  . .:..I:MHMMHHHHHHHHHMHV:':H:WM
20 //       :: . :.::IIHHHHHHMMHHHHV  .ABA.:.:IMHMHMMMHMHHHHV:'. .IHWW
21 //       '.  ..:..:.:IHHHHHMMHV" .AVMHMA.:.'VHMMMMHHHHHV:' .  :IHWV
22 //        :.  .:...:".:.:TPP"   .AVMMHMMA.:. "VMMHHHP.:... .. :IVAI
23 //       .:.   '... .:"'   .   ..HMMMHMMMA::. ."VHHI:::....  .:IHW'
24 //       ...  .  . ..:IIPPIH: ..HMMMI.MMMV:I:.  .:ILLH:.. ...:I:IM
25 //     : .   .'"' .:.V". .. .  :HMMM:IMMMI::I. ..:HHIIPPHI::'.P:HM.
26 //     :.  .  .  .. ..:.. .    :AMMM IMMMM..:...:IV":T::I::.".:IHIMA
27 //     'V:.. .. . .. .  .  .   'VMMV..VMMV :....:V:.:..:....::IHHHMH
28 //       "IHH:.II:.. .:. .  . . . " :HB"" . . ..PI:.::.:::..:IHHMMV"
29 //        :IP""HHII:.  .  .    . . .'V:. . . ..:IH:.:.::IHIHHMMMMM"
30 //        :V:. VIMA:I..  .     .  . .. . .  .:.I:I:..:IHHHHMMHHMMM
31 //        :"VI:.VWMA::. .:      .   .. .:. ..:.I::.:IVHHHMMMHMMMMI
32 //        :."VIIHHMMA:.  .   .   .:  .:.. . .:.II:I:AMMMMMMHMMMMMI
33 //        :..VIHIHMMMI...::.,:.,:!"I:!"I!"I!"V:AI:VAMMMMMMHMMMMMM'
34 //        ':.:HIHIMHHA:"!!"I.:AXXXVVXXXXXXXA:."HPHIMMMMHHMHMMMMMV
35 //          V:H:I:MA:W'I :AXXXIXII:IIIISSSSSSXXA.I.VMMMHMHMMMMMM
36 //            'I::IVA ASSSSXSSSSBBSBMBSSSSSSBBMMMBS.VVMMHIMM'"'
37 //             I:: VPAIMSSSSSSSSSBSSSMMBSSSBBMMMMXXI:MMHIMMI
38 //            .I::. "H:XIIXBBMMMMMMMMMMMMMMMMMBXIXXMMPHIIMM'
39 //            :::I.  ':XSSXXIIIIXSSBMBSSXXXIIIXXSMMAMI:.IMM
40 //            :::I:.  .VSSSSSISISISSSBII:ISSSSBMMB:MI:..:MM
41 //            ::.I:.  ':"SSSSSSSISISSXIIXSSSSBMMB:AHI:..MMM.
42 //            ::.I:. . ..:"BBSSSSSSSSSSSSBBBMMMB:AHHI::.HMMI
43 //            :..::.  . ..::":BBBBBSSBBBMMMB:MMMMHHII::IHHMI
44 //            ':.I:... ....:IHHHHHMMMMMMMMMMMMMMMHHIIIIHMMV"
45 //              "V:. ..:...:.IHHHMMMMMMMMMMMMMMMMHHHMHHMHP'
46 //               ':. .:::.:.::III::IHHHHMMMMMHMHMMHHHHM"
47 //                 "::....::.:::..:..::IIIIIHHHHMMMHHMV"
48 //                   "::.::.. .. .  ...:::IIHHMMMMHMV"
49 //                     "V::... . .I::IHHMMV"'
50 //                       '"VHVHHHAHHHHMMV:"'
51 //                                                                     
52 //                                          ,,                          
53 // `7MMF'                       `7MM        db                          
54 //   MM                           MM                                    
55 //   MM         ,pW"Wq.   ,p6"bo  MM  ,MP'`7MM  ,6"Yb.`7M'    ,A    `MF'
56 //   MM        6W'   `Wb 6M'  OO  MM ;Y     MM 8)   MM  VA   ,VAA   ,V  
57 //   MM      , 8M     M8 8M       MM;Mm     MM  ,pm9MM   VA ,V  VA ,V   
58 //   MM     ,M YA.   ,A9 YM.    , MM `Mb.   MM 8M   MM    VVV    VVV    
59 // .JMMmmmmMMM  `Ybmd9'   YMbmd'.JMML. YA.  MM `Moo9^Yo.   W      W     
60 //                                       QO MP                          
61 //                                       `bmP                           
62 
63 
64 pragma solidity >=0.6.0 <0.8.0;
65 
66 /*
67  * @dev Provides information about the current execution context, including the
68  * sender of the transaction and its data. While these are generally available
69  * via msg.sender and msg.data, they should not be accessed in such a direct
70  * manner, since when dealing with GSN meta-transactions the account sending and
71  * paying for execution may not be the actual sender (as far as an application
72  * is concerned).
73  *
74  * This contract is only required for intermediate, library-like contracts.
75  */
76 abstract contract Context {
77     function _msgSender() internal view virtual returns (address payable) {
78         return msg.sender;
79     }
80 
81     function _msgData() internal view virtual returns (bytes memory) {
82         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
83         return msg.data;
84     }
85 }
86 
87 // File: @openzeppelin/contracts/introspection/IERC165.sol
88 
89 
90 
91 pragma solidity >=0.6.0 <0.8.0;
92 
93 /**
94  * @dev Interface of the ERC165 standard, as defined in the
95  * https://eips.ethereum.org/EIPS/eip-165[EIP].
96  *
97  * Implementers can declare support of contract interfaces, which can then be
98  * queried by others ({ERC165Checker}).
99  *
100  * For an implementation, see {ERC165}.
101  */
102 interface IERC165 {
103     /**
104      * @dev Returns true if this contract implements the interface defined by
105      * `interfaceId`. See the corresponding
106      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
107      * to learn more about how these ids are created.
108      *
109      * This function call must use less than 30 000 gas.
110      */
111     function supportsInterface(bytes4 interfaceId) external view returns (bool);
112 }
113 
114 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
115 
116 
117 
118 pragma solidity >=0.6.2 <0.8.0;
119 
120 
121 /**
122  * @dev Required interface of an ERC721 compliant contract.
123  */
124 interface IERC721 is IERC165 {
125     /**
126      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
127      */
128     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
129 
130     /**
131      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
132      */
133     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
134 
135     /**
136      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
137      */
138     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
139 
140     /**
141      * @dev Returns the number of tokens in ``owner``'s account.
142      */
143     function balanceOf(address owner) external view returns (uint256 balance);
144 
145     /**
146      * @dev Returns the owner of the `tokenId` token.
147      *
148      * Requirements:
149      *
150      * - `tokenId` must exist.
151      */
152     function ownerOf(uint256 tokenId) external view returns (address owner);
153 
154     /**
155      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
156      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
157      *
158      * Requirements:
159      *
160      * - `from` cannot be the zero address.
161      * - `to` cannot be the zero address.
162      * - `tokenId` token must exist and be owned by `from`.
163      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
164      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
165      *
166      * Emits a {Transfer} event.
167      */
168     function safeTransferFrom(address from, address to, uint256 tokenId) external;
169 
170     /**
171      * @dev Transfers `tokenId` token from `from` to `to`.
172      *
173      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
174      *
175      * Requirements:
176      *
177      * - `from` cannot be the zero address.
178      * - `to` cannot be the zero address.
179      * - `tokenId` token must be owned by `from`.
180      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
181      *
182      * Emits a {Transfer} event.
183      */
184     function transferFrom(address from, address to, uint256 tokenId) external;
185 
186     /**
187      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
188      * The approval is cleared when the token is transferred.
189      *
190      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
191      *
192      * Requirements:
193      *
194      * - The caller must own the token or be an approved operator.
195      * - `tokenId` must exist.
196      *
197      * Emits an {Approval} event.
198      */
199     function approve(address to, uint256 tokenId) external;
200 
201     /**
202      * @dev Returns the account approved for `tokenId` token.
203      *
204      * Requirements:
205      *
206      * - `tokenId` must exist.
207      */
208     function getApproved(uint256 tokenId) external view returns (address operator);
209 
210     /**
211      * @dev Approve or remove `operator` as an operator for the caller.
212      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
213      *
214      * Requirements:
215      *
216      * - The `operator` cannot be the caller.
217      *
218      * Emits an {ApprovalForAll} event.
219      */
220     function setApprovalForAll(address operator, bool _approved) external;
221 
222     /**
223      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
224      *
225      * See {setApprovalForAll}
226      */
227     function isApprovedForAll(address owner, address operator) external view returns (bool);
228 
229     /**
230       * @dev Safely transfers `tokenId` token from `from` to `to`.
231       *
232       * Requirements:
233       *
234       * - `from` cannot be the zero address.
235       * - `to` cannot be the zero address.
236       * - `tokenId` token must exist and be owned by `from`.
237       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
238       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
239       *
240       * Emits a {Transfer} event.
241       */
242     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
243 }
244 
245 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
246 
247 
248 
249 pragma solidity >=0.6.2 <0.8.0;
250 
251 
252 /**
253  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
254  * @dev See https://eips.ethereum.org/EIPS/eip-721
255  */
256 interface IERC721Metadata is IERC721 {
257 
258     /**
259      * @dev Returns the token collection name.
260      */
261     function name() external view returns (string memory);
262 
263     /**
264      * @dev Returns the token collection symbol.
265      */
266     function symbol() external view returns (string memory);
267 
268     /**
269      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
270      */
271     function tokenURI(uint256 tokenId) external view returns (string memory);
272 }
273 
274 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
275 
276 
277 
278 pragma solidity >=0.6.2 <0.8.0;
279 
280 
281 /**
282  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
283  * @dev See https://eips.ethereum.org/EIPS/eip-721
284  */
285 interface IERC721Enumerable is IERC721 {
286 
287     /**
288      * @dev Returns the total amount of tokens stored by the contract.
289      */
290     function totalSupply() external view returns (uint256);
291 
292     /**
293      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
294      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
295      */
296     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
297 
298     /**
299      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
300      * Use along with {totalSupply} to enumerate all tokens.
301      */
302     function tokenByIndex(uint256 index) external view returns (uint256);
303 }
304 
305 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
306 
307 
308 
309 pragma solidity >=0.6.0 <0.8.0;
310 
311 /**
312  * @title ERC721 token receiver interface
313  * @dev Interface for any contract that wants to support safeTransfers
314  * from ERC721 asset contracts.
315  */
316 interface IERC721Receiver {
317     /**
318      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
319      * by `operator` from `from`, this function is called.
320      *
321      * It must return its Solidity selector to confirm the token transfer.
322      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
323      *
324      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
325      */
326     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
327 }
328 
329 // File: @openzeppelin/contracts/introspection/ERC165.sol
330 
331 
332 
333 pragma solidity >=0.6.0 <0.8.0;
334 
335 
336 /**
337  * @dev Implementation of the {IERC165} interface.
338  *
339  * Contracts may inherit from this and call {_registerInterface} to declare
340  * their support of an interface.
341  */
342 abstract contract ERC165 is IERC165 {
343     /*
344      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
345      */
346     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
347 
348     /**
349      * @dev Mapping of interface ids to whether or not it's supported.
350      */
351     mapping(bytes4 => bool) private _supportedInterfaces;
352 
353     constructor () internal {
354         // Derived contracts need only register support for their own interfaces,
355         // we register support for ERC165 itself here
356         _registerInterface(_INTERFACE_ID_ERC165);
357     }
358 
359     /**
360      * @dev See {IERC165-supportsInterface}.
361      *
362      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
363      */
364     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
365         return _supportedInterfaces[interfaceId];
366     }
367 
368     /**
369      * @dev Registers the contract as an implementer of the interface defined by
370      * `interfaceId`. Support of the actual ERC165 interface is automatic and
371      * registering its interface id is not required.
372      *
373      * See {IERC165-supportsInterface}.
374      *
375      * Requirements:
376      *
377      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
378      */
379     function _registerInterface(bytes4 interfaceId) internal virtual {
380         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
381         _supportedInterfaces[interfaceId] = true;
382     }
383 }
384 
385 // File: @openzeppelin/contracts/math/SafeMath.sol
386 
387 
388 
389 pragma solidity >=0.6.0 <0.8.0;
390 
391 /**
392  * @dev Wrappers over Solidity's arithmetic operations with added overflow
393  * checks.
394  *
395  * Arithmetic operations in Solidity wrap on overflow. This can easily result
396  * in bugs, because programmers usually assume that an overflow raises an
397  * error, which is the standard behavior in high level programming languages.
398  * `SafeMath` restores this intuition by reverting the transaction when an
399  * operation overflows.
400  *
401  * Using this library instead of the unchecked operations eliminates an entire
402  * class of bugs, so it's recommended to use it always.
403  */
404 library SafeMath {
405     /**
406      * @dev Returns the addition of two unsigned integers, with an overflow flag.
407      *
408      * _Available since v3.4._
409      */
410     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
411         uint256 c = a + b;
412         if (c < a) return (false, 0);
413         return (true, c);
414     }
415 
416     /**
417      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
418      *
419      * _Available since v3.4._
420      */
421     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
422         if (b > a) return (false, 0);
423         return (true, a - b);
424     }
425 
426     /**
427      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
428      *
429      * _Available since v3.4._
430      */
431     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
432         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
433         // benefit is lost if 'b' is also tested.
434         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
435         if (a == 0) return (true, 0);
436         uint256 c = a * b;
437         if (c / a != b) return (false, 0);
438         return (true, c);
439     }
440 
441     /**
442      * @dev Returns the division of two unsigned integers, with a division by zero flag.
443      *
444      * _Available since v3.4._
445      */
446     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
447         if (b == 0) return (false, 0);
448         return (true, a / b);
449     }
450 
451     /**
452      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
453      *
454      * _Available since v3.4._
455      */
456     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
457         if (b == 0) return (false, 0);
458         return (true, a % b);
459     }
460 
461     /**
462      * @dev Returns the addition of two unsigned integers, reverting on
463      * overflow.
464      *
465      * Counterpart to Solidity's `+` operator.
466      *
467      * Requirements:
468      *
469      * - Addition cannot overflow.
470      */
471     function add(uint256 a, uint256 b) internal pure returns (uint256) {
472         uint256 c = a + b;
473         require(c >= a, "SafeMath: addition overflow");
474         return c;
475     }
476 
477     /**
478      * @dev Returns the subtraction of two unsigned integers, reverting on
479      * overflow (when the result is negative).
480      *
481      * Counterpart to Solidity's `-` operator.
482      *
483      * Requirements:
484      *
485      * - Subtraction cannot overflow.
486      */
487     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
488         require(b <= a, "SafeMath: subtraction overflow");
489         return a - b;
490     }
491 
492     /**
493      * @dev Returns the multiplication of two unsigned integers, reverting on
494      * overflow.
495      *
496      * Counterpart to Solidity's `*` operator.
497      *
498      * Requirements:
499      *
500      * - Multiplication cannot overflow.
501      */
502     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
503         if (a == 0) return 0;
504         uint256 c = a * b;
505         require(c / a == b, "SafeMath: multiplication overflow");
506         return c;
507     }
508 
509     /**
510      * @dev Returns the integer division of two unsigned integers, reverting on
511      * division by zero. The result is rounded towards zero.
512      *
513      * Counterpart to Solidity's `/` operator. Note: this function uses a
514      * `revert` opcode (which leaves remaining gas untouched) while Solidity
515      * uses an invalid opcode to revert (consuming all remaining gas).
516      *
517      * Requirements:
518      *
519      * - The divisor cannot be zero.
520      */
521     function div(uint256 a, uint256 b) internal pure returns (uint256) {
522         require(b > 0, "SafeMath: division by zero");
523         return a / b;
524     }
525 
526     /**
527      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
528      * reverting when dividing by zero.
529      *
530      * Counterpart to Solidity's `%` operator. This function uses a `revert`
531      * opcode (which leaves remaining gas untouched) while Solidity uses an
532      * invalid opcode to revert (consuming all remaining gas).
533      *
534      * Requirements:
535      *
536      * - The divisor cannot be zero.
537      */
538     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
539         require(b > 0, "SafeMath: modulo by zero");
540         return a % b;
541     }
542 
543     /**
544      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
545      * overflow (when the result is negative).
546      *
547      * CAUTION: This function is deprecated because it requires allocating memory for the error
548      * message unnecessarily. For custom revert reasons use {trySub}.
549      *
550      * Counterpart to Solidity's `-` operator.
551      *
552      * Requirements:
553      *
554      * - Subtraction cannot overflow.
555      */
556     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
557         require(b <= a, errorMessage);
558         return a - b;
559     }
560 
561     /**
562      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
563      * division by zero. The result is rounded towards zero.
564      *
565      * CAUTION: This function is deprecated because it requires allocating memory for the error
566      * message unnecessarily. For custom revert reasons use {tryDiv}.
567      *
568      * Counterpart to Solidity's `/` operator. Note: this function uses a
569      * `revert` opcode (which leaves remaining gas untouched) while Solidity
570      * uses an invalid opcode to revert (consuming all remaining gas).
571      *
572      * Requirements:
573      *
574      * - The divisor cannot be zero.
575      */
576     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
577         require(b > 0, errorMessage);
578         return a / b;
579     }
580 
581     /**
582      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
583      * reverting with custom message when dividing by zero.
584      *
585      * CAUTION: This function is deprecated because it requires allocating memory for the error
586      * message unnecessarily. For custom revert reasons use {tryMod}.
587      *
588      * Counterpart to Solidity's `%` operator. This function uses a `revert`
589      * opcode (which leaves remaining gas untouched) while Solidity uses an
590      * invalid opcode to revert (consuming all remaining gas).
591      *
592      * Requirements:
593      *
594      * - The divisor cannot be zero.
595      */
596     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
597         require(b > 0, errorMessage);
598         return a % b;
599     }
600 }
601 
602 // File: @openzeppelin/contracts/utils/Address.sol
603 
604 
605 
606 pragma solidity >=0.6.2 <0.8.0;
607 
608 /**
609  * @dev Collection of functions related to the address type
610  */
611 library Address {
612     /**
613      * @dev Returns true if `account` is a contract.
614      *
615      * [IMPORTANT]
616      * ====
617      * It is unsafe to assume that an address for which this function returns
618      * false is an externally-owned account (EOA) and not a contract.
619      *
620      * Among others, `isContract` will return false for the following
621      * types of addresses:
622      *
623      *  - an externally-owned account
624      *  - a contract in construction
625      *  - an address where a contract will be created
626      *  - an address where a contract lived, but was destroyed
627      * ====
628      */
629     function isContract(address account) internal view returns (bool) {
630         // This method relies on extcodesize, which returns 0 for contracts in
631         // construction, since the code is only stored at the end of the
632         // constructor execution.
633 
634         uint256 size;
635         // solhint-disable-next-line no-inline-assembly
636         assembly { size := extcodesize(account) }
637         return size > 0;
638     }
639 
640     /**
641      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
642      * `recipient`, forwarding all available gas and reverting on errors.
643      *
644      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
645      * of certain opcodes, possibly making contracts go over the 2300 gas limit
646      * imposed by `transfer`, making them unable to receive funds via
647      * `transfer`. {sendValue} removes this limitation.
648      *
649      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
650      *
651      * IMPORTANT: because control is transferred to `recipient`, care must be
652      * taken to not create reentrancy vulnerabilities. Consider using
653      * {ReentrancyGuard} or the
654      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
655      */
656     function sendValue(address payable recipient, uint256 amount) internal {
657         require(address(this).balance >= amount, "Address: insufficient balance");
658 
659         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
660         (bool success, ) = recipient.call{ value: amount }("");
661         require(success, "Address: unable to send value, recipient may have reverted");
662     }
663 
664     /**
665      * @dev Performs a Solidity function call using a low level `call`. A
666      * plain`call` is an unsafe replacement for a function call: use this
667      * function instead.
668      *
669      * If `target` reverts with a revert reason, it is bubbled up by this
670      * function (like regular Solidity function calls).
671      *
672      * Returns the raw returned data. To convert to the expected return value,
673      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
674      *
675      * Requirements:
676      *
677      * - `target` must be a contract.
678      * - calling `target` with `data` must not revert.
679      *
680      * _Available since v3.1._
681      */
682     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
683       return functionCall(target, data, "Address: low-level call failed");
684     }
685 
686     /**
687      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
688      * `errorMessage` as a fallback revert reason when `target` reverts.
689      *
690      * _Available since v3.1._
691      */
692     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
693         return functionCallWithValue(target, data, 0, errorMessage);
694     }
695 
696     /**
697      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
698      * but also transferring `value` wei to `target`.
699      *
700      * Requirements:
701      *
702      * - the calling contract must have an ETH balance of at least `value`.
703      * - the called Solidity function must be `payable`.
704      *
705      * _Available since v3.1._
706      */
707     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
708         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
709     }
710 
711     /**
712      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
713      * with `errorMessage` as a fallback revert reason when `target` reverts.
714      *
715      * _Available since v3.1._
716      */
717     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
718         require(address(this).balance >= value, "Address: insufficient balance for call");
719         require(isContract(target), "Address: call to non-contract");
720 
721         // solhint-disable-next-line avoid-low-level-calls
722         (bool success, bytes memory returndata) = target.call{ value: value }(data);
723         return _verifyCallResult(success, returndata, errorMessage);
724     }
725 
726     /**
727      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
728      * but performing a static call.
729      *
730      * _Available since v3.3._
731      */
732     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
733         return functionStaticCall(target, data, "Address: low-level static call failed");
734     }
735 
736     /**
737      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
738      * but performing a static call.
739      *
740      * _Available since v3.3._
741      */
742     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
743         require(isContract(target), "Address: static call to non-contract");
744 
745         // solhint-disable-next-line avoid-low-level-calls
746         (bool success, bytes memory returndata) = target.staticcall(data);
747         return _verifyCallResult(success, returndata, errorMessage);
748     }
749 
750     /**
751      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
752      * but performing a delegate call.
753      *
754      * _Available since v3.4._
755      */
756     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
757         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
758     }
759 
760     /**
761      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
762      * but performing a delegate call.
763      *
764      * _Available since v3.4._
765      */
766     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
767         require(isContract(target), "Address: delegate call to non-contract");
768 
769         // solhint-disable-next-line avoid-low-level-calls
770         (bool success, bytes memory returndata) = target.delegatecall(data);
771         return _verifyCallResult(success, returndata, errorMessage);
772     }
773 
774     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
775         if (success) {
776             return returndata;
777         } else {
778             // Look for revert reason and bubble it up if present
779             if (returndata.length > 0) {
780                 // The easiest way to bubble the revert reason is using memory via assembly
781 
782                 // solhint-disable-next-line no-inline-assembly
783                 assembly {
784                     let returndata_size := mload(returndata)
785                     revert(add(32, returndata), returndata_size)
786                 }
787             } else {
788                 revert(errorMessage);
789             }
790         }
791     }
792 }
793 
794 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
795 
796 
797 
798 pragma solidity >=0.6.0 <0.8.0;
799 
800 /**
801  * @dev Library for managing
802  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
803  * types.
804  *
805  * Sets have the following properties:
806  *
807  * - Elements are added, removed, and checked for existence in constant time
808  * (O(1)).
809  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
810  *
811  * ```
812  * contract Example {
813  *     // Add the library methods
814  *     using EnumerableSet for EnumerableSet.AddressSet;
815  *
816  *     // Declare a set state variable
817  *     EnumerableSet.AddressSet private mySet;
818  * }
819  * ```
820  *
821  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
822  * and `uint256` (`UintSet`) are supported.
823  */
824 library EnumerableSet {
825     // To implement this library for multiple types with as little code
826     // repetition as possible, we write it in terms of a generic Set type with
827     // bytes32 values.
828     // The Set implementation uses private functions, and user-facing
829     // implementations (such as AddressSet) are just wrappers around the
830     // underlying Set.
831     // This means that we can only create new EnumerableSets for types that fit
832     // in bytes32.
833 
834     struct Set {
835         // Storage of set values
836         bytes32[] _values;
837 
838         // Position of the value in the `values` array, plus 1 because index 0
839         // means a value is not in the set.
840         mapping (bytes32 => uint256) _indexes;
841     }
842 
843     /**
844      * @dev Add a value to a set. O(1).
845      *
846      * Returns true if the value was added to the set, that is if it was not
847      * already present.
848      */
849     function _add(Set storage set, bytes32 value) private returns (bool) {
850         if (!_contains(set, value)) {
851             set._values.push(value);
852             // The value is stored at length-1, but we add 1 to all indexes
853             // and use 0 as a sentinel value
854             set._indexes[value] = set._values.length;
855             return true;
856         } else {
857             return false;
858         }
859     }
860 
861     /**
862      * @dev Removes a value from a set. O(1).
863      *
864      * Returns true if the value was removed from the set, that is if it was
865      * present.
866      */
867     function _remove(Set storage set, bytes32 value) private returns (bool) {
868         // We read and store the value's index to prevent multiple reads from the same storage slot
869         uint256 valueIndex = set._indexes[value];
870 
871         if (valueIndex != 0) { // Equivalent to contains(set, value)
872             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
873             // the array, and then remove the last element (sometimes called as 'swap and pop').
874             // This modifies the order of the array, as noted in {at}.
875 
876             uint256 toDeleteIndex = valueIndex - 1;
877             uint256 lastIndex = set._values.length - 1;
878 
879             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
880             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
881 
882             bytes32 lastvalue = set._values[lastIndex];
883 
884             // Move the last value to the index where the value to delete is
885             set._values[toDeleteIndex] = lastvalue;
886             // Update the index for the moved value
887             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
888 
889             // Delete the slot where the moved value was stored
890             set._values.pop();
891 
892             // Delete the index for the deleted slot
893             delete set._indexes[value];
894 
895             return true;
896         } else {
897             return false;
898         }
899     }
900 
901     /**
902      * @dev Returns true if the value is in the set. O(1).
903      */
904     function _contains(Set storage set, bytes32 value) private view returns (bool) {
905         return set._indexes[value] != 0;
906     }
907 
908     /**
909      * @dev Returns the number of values on the set. O(1).
910      */
911     function _length(Set storage set) private view returns (uint256) {
912         return set._values.length;
913     }
914 
915    /**
916     * @dev Returns the value stored at position `index` in the set. O(1).
917     *
918     * Note that there are no guarantees on the ordering of values inside the
919     * array, and it may change when more values are added or removed.
920     *
921     * Requirements:
922     *
923     * - `index` must be strictly less than {length}.
924     */
925     function _at(Set storage set, uint256 index) private view returns (bytes32) {
926         require(set._values.length > index, "EnumerableSet: index out of bounds");
927         return set._values[index];
928     }
929 
930     // Bytes32Set
931 
932     struct Bytes32Set {
933         Set _inner;
934     }
935 
936     /**
937      * @dev Add a value to a set. O(1).
938      *
939      * Returns true if the value was added to the set, that is if it was not
940      * already present.
941      */
942     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
943         return _add(set._inner, value);
944     }
945 
946     /**
947      * @dev Removes a value from a set. O(1).
948      *
949      * Returns true if the value was removed from the set, that is if it was
950      * present.
951      */
952     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
953         return _remove(set._inner, value);
954     }
955 
956     /**
957      * @dev Returns true if the value is in the set. O(1).
958      */
959     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
960         return _contains(set._inner, value);
961     }
962 
963     /**
964      * @dev Returns the number of values in the set. O(1).
965      */
966     function length(Bytes32Set storage set) internal view returns (uint256) {
967         return _length(set._inner);
968     }
969 
970    /**
971     * @dev Returns the value stored at position `index` in the set. O(1).
972     *
973     * Note that there are no guarantees on the ordering of values inside the
974     * array, and it may change when more values are added or removed.
975     *
976     * Requirements:
977     *
978     * - `index` must be strictly less than {length}.
979     */
980     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
981         return _at(set._inner, index);
982     }
983 
984     // AddressSet
985 
986     struct AddressSet {
987         Set _inner;
988     }
989 
990     /**
991      * @dev Add a value to a set. O(1).
992      *
993      * Returns true if the value was added to the set, that is if it was not
994      * already present.
995      */
996     function add(AddressSet storage set, address value) internal returns (bool) {
997         return _add(set._inner, bytes32(uint256(uint160(value))));
998     }
999 
1000     /**
1001      * @dev Removes a value from a set. O(1).
1002      *
1003      * Returns true if the value was removed from the set, that is if it was
1004      * present.
1005      */
1006     function remove(AddressSet storage set, address value) internal returns (bool) {
1007         return _remove(set._inner, bytes32(uint256(uint160(value))));
1008     }
1009 
1010     /**
1011      * @dev Returns true if the value is in the set. O(1).
1012      */
1013     function contains(AddressSet storage set, address value) internal view returns (bool) {
1014         return _contains(set._inner, bytes32(uint256(uint160(value))));
1015     }
1016 
1017     /**
1018      * @dev Returns the number of values in the set. O(1).
1019      */
1020     function length(AddressSet storage set) internal view returns (uint256) {
1021         return _length(set._inner);
1022     }
1023 
1024    /**
1025     * @dev Returns the value stored at position `index` in the set. O(1).
1026     *
1027     * Note that there are no guarantees on the ordering of values inside the
1028     * array, and it may change when more values are added or removed.
1029     *
1030     * Requirements:
1031     *
1032     * - `index` must be strictly less than {length}.
1033     */
1034     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1035         return address(uint160(uint256(_at(set._inner, index))));
1036     }
1037 
1038 
1039     // UintSet
1040 
1041     struct UintSet {
1042         Set _inner;
1043     }
1044 
1045     /**
1046      * @dev Add a value to a set. O(1).
1047      *
1048      * Returns true if the value was added to the set, that is if it was not
1049      * already present.
1050      */
1051     function add(UintSet storage set, uint256 value) internal returns (bool) {
1052         return _add(set._inner, bytes32(value));
1053     }
1054 
1055     /**
1056      * @dev Removes a value from a set. O(1).
1057      *
1058      * Returns true if the value was removed from the set, that is if it was
1059      * present.
1060      */
1061     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1062         return _remove(set._inner, bytes32(value));
1063     }
1064 
1065     /**
1066      * @dev Returns true if the value is in the set. O(1).
1067      */
1068     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1069         return _contains(set._inner, bytes32(value));
1070     }
1071 
1072     /**
1073      * @dev Returns the number of values on the set. O(1).
1074      */
1075     function length(UintSet storage set) internal view returns (uint256) {
1076         return _length(set._inner);
1077     }
1078 
1079    /**
1080     * @dev Returns the value stored at position `index` in the set. O(1).
1081     *
1082     * Note that there are no guarantees on the ordering of values inside the
1083     * array, and it may change when more values are added or removed.
1084     *
1085     * Requirements:
1086     *
1087     * - `index` must be strictly less than {length}.
1088     */
1089     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1090         return uint256(_at(set._inner, index));
1091     }
1092 }
1093 
1094 // File: @openzeppelin/contracts/utils/EnumerableMap.sol
1095 
1096 
1097 
1098 pragma solidity >=0.6.0 <0.8.0;
1099 
1100 /**
1101  * @dev Library for managing an enumerable variant of Solidity's
1102  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1103  * type.
1104  *
1105  * Maps have the following properties:
1106  *
1107  * - Entries are added, removed, and checked for existence in constant time
1108  * (O(1)).
1109  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1110  *
1111  * ```
1112  * contract Example {
1113  *     // Add the library methods
1114  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1115  *
1116  *     // Declare a set state variable
1117  *     EnumerableMap.UintToAddressMap private myMap;
1118  * }
1119  * ```
1120  *
1121  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1122  * supported.
1123  */
1124 library EnumerableMap {
1125     // To implement this library for multiple types with as little code
1126     // repetition as possible, we write it in terms of a generic Map type with
1127     // bytes32 keys and values.
1128     // The Map implementation uses private functions, and user-facing
1129     // implementations (such as Uint256ToAddressMap) are just wrappers around
1130     // the underlying Map.
1131     // This means that we can only create new EnumerableMaps for types that fit
1132     // in bytes32.
1133 
1134     struct MapEntry {
1135         bytes32 _key;
1136         bytes32 _value;
1137     }
1138 
1139     struct Map {
1140         // Storage of map keys and values
1141         MapEntry[] _entries;
1142 
1143         // Position of the entry defined by a key in the `entries` array, plus 1
1144         // because index 0 means a key is not in the map.
1145         mapping (bytes32 => uint256) _indexes;
1146     }
1147 
1148     /**
1149      * @dev Adds a key-value pair to a map, or updates the value for an existing
1150      * key. O(1).
1151      *
1152      * Returns true if the key was added to the map, that is if it was not
1153      * already present.
1154      */
1155     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1156         // We read and store the key's index to prevent multiple reads from the same storage slot
1157         uint256 keyIndex = map._indexes[key];
1158 
1159         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1160             map._entries.push(MapEntry({ _key: key, _value: value }));
1161             // The entry is stored at length-1, but we add 1 to all indexes
1162             // and use 0 as a sentinel value
1163             map._indexes[key] = map._entries.length;
1164             return true;
1165         } else {
1166             map._entries[keyIndex - 1]._value = value;
1167             return false;
1168         }
1169     }
1170 
1171     /**
1172      * @dev Removes a key-value pair from a map. O(1).
1173      *
1174      * Returns true if the key was removed from the map, that is if it was present.
1175      */
1176     function _remove(Map storage map, bytes32 key) private returns (bool) {
1177         // We read and store the key's index to prevent multiple reads from the same storage slot
1178         uint256 keyIndex = map._indexes[key];
1179 
1180         if (keyIndex != 0) { // Equivalent to contains(map, key)
1181             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1182             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1183             // This modifies the order of the array, as noted in {at}.
1184 
1185             uint256 toDeleteIndex = keyIndex - 1;
1186             uint256 lastIndex = map._entries.length - 1;
1187 
1188             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1189             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1190 
1191             MapEntry storage lastEntry = map._entries[lastIndex];
1192 
1193             // Move the last entry to the index where the entry to delete is
1194             map._entries[toDeleteIndex] = lastEntry;
1195             // Update the index for the moved entry
1196             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1197 
1198             // Delete the slot where the moved entry was stored
1199             map._entries.pop();
1200 
1201             // Delete the index for the deleted slot
1202             delete map._indexes[key];
1203 
1204             return true;
1205         } else {
1206             return false;
1207         }
1208     }
1209 
1210     /**
1211      * @dev Returns true if the key is in the map. O(1).
1212      */
1213     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1214         return map._indexes[key] != 0;
1215     }
1216 
1217     /**
1218      * @dev Returns the number of key-value pairs in the map. O(1).
1219      */
1220     function _length(Map storage map) private view returns (uint256) {
1221         return map._entries.length;
1222     }
1223 
1224    /**
1225     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1226     *
1227     * Note that there are no guarantees on the ordering of entries inside the
1228     * array, and it may change when more entries are added or removed.
1229     *
1230     * Requirements:
1231     *
1232     * - `index` must be strictly less than {length}.
1233     */
1234     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1235         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1236 
1237         MapEntry storage entry = map._entries[index];
1238         return (entry._key, entry._value);
1239     }
1240 
1241     /**
1242      * @dev Tries to returns the value associated with `key`.  O(1).
1243      * Does not revert if `key` is not in the map.
1244      */
1245     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
1246         uint256 keyIndex = map._indexes[key];
1247         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1248         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1249     }
1250 
1251     /**
1252      * @dev Returns the value associated with `key`.  O(1).
1253      *
1254      * Requirements:
1255      *
1256      * - `key` must be in the map.
1257      */
1258     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1259         uint256 keyIndex = map._indexes[key];
1260         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1261         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1262     }
1263 
1264     /**
1265      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1266      *
1267      * CAUTION: This function is deprecated because it requires allocating memory for the error
1268      * message unnecessarily. For custom revert reasons use {_tryGet}.
1269      */
1270     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1271         uint256 keyIndex = map._indexes[key];
1272         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1273         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1274     }
1275 
1276     // UintToAddressMap
1277 
1278     struct UintToAddressMap {
1279         Map _inner;
1280     }
1281 
1282     /**
1283      * @dev Adds a key-value pair to a map, or updates the value for an existing
1284      * key. O(1).
1285      *
1286      * Returns true if the key was added to the map, that is if it was not
1287      * already present.
1288      */
1289     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1290         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1291     }
1292 
1293     /**
1294      * @dev Removes a value from a set. O(1).
1295      *
1296      * Returns true if the key was removed from the map, that is if it was present.
1297      */
1298     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1299         return _remove(map._inner, bytes32(key));
1300     }
1301 
1302     /**
1303      * @dev Returns true if the key is in the map. O(1).
1304      */
1305     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1306         return _contains(map._inner, bytes32(key));
1307     }
1308 
1309     /**
1310      * @dev Returns the number of elements in the map. O(1).
1311      */
1312     function length(UintToAddressMap storage map) internal view returns (uint256) {
1313         return _length(map._inner);
1314     }
1315 
1316    /**
1317     * @dev Returns the element stored at position `index` in the set. O(1).
1318     * Note that there are no guarantees on the ordering of values inside the
1319     * array, and it may change when more values are added or removed.
1320     *
1321     * Requirements:
1322     *
1323     * - `index` must be strictly less than {length}.
1324     */
1325     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1326         (bytes32 key, bytes32 value) = _at(map._inner, index);
1327         return (uint256(key), address(uint160(uint256(value))));
1328     }
1329 
1330     /**
1331      * @dev Tries to returns the value associated with `key`.  O(1).
1332      * Does not revert if `key` is not in the map.
1333      *
1334      * _Available since v3.4._
1335      */
1336     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
1337         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1338         return (success, address(uint160(uint256(value))));
1339     }
1340 
1341     /**
1342      * @dev Returns the value associated with `key`.  O(1).
1343      *
1344      * Requirements:
1345      *
1346      * - `key` must be in the map.
1347      */
1348     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1349         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1350     }
1351 
1352     /**
1353      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1354      *
1355      * CAUTION: This function is deprecated because it requires allocating memory for the error
1356      * message unnecessarily. For custom revert reasons use {tryGet}.
1357      */
1358     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1359         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
1360     }
1361 }
1362 
1363 // File: @openzeppelin/contracts/utils/Strings.sol
1364 
1365 
1366 
1367 pragma solidity >=0.6.0 <0.8.0;
1368 
1369 /**
1370  * @dev String operations.
1371  */
1372 library Strings {
1373     /**
1374      * @dev Converts a `uint256` to its ASCII `string` representation.
1375      */
1376     function toString(uint256 value) internal pure returns (string memory) {
1377         // Inspired by OraclizeAPI's implementation - MIT licence
1378         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1379 
1380         if (value == 0) {
1381             return "0";
1382         }
1383         uint256 temp = value;
1384         uint256 digits;
1385         while (temp != 0) {
1386             digits++;
1387             temp /= 10;
1388         }
1389         bytes memory buffer = new bytes(digits);
1390         uint256 index = digits - 1;
1391         temp = value;
1392         while (temp != 0) {
1393             buffer[index--] = bytes1(uint8(48 + temp % 10));
1394             temp /= 10;
1395         }
1396         return string(buffer);
1397     }
1398 }
1399 
1400 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1401 
1402 
1403 
1404 pragma solidity >=0.6.0 <0.8.0;
1405 
1406 /**
1407  * @title ERC721 Non-Fungible Token Standard basic implementation
1408  * @dev see https://eips.ethereum.org/EIPS/eip-721
1409  */
1410  
1411 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1412     using SafeMath for uint256;
1413     using Address for address;
1414     using EnumerableSet for EnumerableSet.UintSet;
1415     using EnumerableMap for EnumerableMap.UintToAddressMap;
1416     using Strings for uint256;
1417 
1418     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1419     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1420     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1421 
1422     // Mapping from holder address to their (enumerable) set of owned tokens
1423     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1424 
1425     // Enumerable mapping from token ids to their owners
1426     EnumerableMap.UintToAddressMap private _tokenOwners;
1427 
1428     // Mapping from token ID to approved address
1429     mapping (uint256 => address) private _tokenApprovals;
1430 
1431     // Mapping from owner to operator approvals
1432     mapping (address => mapping (address => bool)) private _operatorApprovals;
1433 
1434     // Token name
1435     string private _name;
1436 
1437     // Token symbol
1438     string private _symbol;
1439 
1440     // Optional mapping for token URIs
1441     mapping (uint256 => string) private _tokenURIs;
1442 
1443     // Base URI
1444     string private _baseURI;
1445 
1446     /*
1447      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1448      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1449      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1450      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1451      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1452      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1453      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1454      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1455      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1456      *
1457      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1458      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1459      */
1460     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1461 
1462     /*
1463      *     bytes4(keccak256('name()')) == 0x06fdde03
1464      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1465      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1466      *
1467      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1468      */
1469     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1470 
1471     /*
1472      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1473      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1474      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1475      *
1476      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1477      */
1478     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1479 
1480     /**
1481      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1482      */
1483     constructor (string memory name_, string memory symbol_) public {
1484         _name = name_;
1485         _symbol = symbol_;
1486 
1487         // register the supported interfaces to conform to ERC721 via ERC165
1488         _registerInterface(_INTERFACE_ID_ERC721);
1489         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1490         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1491     }
1492 
1493     /**
1494      * @dev See {IERC721-balanceOf}.
1495      */
1496     function balanceOf(address owner) public view virtual override returns (uint256) {
1497         require(owner != address(0), "ERC721: balance query for the zero address");
1498         return _holderTokens[owner].length();
1499     }
1500 
1501     /**
1502      * @dev See {IERC721-ownerOf}.
1503      */
1504     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1505         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1506     }
1507 
1508     /**
1509      * @dev See {IERC721Metadata-name}.
1510      */
1511     function name() public view virtual override returns (string memory) {
1512         return _name;
1513     }
1514 
1515     /**
1516      * @dev See {IERC721Metadata-symbol}.
1517      */
1518     function symbol() public view virtual override returns (string memory) {
1519         return _symbol;
1520     }
1521 
1522     /**
1523      * @dev See {IERC721Metadata-tokenURI}.
1524      */
1525     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1526         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1527 
1528         string memory _tokenURI = _tokenURIs[tokenId];
1529         string memory base = baseURI();
1530 
1531         // If there is no base URI, return the token URI.
1532         if (bytes(base).length == 0) {
1533             return _tokenURI;
1534         }
1535         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1536         if (bytes(_tokenURI).length > 0) {
1537             return string(abi.encodePacked(base, _tokenURI));
1538         }
1539         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1540         return string(abi.encodePacked(base, tokenId.toString()));
1541     }
1542 
1543     /**
1544     * @dev Returns the base URI set via {_setBaseURI}. This will be
1545     * automatically added as a prefix in {tokenURI} to each token's URI, or
1546     * to the token ID if no specific URI is set for that token ID.
1547     */
1548     function baseURI() public view virtual returns (string memory) {
1549         return _baseURI;
1550     }
1551 
1552     /**
1553      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1554      */
1555     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1556         return _holderTokens[owner].at(index);
1557     }
1558 
1559     /**
1560      * @dev See {IERC721Enumerable-totalSupply}.
1561      */
1562     function totalSupply() public view virtual override returns (uint256) {
1563         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1564         return _tokenOwners.length();
1565     }
1566 
1567     /**
1568      * @dev See {IERC721Enumerable-tokenByIndex}.
1569      */
1570     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1571         (uint256 tokenId, ) = _tokenOwners.at(index);
1572         return tokenId;
1573     }
1574 
1575     /**
1576      * @dev See {IERC721-approve}.
1577      */
1578     function approve(address to, uint256 tokenId) public virtual override {
1579         address owner = ERC721.ownerOf(tokenId);
1580         require(to != owner, "ERC721: approval to current owner");
1581 
1582         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1583             "ERC721: approve caller is not owner nor approved for all"
1584         );
1585 
1586         _approve(to, tokenId);
1587     }
1588 
1589     /**
1590      * @dev See {IERC721-getApproved}.
1591      */
1592     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1593         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1594 
1595         return _tokenApprovals[tokenId];
1596     }
1597 
1598     /**
1599      * @dev See {IERC721-setApprovalForAll}.
1600      */
1601     function setApprovalForAll(address operator, bool approved) public virtual override {
1602         require(operator != _msgSender(), "ERC721: approve to caller");
1603 
1604         _operatorApprovals[_msgSender()][operator] = approved;
1605         emit ApprovalForAll(_msgSender(), operator, approved);
1606     }
1607 
1608     /**
1609      * @dev See {IERC721-isApprovedForAll}.
1610      */
1611     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1612         return _operatorApprovals[owner][operator];
1613     }
1614 
1615     /**
1616      * @dev See {IERC721-transferFrom}.
1617      */
1618     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1619         //solhint-disable-next-line max-line-length
1620         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1621 
1622         _transfer(from, to, tokenId);
1623     }
1624 
1625     /**
1626      * @dev See {IERC721-safeTransferFrom}.
1627      */
1628     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1629         safeTransferFrom(from, to, tokenId, "");
1630     }
1631 
1632     /**
1633      * @dev See {IERC721-safeTransferFrom}.
1634      */
1635     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1636         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1637         _safeTransfer(from, to, tokenId, _data);
1638     }
1639 
1640     /**
1641      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1642      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1643      *
1644      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1645      *
1646      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1647      * implement alternative mechanisms to perform token transfer, such as signature-based.
1648      *
1649      * Requirements:
1650      *
1651      * - `from` cannot be the zero address.
1652      * - `to` cannot be the zero address.
1653      * - `tokenId` token must exist and be owned by `from`.
1654      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1655      *
1656      * Emits a {Transfer} event.
1657      */
1658     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1659         _transfer(from, to, tokenId);
1660         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1661     }
1662 
1663     /**
1664      * @dev Returns whether `tokenId` exists.
1665      *
1666      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1667      *
1668      * Tokens start existing when they are minted (`_mint`),
1669      * and stop existing when they are burned (`_burn`).
1670      */
1671     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1672         return _tokenOwners.contains(tokenId);
1673     }
1674 
1675     /**
1676      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1677      *
1678      * Requirements:
1679      *
1680      * - `tokenId` must exist.
1681      */
1682     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1683         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1684         address owner = ERC721.ownerOf(tokenId);
1685         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1686     }
1687 
1688     /**
1689      * @dev Safely mints `tokenId` and transfers it to `to`.
1690      *
1691      * Requirements:
1692      d*
1693      * - `tokenId` must not exist.
1694      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1695      *
1696      * Emits a {Transfer} event.
1697      */
1698     function _safeMint(address to, uint256 tokenId) internal virtual {
1699         _safeMint(to, tokenId, "");
1700     }
1701 
1702     /**
1703      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1704      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1705      */
1706     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1707         _mint(to, tokenId);
1708         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1709     }
1710 
1711     /**
1712      * @dev Mints `tokenId` and transfers it to `to`.
1713      *
1714      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1715      *
1716      * Requirements:
1717      *
1718      * - `tokenId` must not exist.
1719      * - `to` cannot be the zero address.
1720      *
1721      * Emits a {Transfer} event.
1722      */
1723     function _mint(address to, uint256 tokenId) internal virtual {
1724         require(to != address(0), "ERC721: mint to the zero address");
1725         require(!_exists(tokenId), "ERC721: token already minted");
1726 
1727         _beforeTokenTransfer(address(0), to, tokenId);
1728 
1729         _holderTokens[to].add(tokenId);
1730 
1731         _tokenOwners.set(tokenId, to);
1732 
1733         emit Transfer(address(0), to, tokenId);
1734     }
1735 
1736     /**
1737      * @dev Destroys `tokenId`.
1738      * The approval is cleared when the token is burned.
1739      *
1740      * Requirements:
1741      *
1742      * - `tokenId` must exist.
1743      *
1744      * Emits a {Transfer} event.
1745      */
1746     function _burn(uint256 tokenId) internal virtual {
1747         address owner = ERC721.ownerOf(tokenId); // internal owner
1748 
1749         _beforeTokenTransfer(owner, address(0), tokenId);
1750 
1751         // Clear approvals
1752         _approve(address(0), tokenId);
1753 
1754         // Clear metadata (if any)
1755         if (bytes(_tokenURIs[tokenId]).length != 0) {
1756             delete _tokenURIs[tokenId];
1757         }
1758 
1759         _holderTokens[owner].remove(tokenId);
1760 
1761         _tokenOwners.remove(tokenId);
1762 
1763         emit Transfer(owner, address(0), tokenId);
1764     }
1765 
1766     /**
1767      * @dev Transfers `tokenId` from `from` to `to`.
1768      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1769      *
1770      * Requirements:
1771      *
1772      * - `to` cannot be the zero address.
1773      * - `tokenId` token must be owned by `from`.
1774      *
1775      * Emits a {Transfer} event.
1776      */
1777     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1778         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1779         require(to != address(0), "ERC721: transfer to the zero address");
1780 
1781         _beforeTokenTransfer(from, to, tokenId);
1782 
1783         // Clear approvals from the previous owner
1784         _approve(address(0), tokenId);
1785 
1786         _holderTokens[from].remove(tokenId);
1787         _holderTokens[to].add(tokenId);
1788 
1789         _tokenOwners.set(tokenId, to);
1790 
1791         emit Transfer(from, to, tokenId);
1792     }
1793 
1794     /**
1795      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1796      *
1797      * Requirements:
1798      *
1799      * - `tokenId` must exist.
1800      */
1801     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1802         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1803         _tokenURIs[tokenId] = _tokenURI;
1804     }
1805 
1806     /**
1807      * @dev Internal function to set the base URI for all token IDs. It is
1808      * automatically added as a prefix to the value returned in {tokenURI},
1809      * or to the token ID if {tokenURI} is empty.
1810      */
1811     function _setBaseURI(string memory baseURI_) internal virtual {
1812         _baseURI = baseURI_;
1813     }
1814 
1815     /**
1816      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1817      * The call is not executed if the target address is not a contract.
1818      *
1819      * @param from address representing the previous owner of the given token ID
1820      * @param to target address that will receive the tokens
1821      * @param tokenId uint256 ID of the token to be transferred
1822      * @param _data bytes optional data to send along with the call
1823      * @return bool whether the call correctly returned the expected magic value
1824      */
1825     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1826         private returns (bool)
1827     {
1828         if (!to.isContract()) {
1829             return true;
1830         }
1831         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1832             IERC721Receiver(to).onERC721Received.selector,
1833             _msgSender(),
1834             from,
1835             tokenId,
1836             _data
1837         ), "ERC721: transfer to non ERC721Receiver implementer");
1838         bytes4 retval = abi.decode(returndata, (bytes4));
1839         return (retval == _ERC721_RECEIVED);
1840     }
1841 
1842     /**
1843      * @dev Approve `to` to operate on `tokenId`
1844      *
1845      * Emits an {Approval} event.
1846      */
1847     function _approve(address to, uint256 tokenId) internal virtual {
1848         _tokenApprovals[tokenId] = to;
1849         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1850     }
1851 
1852     /**
1853      * @dev Hook that is called before any token transfer. This includes minting
1854      * and burning.
1855      *
1856      * Calling conditions:
1857      *
1858      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1859      * transferred to `to`.
1860      * - When `from` is zero, `tokenId` will be minted for `to`.
1861      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1862      * - `from` cannot be the zero address.
1863      * - `to` cannot be the zero address.
1864      *
1865      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1866      */
1867     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1868 }
1869 
1870 // File: @openzeppelin/contracts/access/Ownable.sol
1871 
1872 
1873 
1874 pragma solidity >=0.6.0 <0.8.0;
1875 
1876 /**
1877  * @dev Contract module which provides a basic access control mechanism, where
1878  * there is an account (an owner) that can be granted exclusive access to
1879  * specific functions.
1880  *
1881  * By default, the owner account will be the one that deploys the contract. This
1882  * can later be changed with {transferOwnership}.
1883  *
1884  * This module is used through inheritance. It will make available the modifier
1885  * `onlyOwner`, which can be applied to your functions to restrict their use to
1886  * the owner.
1887  */
1888 abstract contract Ownable is Context {
1889     address private _owner;
1890 
1891     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1892 
1893     /**
1894      * @dev Initializes the contract setting the deployer as the initial owner.
1895      */
1896     constructor () internal {
1897         address msgSender = _msgSender();
1898         _owner = msgSender;
1899         emit OwnershipTransferred(address(0), msgSender);
1900     }
1901 
1902     /**
1903      * @dev Returns the address of the current owner.
1904      */
1905     function owner() public view virtual returns (address) {
1906         return _owner;
1907     }
1908 
1909     /**
1910      * @dev Throws if called by any account other than the owner.
1911      */
1912     modifier onlyOwner() {
1913         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1914         _;
1915     }
1916 
1917     /**
1918      * @dev Leaves the contract without owner. It will not be possible to call
1919      * `onlyOwner` functions anymore. Can only be called by the current owner.
1920      *
1921      * NOTE: Renouncing ownership will leave the contract without an owner,
1922      * thereby removing any functionality that is only available to the owner.
1923      */
1924     function renounceOwnership() public virtual onlyOwner {
1925         emit OwnershipTransferred(_owner, address(0));
1926         _owner = address(0);
1927     }
1928 
1929     /**
1930      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1931      * Can only be called by the current owner.
1932      */
1933     function transferOwnership(address newOwner) public virtual onlyOwner {
1934         require(newOwner != address(0), "Ownable: new owner is the zero address");
1935         emit OwnershipTransferred(_owner, newOwner);
1936         _owner = newOwner;
1937     }
1938 }
1939 
1940 
1941 
1942 
1943 pragma solidity ^0.7.0;
1944 pragma abicoder v2;
1945 
1946 contract Lockjaw is ERC721, Ownable {
1947     
1948     using SafeMath for uint256;
1949 
1950     string public PROVENANCE = ""; 
1951     
1952     string public LICENSE_TEXT = ""; 
1953     
1954     bool licenseLocked = false; 
1955 
1956     uint256 public constant LockjawPrice = 80000000000000000; // 0.08 ETH
1957 
1958     uint public maxLockjawPurchase = 10;
1959 
1960     uint256 public constant MAX_LOCKJAW = 9999;
1961 
1962     bool public saleIsActive = false;
1963     
1964     // Reserve 69 Lockjaw for the team for giveaways and contests. Etherscan txns will be provided in discord.
1965     uint public lockjawReserve = 69;
1966     
1967     event licenseisLocked(string _licenseText);
1968 
1969     constructor() ERC721("Lockjaw", "LJAW") { }
1970     
1971     function withdraw() public onlyOwner {
1972         uint balance = address(this).balance;
1973         msg.sender.transfer(balance);
1974     }
1975     
1976     function reserveLockjaw(address _to, uint256 _reserveAmount) public onlyOwner {        
1977         uint supply = totalSupply();
1978         require(_reserveAmount > 0 && _reserveAmount <= lockjawReserve, "Out of reserved NFTs for team!");
1979         for (uint i = 0; i < _reserveAmount; i++) {
1980             _safeMint(_to, supply + i);
1981         }
1982         lockjawReserve = lockjawReserve.sub(_reserveAmount);
1983     }
1984 
1985 
1986     function setProvenanceHash(string memory provenanceHash) public onlyOwner {
1987         PROVENANCE = provenanceHash;
1988     }
1989 
1990     function setBaseURI(string memory baseURI) public onlyOwner {
1991         _setBaseURI(baseURI);
1992     }
1993     
1994     function setMaxMint(uint newMaxMint) public onlyOwner {
1995        require(newMaxMint > 0 && newMaxMint <= MAX_LOCKJAW , "Must be > 0 and < MAX_LOCKJAW");
1996        maxLockjawPurchase = newMaxMint;
1997     }
1998     
1999 
2000     function flipSaleState() public onlyOwner {
2001         saleIsActive = !saleIsActive;
2002     }
2003     
2004     
2005     function tokensOfOwner(address _owner) external view returns(uint256[] memory ) {
2006         uint256 tokenCount = balanceOf(_owner);
2007         if (tokenCount == 0) {
2008             // Return an empty array
2009             return new uint256[](0);
2010         } else {
2011             uint256[] memory result = new uint256[](tokenCount);
2012             uint256 index;
2013             for (index = 0; index < tokenCount; index++) {
2014                 result[index] = tokenOfOwnerByIndex(_owner, index);
2015             }
2016             return result;
2017         }
2018     }
2019     
2020     // Returns the license for tokens
2021     function tokenLicense(uint _id) public view returns(string memory) {
2022         require(_id < totalSupply(), "CHOOSE A TOKEN WITHIN RANGE");
2023         return LICENSE_TEXT;
2024     }
2025     
2026     // Locks the license to prevent further changes 
2027     function lockLicense() public onlyOwner {
2028         licenseLocked =  true;
2029         emit licenseisLocked(LICENSE_TEXT);
2030     }
2031     
2032     // Change the license
2033     function changeLicense(string memory _license) public onlyOwner {
2034         require(licenseLocked == false, "License already locked");
2035         LICENSE_TEXT = _license;
2036     }
2037     
2038     
2039     function mintLockjaw(uint numberOfTokens) public payable {
2040         require(saleIsActive, "Sale must be active to mint Lockjaws");
2041         require(numberOfTokens > 0 && numberOfTokens <= maxLockjawPurchase, "Check the discord to see the current maximum mint amount!");
2042         require(totalSupply().add(numberOfTokens) <= MAX_LOCKJAW, "Purchase would exceed max LockJaw");
2043         require(msg.value >= LockjawPrice.mul(numberOfTokens), "Ether value sent is not correct, mint price is 0.08 ETH per token");
2044         
2045         for(uint i = 0; i < numberOfTokens; i++) {
2046             uint mintIndex = totalSupply();
2047             if (totalSupply() < MAX_LOCKJAW) {
2048                 _safeMint(msg.sender, mintIndex);
2049             }
2050         }
2051 
2052     }
2053     
2054     function contractURI() public view returns (string memory) {
2055         string memory base = baseURI();
2056 
2057         return string(abi.encodePacked(base, "/contract/lockjaw"));
2058     }
2059 }