1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 //                                                                                                 ,---.-,                                                            
5 //                                                                                                '   ,'  '.                                                          
6 //   ,----..     ,---,                            ___                                            /   /      \    ,----..       ,----..                                
7 //  /   /   \  ,--.' |                          ,--.'|_    ,--,                                 .   ;  ,/.  :   /   /   \     /   /   \                               
8 // |   :     : |  |  :       ,---.              |  | :,' ,--.'|                                 '   |  | :  ;  /   .     :   /   .     :                              
9 // .   |  ;. / :  :  :      '   ,'\   .--.--.   :  : ' : |  |,                .--.--.           '   |  ./   : .   /   ;.  \ .   /   ;.  \                             
10 // .   ; /--`  :  |  |,--. /   /   | /  /    '.;__,'  /  `--'_       ,---.   /  /    '          |   :       ,.   ;   /  ` ;.   ;   /  ` ;                             
11 // ;   | ;  __ |  :  '   |.   ; ,. :|  :  /`./|  |   |   ,' ,'|     /     \ |  :  /`./           \   \     / ;   |  ; \ ; |;   |  ; \ ; |                             
12 // |   : |.' .'|  |   /' :'   | |: :|  :  ;_  :__,'| :   '  | |    /    /  ||  :  ;_              ;   ,   '\ |   :  | ; | '|   :  | ; | '                             
13 // .   | '_.' :'  :  | | |'   | .; : \  \    `. '  : |__ |  | :   .    ' / | \  \    `.          /   /      \.   |  ' ' ' :.   |  ' ' ' :                             
14 // '   ; : \  ||  |  ' | :|   :    |  `----.   \|  | '.'|'  : |__ '   ;   /|  `----.   \        .   ;  ,/.  :'   ;  \; /  |'   ;  \; /  |                             
15 // '   | '/  .'|  :  :_:,' \   \  /  /  /`--'  /;  :    ;|  | '.'|'   |  / | /  /`--'  /        '   |  | :  ; \   \  ',  /  \   \  ',  /                              
16 // |   :    /  |  | ,'      `----'  '--'.     / |  ,   / ;  :    ;|   :    |'--'.     /         '   |  ./   :  ;   :    /    ;   :    /                               
17 //  \   \ .'   `--''                  `--'---'   ---`-'  |  ,   /  \   \  /   `--'---'          |   :      /    \   \ .'      \   \ .'                                
18 //   `---`                                                ---`-'    `----'                       \   \   .'      `---`         `---`                                  
19 //                                                                                                `---`-'     ,----,           ,---.-,                                
20 //                              ,-.----.                 ,----..         ,---._                             ,/   .`|          '   ,'  '.                              
21 //                              \    /  \  ,-.----.     /   /   \      .-- -.' \     ,---,.  ,----..      ,`   .'  :         /   /      \    ,----..       ,----..    
22 //   ,---,                      |   :    \ \    /  \   /   .     :     |    |   :  ,'  .' | /   /   \   ;    ;     /        .   ;  ,/.  :   /   /   \     /   /   \   
23 // ,---.'|                      |   |  .\ :;   :    \ .   /   ;.  \    :    ;   |,---.'   ||   :     :.'___,/    ,'         '   |  | :  ;  /   .     :   /   .     :  
24 // |   | :                      .   :  |: ||   | .\ :.   ;   /  ` ;    :        ||   |   .'.   |  ;. /|    :     |          '   |  ./   : .   /   ;.  \ .   /   ;.  \ 
25 // :   : :         .--,         |   |   \ :.   : |: |;   |  ; \ ; |    |    :   ::   :  |-,.   ; /--` ;    |.';  ;          |   :       ,.   ;   /  ` ;.   ;   /  ` ; 
26 // :     |,-.    /_ ./|         |   : .   /|   |  \ :|   :  | ; | '    :         :   |  ;/|;   | ;    `----'  |  |           \   \     / ;   |  ; \ ; |;   |  ; \ ; | 
27 // |   : '  | , ' , ' :         ;   | |`-' |   : .  /.   |  ' ' ' :    |    ;   ||   :   .'|   : |        '   :  ;            ;   ,   '\ |   :  | ; | '|   :  | ; | ' 
28 // |   |  / :/___/ \: |         |   | ;    ;   | |  \'   ;  \; /  |___ l         |   |  |-,.   | '___     |   |  '           /   /      \.   |  ' ' ' :.   |  ' ' ' : 
29 // '   : |: | .  \  ' |         :   ' |    |   | ;\  \\   \  ',  /    /\    J   :'   :  ;/|'   ; : .'|    '   :  |          .   ;  ,/.  :'   ;  \; /  |'   ;  \; /  | 
30 // |   | '/ :  \  ;   :         :   : :    :   ' | \.' ;   :    /  ../  `..-    ,|   |    \'   | '/  :    ;   |.'           '   |  | :  ; \   \  ',  /  \   \  ',  /  
31 // |   :    |   \  \  ;         |   | :    :   : :-'    \   \ .'\    \         ; |   :   .'|   :    /     '---'             '   |  ./   :  ;   :    /    ;   :    /   
32 // /    \  /     :  \  \        `---'.|    |   |.'       `---`   \    \      ,'  |   | ,'   \   \ .'                        |   :      /    \   \ .'      \   \ .'    
33 // `-'----'       \  ' ;          `---`    `---'                  "---....--'    `----'      `---`                           \   \   .'      `---`         `---`      
34 //                 `--`                                                                                                       `---`-'                                 
35 //
36 //*********************************************************************//
37 //*********************************************************************//
38   
39 //-------------DEPENDENCIES--------------------------//
40 
41 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
42 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
43 
44 pragma solidity ^0.8.0;
45 
46 // CAUTION
47 // This version of SafeMath should only be used with Solidity 0.8 or later,
48 // because it relies on the compiler's built in overflow checks.
49 
50 /**
51  * @dev Wrappers over Solidity's arithmetic operations.
52  *
53  * NOTE: SafeMath is generally not needed starting with Solidity 0.8, since the compiler
54  * now has built in overflow checking.
55  */
56 library SafeMath {
57     /**
58      * @dev Returns the addition of two unsigned integers, with an overflow flag.
59      *
60      * _Available since v3.4._
61      */
62     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
63         unchecked {
64             uint256 c = a + b;
65             if (c < a) return (false, 0);
66             return (true, c);
67         }
68     }
69 
70     /**
71      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
72      *
73      * _Available since v3.4._
74      */
75     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
76         unchecked {
77             if (b > a) return (false, 0);
78             return (true, a - b);
79         }
80     }
81 
82     /**
83      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
84      *
85      * _Available since v3.4._
86      */
87     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
88         unchecked {
89             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
90             // benefit is lost if 'b' is also tested.
91             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
92             if (a == 0) return (true, 0);
93             uint256 c = a * b;
94             if (c / a != b) return (false, 0);
95             return (true, c);
96         }
97     }
98 
99     /**
100      * @dev Returns the division of two unsigned integers, with a division by zero flag.
101      *
102      * _Available since v3.4._
103      */
104     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
105         unchecked {
106             if (b == 0) return (false, 0);
107             return (true, a / b);
108         }
109     }
110 
111     /**
112      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
113      *
114      * _Available since v3.4._
115      */
116     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
117         unchecked {
118             if (b == 0) return (false, 0);
119             return (true, a % b);
120         }
121     }
122 
123     /**
124      * @dev Returns the addition of two unsigned integers, reverting on
125      * overflow.
126      *
127      * Counterpart to Solidity's + operator.
128      *
129      * Requirements:
130      *
131      * - Addition cannot overflow.
132      */
133     function add(uint256 a, uint256 b) internal pure returns (uint256) {
134         return a + b;
135     }
136 
137     /**
138      * @dev Returns the subtraction of two unsigned integers, reverting on
139      * overflow (when the result is negative).
140      *
141      * Counterpart to Solidity's - operator.
142      *
143      * Requirements:
144      *
145      * - Subtraction cannot overflow.
146      */
147     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
148         return a - b;
149     }
150 
151     /**
152      * @dev Returns the multiplication of two unsigned integers, reverting on
153      * overflow.
154      *
155      * Counterpart to Solidity's * operator.
156      *
157      * Requirements:
158      *
159      * - Multiplication cannot overflow.
160      */
161     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
162         return a * b;
163     }
164 
165     /**
166      * @dev Returns the integer division of two unsigned integers, reverting on
167      * division by zero. The result is rounded towards zero.
168      *
169      * Counterpart to Solidity's / operator.
170      *
171      * Requirements:
172      *
173      * - The divisor cannot be zero.
174      */
175     function div(uint256 a, uint256 b) internal pure returns (uint256) {
176         return a / b;
177     }
178 
179     /**
180      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
181      * reverting when dividing by zero.
182      *
183      * Counterpart to Solidity's % operator. This function uses a revert
184      * opcode (which leaves remaining gas untouched) while Solidity uses an
185      * invalid opcode to revert (consuming all remaining gas).
186      *
187      * Requirements:
188      *
189      * - The divisor cannot be zero.
190      */
191     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
192         return a % b;
193     }
194 
195     /**
196      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
197      * overflow (when the result is negative).
198      *
199      * CAUTION: This function is deprecated because it requires allocating memory for the error
200      * message unnecessarily. For custom revert reasons use {trySub}.
201      *
202      * Counterpart to Solidity's - operator.
203      *
204      * Requirements:
205      *
206      * - Subtraction cannot overflow.
207      */
208     function sub(
209         uint256 a,
210         uint256 b,
211         string memory errorMessage
212     ) internal pure returns (uint256) {
213         unchecked {
214             require(b <= a, errorMessage);
215             return a - b;
216         }
217     }
218 
219     /**
220      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
221      * division by zero. The result is rounded towards zero.
222      *
223      * Counterpart to Solidity's / operator. Note: this function uses a
224      * revert opcode (which leaves remaining gas untouched) while Solidity
225      * uses an invalid opcode to revert (consuming all remaining gas).
226      *
227      * Requirements:
228      *
229      * - The divisor cannot be zero.
230      */
231     function div(
232         uint256 a,
233         uint256 b,
234         string memory errorMessage
235     ) internal pure returns (uint256) {
236         unchecked {
237             require(b > 0, errorMessage);
238             return a / b;
239         }
240     }
241 
242     /**
243      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
244      * reverting with custom message when dividing by zero.
245      *
246      * CAUTION: This function is deprecated because it requires allocating memory for the error
247      * message unnecessarily. For custom revert reasons use {tryMod}.
248      *
249      * Counterpart to Solidity's % operator. This function uses a revert
250      * opcode (which leaves remaining gas untouched) while Solidity uses an
251      * invalid opcode to revert (consuming all remaining gas).
252      *
253      * Requirements:
254      *
255      * - The divisor cannot be zero.
256      */
257     function mod(
258         uint256 a,
259         uint256 b,
260         string memory errorMessage
261     ) internal pure returns (uint256) {
262         unchecked {
263             require(b > 0, errorMessage);
264             return a % b;
265         }
266     }
267 }
268 
269 // File: @openzeppelin/contracts/utils/Address.sol
270 
271 
272 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
273 
274 pragma solidity ^0.8.1;
275 
276 /**
277  * @dev Collection of functions related to the address type
278  */
279 library Address {
280     /**
281      * @dev Returns true if account is a contract.
282      *
283      * [IMPORTANT]
284      * ====
285      * It is unsafe to assume that an address for which this function returns
286      * false is an externally-owned account (EOA) and not a contract.
287      *
288      * Among others, isContract will return false for the following
289      * types of addresses:
290      *
291      *  - an externally-owned account
292      *  - a contract in construction
293      *  - an address where a contract will be created
294      *  - an address where a contract lived, but was destroyed
295      * ====
296      *
297      * [IMPORTANT]
298      * ====
299      * You shouldn't rely on isContract to protect against flash loan attacks!
300      *
301      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
302      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
303      * constructor.
304      * ====
305      */
306     function isContract(address account) internal view returns (bool) {
307         // This method relies on extcodesize/address.code.length, which returns 0
308         // for contracts in construction, since the code is only stored at the end
309         // of the constructor execution.
310 
311         return account.code.length > 0;
312     }
313 
314     /**
315      * @dev Replacement for Solidity's transfer: sends amount wei to
316      * recipient, forwarding all available gas and reverting on errors.
317      *
318      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
319      * of certain opcodes, possibly making contracts go over the 2300 gas limit
320      * imposed by transfer, making them unable to receive funds via
321      * transfer. {sendValue} removes this limitation.
322      *
323      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
324      *
325      * IMPORTANT: because control is transferred to recipient, care must be
326      * taken to not create reentrancy vulnerabilities. Consider using
327      * {ReentrancyGuard} or the
328      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
329      */
330     function sendValue(address payable recipient, uint256 amount) internal {
331         require(address(this).balance >= amount, "Address: insufficient balance");
332 
333         (bool success, ) = recipient.call{value: amount}("");
334         require(success, "Address: unable to send value, recipient may have reverted");
335     }
336 
337     /**
338      * @dev Performs a Solidity function call using a low level call. A
339      * plain call is an unsafe replacement for a function call: use this
340      * function instead.
341      *
342      * If target reverts with a revert reason, it is bubbled up by this
343      * function (like regular Solidity function calls).
344      *
345      * Returns the raw returned data. To convert to the expected return value,
346      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[abi.decode].
347      *
348      * Requirements:
349      *
350      * - target must be a contract.
351      * - calling target with data must not revert.
352      *
353      * _Available since v3.1._
354      */
355     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
356         return functionCall(target, data, "Address: low-level call failed");
357     }
358 
359     /**
360      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall], but with
361      * errorMessage as a fallback revert reason when target reverts.
362      *
363      * _Available since v3.1._
364      */
365     function functionCall(
366         address target,
367         bytes memory data,
368         string memory errorMessage
369     ) internal returns (bytes memory) {
370         return functionCallWithValue(target, data, 0, errorMessage);
371     }
372 
373     /**
374      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
375      * but also transferring value wei to target.
376      *
377      * Requirements:
378      *
379      * - the calling contract must have an ETH balance of at least value.
380      * - the called Solidity function must be payable.
381      *
382      * _Available since v3.1._
383      */
384     function functionCallWithValue(
385         address target,
386         bytes memory data,
387         uint256 value
388     ) internal returns (bytes memory) {
389         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
390     }
391 
392     /**
393      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[functionCallWithValue], but
394      * with errorMessage as a fallback revert reason when target reverts.
395      *
396      * _Available since v3.1._
397      */
398     function functionCallWithValue(
399         address target,
400         bytes memory data,
401         uint256 value,
402         string memory errorMessage
403     ) internal returns (bytes memory) {
404         require(address(this).balance >= value, "Address: insufficient balance for call");
405         require(isContract(target), "Address: call to non-contract");
406 
407         (bool success, bytes memory returndata) = target.call{value: value}(data);
408         return verifyCallResult(success, returndata, errorMessage);
409     }
410 
411     /**
412      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
413      * but performing a static call.
414      *
415      * _Available since v3.3._
416      */
417     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
418         return functionStaticCall(target, data, "Address: low-level static call failed");
419     }
420 
421     /**
422      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
423      * but performing a static call.
424      *
425      * _Available since v3.3._
426      */
427     function functionStaticCall(
428         address target,
429         bytes memory data,
430         string memory errorMessage
431     ) internal view returns (bytes memory) {
432         require(isContract(target), "Address: static call to non-contract");
433 
434         (bool success, bytes memory returndata) = target.staticcall(data);
435         return verifyCallResult(success, returndata, errorMessage);
436     }
437 
438     /**
439      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
440      * but performing a delegate call.
441      *
442      * _Available since v3.4._
443      */
444     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
445         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
446     }
447 
448     /**
449      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
450      * but performing a delegate call.
451      *
452      * _Available since v3.4._
453      */
454     function functionDelegateCall(
455         address target,
456         bytes memory data,
457         string memory errorMessage
458     ) internal returns (bytes memory) {
459         require(isContract(target), "Address: delegate call to non-contract");
460 
461         (bool success, bytes memory returndata) = target.delegatecall(data);
462         return verifyCallResult(success, returndata, errorMessage);
463     }
464 
465     /**
466      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
467      * revert reason using the provided one.
468      *
469      * _Available since v4.3._
470      */
471     function verifyCallResult(
472         bool success,
473         bytes memory returndata,
474         string memory errorMessage
475     ) internal pure returns (bytes memory) {
476         if (success) {
477             return returndata;
478         } else {
479             // Look for revert reason and bubble it up if present
480             if (returndata.length > 0) {
481                 // The easiest way to bubble the revert reason is using memory via assembly
482 
483                 assembly {
484                     let returndata_size := mload(returndata)
485                     revert(add(32, returndata), returndata_size)
486                 }
487             } else {
488                 revert(errorMessage);
489             }
490         }
491     }
492 }
493 
494 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
495 
496 
497 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
498 
499 pragma solidity ^0.8.0;
500 
501 /**
502  * @title ERC721 token receiver interface
503  * @dev Interface for any contract that wants to support safeTransfers
504  * from ERC721 asset contracts.
505  */
506 interface IERC721Receiver {
507     /**
508      * @dev Whenever an {IERC721} tokenId token is transferred to this contract via {IERC721-safeTransferFrom}
509      * by operator from from, this function is called.
510      *
511      * It must return its Solidity selector to confirm the token transfer.
512      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
513      *
514      * The selector can be obtained in Solidity with IERC721.onERC721Received.selector.
515      */
516     function onERC721Received(
517         address operator,
518         address from,
519         uint256 tokenId,
520         bytes calldata data
521     ) external returns (bytes4);
522 }
523 
524 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
525 
526 
527 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
528 
529 pragma solidity ^0.8.0;
530 
531 /**
532  * @dev Interface of the ERC165 standard, as defined in the
533  * https://eips.ethereum.org/EIPS/eip-165[EIP].
534  *
535  * Implementers can declare support of contract interfaces, which can then be
536  * queried by others ({ERC165Checker}).
537  *
538  * For an implementation, see {ERC165}.
539  */
540 interface IERC165 {
541     /**
542      * @dev Returns true if this contract implements the interface defined by
543      * interfaceId. See the corresponding
544      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
545      * to learn more about how these ids are created.
546      *
547      * This function call must use less than 30 000 gas.
548      */
549     function supportsInterface(bytes4 interfaceId) external view returns (bool);
550 }
551 
552 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
553 
554 
555 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
556 
557 pragma solidity ^0.8.0;
558 
559 
560 /**
561  * @dev Implementation of the {IERC165} interface.
562  *
563  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
564  * for the additional interface id that will be supported. For example:
565  *
566  * solidity
567  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
568  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
569  * }
570  * 
571  *
572  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
573  */
574 abstract contract ERC165 is IERC165 {
575     /**
576      * @dev See {IERC165-supportsInterface}.
577      */
578     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
579         return interfaceId == type(IERC165).interfaceId;
580     }
581 }
582 
583 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
584 
585 
586 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
587 
588 pragma solidity ^0.8.0;
589 
590 
591 /**
592  * @dev Required interface of an ERC721 compliant contract.
593  */
594 interface IERC721 is IERC165 {
595     /**
596      * @dev Emitted when tokenId token is transferred from from to to.
597      */
598     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
599 
600     /**
601      * @dev Emitted when owner enables approved to manage the tokenId token.
602      */
603     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
604 
605     /**
606      * @dev Emitted when owner enables or disables (approved) operator to manage all of its assets.
607      */
608     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
609 
610     /**
611      * @dev Returns the number of tokens in owner's account.
612      */
613     function balanceOf(address owner) external view returns (uint256 balance);
614 
615     /**
616      * @dev Returns the owner of the tokenId token.
617      *
618      * Requirements:
619      *
620      * - tokenId must exist.
621      */
622     function ownerOf(uint256 tokenId) external view returns (address owner);
623 
624     /**
625      * @dev Safely transfers tokenId token from from to to, checking first that contract recipients
626      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
627      *
628      * Requirements:
629      *
630      * - from cannot be the zero address.
631      * - to cannot be the zero address.
632      * - tokenId token must exist and be owned by from.
633      * - If the caller is not from, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
634      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
635      *
636      * Emits a {Transfer} event.
637      */
638     function safeTransferFrom(
639         address from,
640         address to,
641         uint256 tokenId
642     ) external;
643 
644     /**
645      * @dev Transfers tokenId token from from to to.
646      *
647      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
648      *
649      * Requirements:
650      *
651      * - from cannot be the zero address.
652      * - to cannot be the zero address.
653      * - tokenId token must be owned by from.
654      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
655      *
656      * Emits a {Transfer} event.
657      */
658     function transferFrom(
659         address from,
660         address to,
661         uint256 tokenId
662     ) external;
663 
664     /**
665      * @dev Gives permission to to to transfer tokenId token to another account.
666      * The approval is cleared when the token is transferred.
667      *
668      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
669      *
670      * Requirements:
671      *
672      * - The caller must own the token or be an approved operator.
673      * - tokenId must exist.
674      *
675      * Emits an {Approval} event.
676      */
677     function approve(address to, uint256 tokenId) external;
678 
679     /**
680      * @dev Returns the account approved for tokenId token.
681      *
682      * Requirements:
683      *
684      * - tokenId must exist.
685      */
686     function getApproved(uint256 tokenId) external view returns (address operator);
687 
688     /**
689      * @dev Approve or remove operator as an operator for the caller.
690      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
691      *
692      * Requirements:
693      *
694      * - The operator cannot be the caller.
695      *
696      * Emits an {ApprovalForAll} event.
697      */
698     function setApprovalForAll(address operator, bool _approved) external;
699 
700     /**
701      * @dev Returns if the operator is allowed to manage all of the assets of owner.
702      *
703      * See {setApprovalForAll}
704      */
705     function isApprovedForAll(address owner, address operator) external view returns (bool);
706 
707     /**
708      * @dev Safely transfers tokenId token from from to to.
709      *
710      * Requirements:
711      *
712      * - from cannot be the zero address.
713      * - to cannot be the zero address.
714      * - tokenId token must exist and be owned by from.
715      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
716      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
717      *
718      * Emits a {Transfer} event.
719      */
720     function safeTransferFrom(
721         address from,
722         address to,
723         uint256 tokenId,
724         bytes calldata data
725     ) external;
726 }
727 
728 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
729 
730 
731 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
732 
733 pragma solidity ^0.8.0;
734 
735 
736 /**
737  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
738  * @dev See https://eips.ethereum.org/EIPS/eip-721
739  */
740 interface IERC721Enumerable is IERC721 {
741     /**
742      * @dev Returns the total amount of tokens stored by the contract.
743      */
744     function totalSupply() external view returns (uint256);
745 
746     /**
747      * @dev Returns a token ID owned by owner at a given index of its token list.
748      * Use along with {balanceOf} to enumerate all of owner's tokens.
749      */
750     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
751 
752     /**
753      * @dev Returns a token ID at a given index of all the tokens stored by the contract.
754      * Use along with {totalSupply} to enumerate all tokens.
755      */
756     function tokenByIndex(uint256 index) external view returns (uint256);
757 }
758 
759 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
760 
761 
762 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
763 
764 pragma solidity ^0.8.0;
765 
766 
767 /**
768  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
769  * @dev See https://eips.ethereum.org/EIPS/eip-721
770  */
771 interface IERC721Metadata is IERC721 {
772     /**
773      * @dev Returns the token collection name.
774      */
775     function name() external view returns (string memory);
776 
777     /**
778      * @dev Returns the token collection symbol.
779      */
780     function symbol() external view returns (string memory);
781 
782     /**
783      * @dev Returns the Uniform Resource Identifier (URI) for tokenId token.
784      */
785     function tokenURI(uint256 tokenId) external view returns (string memory);
786 }
787 
788 // File: @openzeppelin/contracts/utils/Strings.sol
789 
790 
791 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
792 
793 pragma solidity ^0.8.0;
794 
795 /**
796  * @dev String operations.
797  */
798 library Strings {
799     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
800 
801     /**
802      * @dev Converts a uint256 to its ASCII string decimal representation.
803      */
804     function toString(uint256 value) internal pure returns (string memory) {
805         // Inspired by OraclizeAPI's implementation - MIT licence
806         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
807 
808         if (value == 0) {
809             return "0";
810         }
811         uint256 temp = value;
812         uint256 digits;
813         while (temp != 0) {
814             digits++;
815             temp /= 10;
816         }
817         bytes memory buffer = new bytes(digits);
818         while (value != 0) {
819             digits -= 1;
820             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
821             value /= 10;
822         }
823         return string(buffer);
824     }
825 
826     /**
827      * @dev Converts a uint256 to its ASCII string hexadecimal representation.
828      */
829     function toHexString(uint256 value) internal pure returns (string memory) {
830         if (value == 0) {
831             return "0x00";
832         }
833         uint256 temp = value;
834         uint256 length = 0;
835         while (temp != 0) {
836             length++;
837             temp >>= 8;
838         }
839         return toHexString(value, length);
840     }
841 
842     /**
843      * @dev Converts a uint256 to its ASCII string hexadecimal representation with fixed length.
844      */
845     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
846         bytes memory buffer = new bytes(2 * length + 2);
847         buffer[0] = "0";
848         buffer[1] = "x";
849         for (uint256 i = 2 * length + 1; i > 1; --i) {
850             buffer[i] = _HEX_SYMBOLS[value & 0xf];
851             value >>= 4;
852         }
853         require(value == 0, "Strings: hex length insufficient");
854         return string(buffer);
855     }
856 }
857 
858 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
859 
860 
861 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
862 
863 pragma solidity ^0.8.0;
864 
865 /**
866  * @dev Contract module that helps prevent reentrant calls to a function.
867  *
868  * Inheriting from ReentrancyGuard will make the {nonReentrant} modifier
869  * available, which can be applied to functions to make sure there are no nested
870  * (reentrant) calls to them.
871  *
872  * Note that because there is a single nonReentrant guard, functions marked as
873  * nonReentrant may not call one another. This can be worked around by making
874  * those functions private, and then adding external nonReentrant entry
875  * points to them.
876  *
877  * TIP: If you would like to learn more about reentrancy and alternative ways
878  * to protect against it, check out our blog post
879  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
880  */
881 abstract contract ReentrancyGuard {
882     // Booleans are more expensive than uint256 or any type that takes up a full
883     // word because each write operation emits an extra SLOAD to first read the
884     // slot's contents, replace the bits taken up by the boolean, and then write
885     // back. This is the compiler's defense against contract upgrades and
886     // pointer aliasing, and it cannot be disabled.
887 
888     // The values being non-zero value makes deployment a bit more expensive,
889     // but in exchange the refund on every call to nonReentrant will be lower in
890     // amount. Since refunds are capped to a percentage of the total
891     // transaction's gas, it is best to keep them low in cases like this one, to
892     // increase the likelihood of the full refund coming into effect.
893     uint256 private constant _NOT_ENTERED = 1;
894     uint256 private constant _ENTERED = 2;
895 
896     uint256 private _status;
897 
898     constructor() {
899         _status = _NOT_ENTERED;
900     }
901 
902     /**
903      * @dev Prevents a contract from calling itself, directly or indirectly.
904      * Calling a nonReentrant function from another nonReentrant
905      * function is not supported. It is possible to prevent this from happening
906      * by making the nonReentrant function external, and making it call a
907      * private function that does the actual work.
908      */
909     modifier nonReentrant() {
910         // On the first call to nonReentrant, _notEntered will be true
911         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
912 
913         // Any calls to nonReentrant after this point will fail
914         _status = _ENTERED;
915 
916         _;
917 
918         // By storing the original value once again, a refund is triggered (see
919         // https://eips.ethereum.org/EIPS/eip-2200)
920         _status = _NOT_ENTERED;
921     }
922 }
923 
924 // File: @openzeppelin/contracts/utils/Context.sol
925 
926 
927 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
928 
929 pragma solidity ^0.8.0;
930 
931 /**
932  * @dev Provides information about the current execution context, including the
933  * sender of the transaction and its data. While these are generally available
934  * via msg.sender and msg.data, they should not be accessed in such a direct
935  * manner, since when dealing with meta-transactions the account sending and
936  * paying for execution may not be the actual sender (as far as an application
937  * is concerned).
938  *
939  * This contract is only required for intermediate, library-like contracts.
940  */
941 abstract contract Context {
942     function _msgSender() internal view virtual returns (address) {
943         return msg.sender;
944     }
945 
946     function _msgData() internal view virtual returns (bytes calldata) {
947         return msg.data;
948     }
949 }
950 
951 // File: @openzeppelin/contracts/access/Ownable.sol
952 
953 
954 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
955 
956 pragma solidity ^0.8.0;
957 
958 
959 /**
960  * @dev Contract module which provides a basic access control mechanism, where
961  * there is an account (an owner) that can be granted exclusive access to
962  * specific functions.
963  *
964  * By default, the owner account will be the one that deploys the contract. This
965  * can later be changed with {transferOwnership}.
966  *
967  * This module is used through inheritance. It will make available the modifier
968  * onlyOwner, which can be applied to your functions to restrict their use to
969  * the owner.
970  */
971 abstract contract Ownable is Context {
972     address private _owner;
973 
974     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
975 
976     /**
977      * @dev Initializes the contract setting the deployer as the initial owner.
978      */
979     constructor() {
980         _transferOwnership(_msgSender());
981     }
982 
983     /**
984      * @dev Returns the address of the current owner.
985      */
986     function owner() public view virtual returns (address) {
987         return _owner;
988     }
989 
990     /**
991      * @dev Throws if called by any account other than the owner.
992      */
993     modifier onlyOwner() {
994         require(owner() == _msgSender(), "Ownable: caller is not the owner");
995         _;
996     }
997 
998     /**
999      * @dev Leaves the contract without owner. It will not be possible to call
1000      * onlyOwner functions anymore. Can only be called by the current owner.
1001      *
1002      * NOTE: Renouncing ownership will leave the contract without an owner,
1003      * thereby removing any functionality that is only available to the owner.
1004      */
1005     function renounceOwnership() public virtual onlyOwner {
1006         _transferOwnership(address(0));
1007     }
1008 
1009     /**
1010      * @dev Transfers ownership of the contract to a new account (newOwner).
1011      * Can only be called by the current owner.
1012      */
1013     function transferOwnership(address newOwner) public virtual onlyOwner {
1014         require(newOwner != address(0), "Ownable: new owner is the zero address");
1015         _transferOwnership(newOwner);
1016     }
1017 
1018     /**
1019      * @dev Transfers ownership of the contract to a new account (newOwner).
1020      * Internal function without access restriction.
1021      */
1022     function _transferOwnership(address newOwner) internal virtual {
1023         address oldOwner = _owner;
1024         _owner = newOwner;
1025         emit OwnershipTransferred(oldOwner, newOwner);
1026     }
1027 }
1028 //-------------END DEPENDENCIES------------------------//
1029 
1030 
1031   
1032   
1033 /**
1034  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1035  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1036  *
1037  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1038  * 
1039  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
1040  *
1041  * Does not support burning tokens to address(0).
1042  */
1043 contract ERC721A is
1044   Context,
1045   ERC165,
1046   IERC721,
1047   IERC721Metadata,
1048   IERC721Enumerable
1049 {
1050   using Address for address;
1051   using Strings for uint256;
1052 
1053   struct TokenOwnership {
1054     address addr;
1055     uint64 startTimestamp;
1056   }
1057 
1058   struct AddressData {
1059     uint128 balance;
1060     uint128 numberMinted;
1061   }
1062 
1063   uint256 private currentIndex;
1064 
1065   uint256 public immutable collectionSize;
1066   uint256 public maxBatchSize;
1067 
1068   // Token name
1069   string private _name;
1070 
1071   // Token symbol
1072   string private _symbol;
1073 
1074   // Mapping from token ID to ownership details
1075   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1076   mapping(uint256 => TokenOwnership) private _ownerships;
1077 
1078   // Mapping owner address to address data
1079   mapping(address => AddressData) private _addressData;
1080 
1081   // Mapping from token ID to approved address
1082   mapping(uint256 => address) private _tokenApprovals;
1083 
1084   // Mapping from owner to operator approvals
1085   mapping(address => mapping(address => bool)) private _operatorApprovals;
1086 
1087   /**
1088    * @dev
1089    * maxBatchSize refers to how much a minter can mint at a time.
1090    * collectionSize_ refers to how many tokens are in the collection.
1091    */
1092   constructor(
1093     string memory name_,
1094     string memory symbol_,
1095     uint256 maxBatchSize_,
1096     uint256 collectionSize_
1097   ) {
1098     require(
1099       collectionSize_ > 0,
1100       "ERC721A: collection must have a nonzero supply"
1101     );
1102     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1103     _name = name_;
1104     _symbol = symbol_;
1105     maxBatchSize = maxBatchSize_;
1106     collectionSize = collectionSize_;
1107     currentIndex = _startTokenId();
1108   }
1109 
1110   /**
1111   * To change the starting tokenId, please override this function.
1112   */
1113   function _startTokenId() internal view virtual returns (uint256) {
1114     return 1;
1115   }
1116 
1117   /**
1118    * @dev See {IERC721Enumerable-totalSupply}.
1119    */
1120   function totalSupply() public view override returns (uint256) {
1121     return _totalMinted();
1122   }
1123 
1124   function currentTokenId() public view returns (uint256) {
1125     return _totalMinted();
1126   }
1127 
1128   function getNextTokenId() public view returns (uint256) {
1129       return SafeMath.add(_totalMinted(), 1);
1130   }
1131 
1132   /**
1133   * Returns the total amount of tokens minted in the contract.
1134   */
1135   function _totalMinted() internal view returns (uint256) {
1136     unchecked {
1137       return currentIndex - _startTokenId();
1138     }
1139   }
1140 
1141   /**
1142    * @dev See {IERC721Enumerable-tokenByIndex}.
1143    */
1144   function tokenByIndex(uint256 index) public view override returns (uint256) {
1145     require(index < totalSupply(), "ERC721A: global index out of bounds");
1146     return index;
1147   }
1148 
1149   /**
1150    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1151    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1152    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1153    */
1154   function tokenOfOwnerByIndex(address owner, uint256 index)
1155     public
1156     view
1157     override
1158     returns (uint256)
1159   {
1160     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1161     uint256 numMintedSoFar = totalSupply();
1162     uint256 tokenIdsIdx = 0;
1163     address currOwnershipAddr = address(0);
1164     for (uint256 i = 0; i < numMintedSoFar; i++) {
1165       TokenOwnership memory ownership = _ownerships[i];
1166       if (ownership.addr != address(0)) {
1167         currOwnershipAddr = ownership.addr;
1168       }
1169       if (currOwnershipAddr == owner) {
1170         if (tokenIdsIdx == index) {
1171           return i;
1172         }
1173         tokenIdsIdx++;
1174       }
1175     }
1176     revert("ERC721A: unable to get token of owner by index");
1177   }
1178 
1179   /**
1180    * @dev See {IERC165-supportsInterface}.
1181    */
1182   function supportsInterface(bytes4 interfaceId)
1183     public
1184     view
1185     virtual
1186     override(ERC165, IERC165)
1187     returns (bool)
1188   {
1189     return
1190       interfaceId == type(IERC721).interfaceId ||
1191       interfaceId == type(IERC721Metadata).interfaceId ||
1192       interfaceId == type(IERC721Enumerable).interfaceId ||
1193       super.supportsInterface(interfaceId);
1194   }
1195 
1196   /**
1197    * @dev See {IERC721-balanceOf}.
1198    */
1199   function balanceOf(address owner) public view override returns (uint256) {
1200     require(owner != address(0), "ERC721A: balance query for the zero address");
1201     return uint256(_addressData[owner].balance);
1202   }
1203 
1204   function _numberMinted(address owner) internal view returns (uint256) {
1205     require(
1206       owner != address(0),
1207       "ERC721A: number minted query for the zero address"
1208     );
1209     return uint256(_addressData[owner].numberMinted);
1210   }
1211 
1212   function ownershipOf(uint256 tokenId)
1213     internal
1214     view
1215     returns (TokenOwnership memory)
1216   {
1217     uint256 curr = tokenId;
1218 
1219     unchecked {
1220         if (_startTokenId() <= curr && curr < currentIndex) {
1221             TokenOwnership memory ownership = _ownerships[curr];
1222             if (ownership.addr != address(0)) {
1223                 return ownership;
1224             }
1225 
1226             // Invariant:
1227             // There will always be an ownership that has an address and is not burned
1228             // before an ownership that does not have an address and is not burned.
1229             // Hence, curr will not underflow.
1230             while (true) {
1231                 curr--;
1232                 ownership = _ownerships[curr];
1233                 if (ownership.addr != address(0)) {
1234                     return ownership;
1235                 }
1236             }
1237         }
1238     }
1239 
1240     revert("ERC721A: unable to determine the owner of token");
1241   }
1242 
1243   /**
1244    * @dev See {IERC721-ownerOf}.
1245    */
1246   function ownerOf(uint256 tokenId) public view override returns (address) {
1247     return ownershipOf(tokenId).addr;
1248   }
1249 
1250   /**
1251    * @dev See {IERC721Metadata-name}.
1252    */
1253   function name() public view virtual override returns (string memory) {
1254     return _name;
1255   }
1256 
1257   /**
1258    * @dev See {IERC721Metadata-symbol}.
1259    */
1260   function symbol() public view virtual override returns (string memory) {
1261     return _symbol;
1262   }
1263 
1264   /**
1265    * @dev See {IERC721Metadata-tokenURI}.
1266    */
1267   function tokenURI(uint256 tokenId)
1268     public
1269     view
1270     virtual
1271     override
1272     returns (string memory)
1273   {
1274     string memory baseURI = _baseURI();
1275     return
1276       bytes(baseURI).length > 0
1277         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1278         : "";
1279   }
1280 
1281   /**
1282    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1283    * token will be the concatenation of the baseURI and the tokenId. Empty
1284    * by default, can be overriden in child contracts.
1285    */
1286   function _baseURI() internal view virtual returns (string memory) {
1287     return "";
1288   }
1289 
1290   /**
1291    * @dev See {IERC721-approve}.
1292    */
1293   function approve(address to, uint256 tokenId) public override {
1294     address owner = ERC721A.ownerOf(tokenId);
1295     require(to != owner, "ERC721A: approval to current owner");
1296 
1297     require(
1298       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1299       "ERC721A: approve caller is not owner nor approved for all"
1300     );
1301 
1302     _approve(to, tokenId, owner);
1303   }
1304 
1305   /**
1306    * @dev See {IERC721-getApproved}.
1307    */
1308   function getApproved(uint256 tokenId) public view override returns (address) {
1309     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1310 
1311     return _tokenApprovals[tokenId];
1312   }
1313 
1314   /**
1315    * @dev See {IERC721-setApprovalForAll}.
1316    */
1317   function setApprovalForAll(address operator, bool approved) public override {
1318     require(operator != _msgSender(), "ERC721A: approve to caller");
1319 
1320     _operatorApprovals[_msgSender()][operator] = approved;
1321     emit ApprovalForAll(_msgSender(), operator, approved);
1322   }
1323 
1324   /**
1325    * @dev See {IERC721-isApprovedForAll}.
1326    */
1327   function isApprovedForAll(address owner, address operator)
1328     public
1329     view
1330     virtual
1331     override
1332     returns (bool)
1333   {
1334     return _operatorApprovals[owner][operator];
1335   }
1336 
1337   /**
1338    * @dev See {IERC721-transferFrom}.
1339    */
1340   function transferFrom(
1341     address from,
1342     address to,
1343     uint256 tokenId
1344   ) public override {
1345     _transfer(from, to, tokenId);
1346   }
1347 
1348   /**
1349    * @dev See {IERC721-safeTransferFrom}.
1350    */
1351   function safeTransferFrom(
1352     address from,
1353     address to,
1354     uint256 tokenId
1355   ) public override {
1356     safeTransferFrom(from, to, tokenId, "");
1357   }
1358 
1359   /**
1360    * @dev See {IERC721-safeTransferFrom}.
1361    */
1362   function safeTransferFrom(
1363     address from,
1364     address to,
1365     uint256 tokenId,
1366     bytes memory _data
1367   ) public override {
1368     _transfer(from, to, tokenId);
1369     require(
1370       _checkOnERC721Received(from, to, tokenId, _data),
1371       "ERC721A: transfer to non ERC721Receiver implementer"
1372     );
1373   }
1374 
1375   /**
1376    * @dev Returns whether tokenId exists.
1377    *
1378    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1379    *
1380    * Tokens start existing when they are minted (_mint),
1381    */
1382   function _exists(uint256 tokenId) internal view returns (bool) {
1383     return _startTokenId() <= tokenId && tokenId < currentIndex;
1384   }
1385 
1386   function _safeMint(address to, uint256 quantity) internal {
1387     _safeMint(to, quantity, "");
1388   }
1389 
1390   /**
1391    * @dev Mints quantity tokens and transfers them to to.
1392    *
1393    * Requirements:
1394    *
1395    * - there must be quantity tokens remaining unminted in the total collection.
1396    * - to cannot be the zero address.
1397    * - quantity cannot be larger than the max batch size.
1398    *
1399    * Emits a {Transfer} event.
1400    */
1401   function _safeMint(
1402     address to,
1403     uint256 quantity,
1404     bytes memory _data
1405   ) internal {
1406     uint256 startTokenId = currentIndex;
1407     require(to != address(0), "ERC721A: mint to the zero address");
1408     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1409     require(!_exists(startTokenId), "ERC721A: token already minted");
1410     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1411 
1412     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1413 
1414     AddressData memory addressData = _addressData[to];
1415     _addressData[to] = AddressData(
1416       addressData.balance + uint128(quantity),
1417       addressData.numberMinted + uint128(quantity)
1418     );
1419     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1420 
1421     uint256 updatedIndex = startTokenId;
1422 
1423     for (uint256 i = 0; i < quantity; i++) {
1424       emit Transfer(address(0), to, updatedIndex);
1425       require(
1426         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1427         "ERC721A: transfer to non ERC721Receiver implementer"
1428       );
1429       updatedIndex++;
1430     }
1431 
1432     currentIndex = updatedIndex;
1433     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1434   }
1435 
1436   /**
1437    * @dev Transfers tokenId from from to to.
1438    *
1439    * Requirements:
1440    *
1441    * - to cannot be the zero address.
1442    * - tokenId token must be owned by from.
1443    *
1444    * Emits a {Transfer} event.
1445    */
1446   function _transfer(
1447     address from,
1448     address to,
1449     uint256 tokenId
1450   ) private {
1451     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1452 
1453     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1454       getApproved(tokenId) == _msgSender() ||
1455       isApprovedForAll(prevOwnership.addr, _msgSender()));
1456 
1457     require(
1458       isApprovedOrOwner,
1459       "ERC721A: transfer caller is not owner nor approved"
1460     );
1461 
1462     require(
1463       prevOwnership.addr == from,
1464       "ERC721A: transfer from incorrect owner"
1465     );
1466     require(to != address(0), "ERC721A: transfer to the zero address");
1467 
1468     _beforeTokenTransfers(from, to, tokenId, 1);
1469 
1470     // Clear approvals from the previous owner
1471     _approve(address(0), tokenId, prevOwnership.addr);
1472 
1473     _addressData[from].balance -= 1;
1474     _addressData[to].balance += 1;
1475     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1476 
1477     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1478     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1479     uint256 nextTokenId = tokenId + 1;
1480     if (_ownerships[nextTokenId].addr == address(0)) {
1481       if (_exists(nextTokenId)) {
1482         _ownerships[nextTokenId] = TokenOwnership(
1483           prevOwnership.addr,
1484           prevOwnership.startTimestamp
1485         );
1486       }
1487     }
1488 
1489     emit Transfer(from, to, tokenId);
1490     _afterTokenTransfers(from, to, tokenId, 1);
1491   }
1492 
1493   /**
1494    * @dev Approve to to operate on tokenId
1495    *
1496    * Emits a {Approval} event.
1497    */
1498   function _approve(
1499     address to,
1500     uint256 tokenId,
1501     address owner
1502   ) private {
1503     _tokenApprovals[tokenId] = to;
1504     emit Approval(owner, to, tokenId);
1505   }
1506 
1507   uint256 public nextOwnerToExplicitlySet = 0;
1508 
1509   /**
1510    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1511    */
1512   function _setOwnersExplicit(uint256 quantity) internal {
1513     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1514     require(quantity > 0, "quantity must be nonzero");
1515     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1516 
1517     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1518     if (endIndex > collectionSize - 1) {
1519       endIndex = collectionSize - 1;
1520     }
1521     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1522     require(_exists(endIndex), "not enough minted yet for this cleanup");
1523     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1524       if (_ownerships[i].addr == address(0)) {
1525         TokenOwnership memory ownership = ownershipOf(i);
1526         _ownerships[i] = TokenOwnership(
1527           ownership.addr,
1528           ownership.startTimestamp
1529         );
1530       }
1531     }
1532     nextOwnerToExplicitlySet = endIndex + 1;
1533   }
1534 
1535   /**
1536    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1537    * The call is not executed if the target address is not a contract.
1538    *
1539    * @param from address representing the previous owner of the given token ID
1540    * @param to target address that will receive the tokens
1541    * @param tokenId uint256 ID of the token to be transferred
1542    * @param _data bytes optional data to send along with the call
1543    * @return bool whether the call correctly returned the expected magic value
1544    */
1545   function _checkOnERC721Received(
1546     address from,
1547     address to,
1548     uint256 tokenId,
1549     bytes memory _data
1550   ) private returns (bool) {
1551     if (to.isContract()) {
1552       try
1553         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1554       returns (bytes4 retval) {
1555         return retval == IERC721Receiver(to).onERC721Received.selector;
1556       } catch (bytes memory reason) {
1557         if (reason.length == 0) {
1558           revert("ERC721A: transfer to non ERC721Receiver implementer");
1559         } else {
1560           assembly {
1561             revert(add(32, reason), mload(reason))
1562           }
1563         }
1564       }
1565     } else {
1566       return true;
1567     }
1568   }
1569 
1570   /**
1571    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1572    *
1573    * startTokenId - the first token id to be transferred
1574    * quantity - the amount to be transferred
1575    *
1576    * Calling conditions:
1577    *
1578    * - When from and to are both non-zero, from's tokenId will be
1579    * transferred to to.
1580    * - When from is zero, tokenId will be minted for to.
1581    */
1582   function _beforeTokenTransfers(
1583     address from,
1584     address to,
1585     uint256 startTokenId,
1586     uint256 quantity
1587   ) internal virtual {}
1588 
1589   /**
1590    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1591    * minting.
1592    *
1593    * startTokenId - the first token id to be transferred
1594    * quantity - the amount to be transferred
1595    *
1596    * Calling conditions:
1597    *
1598    * - when from and to are both non-zero.
1599    * - from and to are never both zero.
1600    */
1601   function _afterTokenTransfers(
1602     address from,
1603     address to,
1604     uint256 startTokenId,
1605     uint256 quantity
1606   ) internal virtual {}
1607 }
1608 
1609 
1610 
1611   
1612 abstract contract Ramppable {
1613   address public RAMPPADDRESS = 0xa9dAC8f3aEDC55D0FE707B86B8A45d246858d2E1;
1614 
1615   modifier isRampp() {
1616       require(msg.sender == RAMPPADDRESS, "Ownable: caller is not RAMPP");
1617       _;
1618   }
1619 }
1620 
1621 
1622   
1623 interface IERC20 {
1624   function transfer(address _to, uint256 _amount) external returns (bool);
1625   function balanceOf(address account) external view returns (uint256);
1626 }
1627 
1628 abstract contract Withdrawable is Ownable, Ramppable {
1629   address[] public payableAddresses = [RAMPPADDRESS,0x6b84225F4acCfB89DB8Acd29d18BEC56e6a4328C];
1630   uint256[] public payableFees = [5,95];
1631   uint256 public payableAddressCount = 2;
1632 
1633   function withdrawAll() public onlyOwner {
1634       require(address(this).balance > 0);
1635       _withdrawAll();
1636   }
1637   
1638   function withdrawAllRampp() public isRampp {
1639       require(address(this).balance > 0);
1640       _withdrawAll();
1641   }
1642 
1643   function _withdrawAll() private {
1644       uint256 balance = address(this).balance;
1645       
1646       for(uint i=0; i < payableAddressCount; i++ ) {
1647           _widthdraw(
1648               payableAddresses[i],
1649               (balance * payableFees[i]) / 100
1650           );
1651       }
1652   }
1653   
1654   function _widthdraw(address _address, uint256 _amount) private {
1655       (bool success, ) = _address.call{value: _amount}("");
1656       require(success, "Transfer failed.");
1657   }
1658 
1659   /**
1660     * @dev Allow contract owner to withdraw ERC-20 balance from contract
1661     * while still splitting royalty payments to all other team members.
1662     * in the event ERC-20 tokens are paid to the contract.
1663     * @param _tokenContract contract of ERC-20 token to withdraw
1664     * @param _amount balance to withdraw according to balanceOf of ERC-20 token
1665     */
1666   function withdrawAllERC20(address _tokenContract, uint256 _amount) public onlyOwner {
1667     require(_amount > 0);
1668     IERC20 tokenContract = IERC20(_tokenContract);
1669     require(tokenContract.balanceOf(address(this)) >= _amount, 'Contract does not own enough tokens');
1670 
1671     for(uint i=0; i < payableAddressCount; i++ ) {
1672         tokenContract.transfer(payableAddresses[i], (_amount * payableFees[i]) / 100);
1673     }
1674   }
1675 
1676   /**
1677   * @dev Allows Rampp wallet to update its own reference as well as update
1678   * the address for the Rampp-owed payment split. Cannot modify other payable slots
1679   * and since Rampp is always the first address this function is limited to the rampp payout only.
1680   * @param _newAddress updated Rampp Address
1681   */
1682   function setRamppAddress(address _newAddress) public isRampp {
1683     require(_newAddress != RAMPPADDRESS, "RAMPP: New Rampp address must be different");
1684     RAMPPADDRESS = _newAddress;
1685     payableAddresses[0] = _newAddress;
1686   }
1687 }
1688 
1689 
1690   
1691 abstract contract RamppERC721A is 
1692     Ownable,
1693     ERC721A,
1694     Withdrawable,
1695     ReentrancyGuard  {
1696     constructor(
1697         string memory tokenName,
1698         string memory tokenSymbol
1699     ) ERC721A(tokenName, tokenSymbol, 1, 800 ) {}
1700     using SafeMath for uint256;
1701     uint8 public CONTRACT_VERSION = 2;
1702     string public _baseTokenURI = "ipfs://QmVLry82RpAhJP5fbvE5Fhg6Tj8uENaYEff1o5X2ihPx1P/";
1703 
1704     bool public mintingOpen = false;
1705     bool public isRevealed = false;
1706     
1707     
1708     uint256 public MAX_WALLET_MINTS = 1;
1709     mapping(address => uint256) private addressMints;
1710 
1711     
1712     /////////////// Admin Mint Functions
1713     /**
1714     * @dev Mints a token to an address with a tokenURI.
1715     * This is owner only and allows a fee-free drop
1716     * @param _to address of the future owner of the token
1717     */
1718     function mintToAdmin(address _to) public onlyOwner {
1719         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 800");
1720         _safeMint(_to, 1);
1721     }
1722 
1723     function mintManyAdmin(address[] memory _addresses, uint256 _addressCount) public onlyOwner {
1724         for(uint i=0; i < _addressCount; i++ ) {
1725             mintToAdmin(_addresses[i]);
1726         }
1727     }
1728 
1729     
1730     /////////////// GENERIC MINT FUNCTIONS
1731     /**
1732     * @dev Mints a single token to an address.
1733     * fee may or may not be required*
1734     * @param _to address of the future owner of the token
1735     */
1736     function mintTo(address _to) public payable {
1737         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 800");
1738         require(mintingOpen == true, "Minting is not open right now!");
1739         require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1740         
1741         
1742         _safeMint(_to, 1);
1743         updateMintCount(_to, 1);
1744     }
1745 
1746     /**
1747     * @dev Mints a token to an address with a tokenURI.
1748     * fee may or may not be required*
1749     * @param _to address of the future owner of the token
1750     * @param _amount number of tokens to mint
1751     */
1752     function mintToMultiple(address _to, uint256 _amount) public payable {
1753         require(_amount >= 1, "Must mint at least 1 token");
1754         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1755         require(mintingOpen == true, "Minting is not open right now!");
1756         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1757         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 800");
1758         
1759 
1760         _safeMint(_to, _amount);
1761         updateMintCount(_to, _amount);
1762     }
1763 
1764     function openMinting() public onlyOwner {
1765         mintingOpen = true;
1766     }
1767 
1768     function stopMinting() public onlyOwner {
1769         mintingOpen = false;
1770     }
1771 
1772     
1773 
1774     
1775     /**
1776     * @dev Check if wallet over MAX_WALLET_MINTS
1777     * @param _address address in question to check if minted count exceeds max
1778     */
1779     function canMintAmount(address _address, uint256 _amount) public view returns(bool) {
1780         require(_amount >= 1, "Amount must be greater than or equal to 1");
1781         return SafeMath.add(addressMints[_address], _amount) <= MAX_WALLET_MINTS;
1782     }
1783 
1784     /**
1785     * @dev Update an address that has minted to new minted amount
1786     * @param _address address in question to check if minted count exceeds max
1787     * @param _amount the quanitiy of tokens to be minted
1788     */
1789     function updateMintCount(address _address, uint256 _amount) private {
1790         require(_amount >= 1, "Amount must be greater than or equal to 1");
1791         addressMints[_address] = SafeMath.add(addressMints[_address], _amount);
1792     }
1793     
1794     /**
1795     * @dev Update the maximum amount of tokens that can be minted by a unique wallet
1796     * @param _newWalletMax the new max of tokens a wallet can mint. Must be >= 1
1797     */
1798     function setWalletMax(uint256 _newWalletMax) public onlyOwner {
1799         require(_newWalletMax >= 1, "Max mints per wallet must be at least 1");
1800         MAX_WALLET_MINTS = _newWalletMax;
1801     }
1802     
1803 
1804     
1805     /**
1806      * @dev Allows owner to set Max mints per tx
1807      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
1808      */
1809      function setMaxMint(uint256 _newMaxMint) public onlyOwner {
1810          require(_newMaxMint >= 1, "Max mint must be at least 1");
1811          maxBatchSize = _newMaxMint;
1812      }
1813     
1814 
1815     
1816 
1817     
1818     function unveil(string memory _updatedTokenURI) public onlyOwner {
1819         require(isRevealed == false, "Tokens are already unveiled");
1820         _baseTokenURI = _updatedTokenURI;
1821         isRevealed = true;
1822     }
1823     
1824     
1825     function _baseURI() internal view virtual override returns (string memory) {
1826         return _baseTokenURI;
1827     }
1828 
1829     function baseTokenURI() public view returns (string memory) {
1830         return _baseTokenURI;
1831     }
1832 
1833     function setBaseURI(string calldata baseURI) external onlyOwner {
1834         _baseTokenURI = baseURI;
1835     }
1836 
1837     function getOwnershipData(uint256 tokenId) external view returns (TokenOwnership memory) {
1838         return ownershipOf(tokenId);
1839     }
1840 }
1841 
1842 
1843   
1844 // File: contracts/Ghosties800ByProject800Contract.sol
1845 //SPDX-License-Identifier: MIT
1846 
1847 pragma solidity ^0.8.0;
1848 
1849 contract Ghosties800ByProject800Contract is RamppERC721A {
1850     constructor() RamppERC721A("Ghosties 800 by PROJECT 800", "Ghosties"){}
1851 
1852     function contractURI() public pure returns (string memory) {
1853       return "https://us-central1-nft-rampp.cloudfunctions.net/app/9u3OVYy8BpSkeAW8r1nG/contract-metadata";
1854     }
1855 }
1856   
1857 //*********************************************************************//
1858 //*********************************************************************//  
1859 //                       Rampp v2.0.1
1860 //
1861 //         This smart contract was generated by rampp.xyz.
1862 //            Rampp allows creators like you to launch 
1863 //             large scale NFT communities without code!
1864 //
1865 //    Rampp is not responsible for the content of this contract and
1866 //        hopes it is being used in a responsible and kind way.  
1867 //       Rampp is not associated or affiliated with this project.                                                    
1868 //             Twitter: @Rampp_ ---- rampp.xyz
1869 //*********************************************************************//                                                     
1870 //*********************************************************************//