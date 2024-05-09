1 //    ▄████████    ▄████████  ▄█    █▄     ▄████████         ▄████████    ▄████████  ▄█    █▄     ▄████████ ███▄▄▄▄      ▄████████ 
2 //   ███    ███   ███    ███ ███    ███   ███    ███        ███    ███   ███    ███ ███    ███   ███    ███ ███▀▀▀██▄   ███    ███ 
3 //   ███    ███   ███    ███ ███    ███   ███    █▀         ███    ███   ███    ███ ███    ███   ███    █▀  ███   ███   ███    █▀  
4 //  ▄███▄▄▄▄██▀   ███    ███ ███    ███  ▄███▄▄▄           ▄███▄▄▄▄██▀   ███    ███ ███    ███  ▄███▄▄▄     ███   ███   ███        
5 // ▀▀███▀▀▀▀▀   ▀███████████ ███    ███ ▀▀███▀▀▀          ▀▀███▀▀▀▀▀   ▀███████████ ███    ███ ▀▀███▀▀▀     ███   ███ ▀███████████ 
6 // ▀███████████   ███    ███ ███    ███   ███    █▄       ▀███████████   ███    ███ ███    ███   ███    █▄  ███   ███          ███ 
7 //   ███    ███   ███    ███ ███    ███   ███    ███        ███    ███   ███    ███ ███    ███   ███    ███ ███   ███    ▄█    ███ 
8 //   ███    ███   ███    █▀   ▀██████▀    ██████████        ███    ███   ███    █▀   ▀██████▀    ██████████  ▀█   █▀   ▄████████▀  
9 //   ███    ███                                             ███    ███                                                             
10 // ******************************************@@@/**************&@@@,,,,           @@@@*******************************************************************
11 // ..**..*****************/////////**********@@%@@**********@@@*.                     @@@@***********************************..........**.,**************
12 // *******************///////////////******@@%%(((@@@@****@@..     @@@@@@@@@@@@@((((      @@************************************************************/
13 // *******************////////*************@@%%%%%((((@@((    @#(((/////////////////##@@@@// %@*********************************************************/
14 // ********************************....@@..@@##%%%%%@@((    @@(((////////***********,,,,,,##@@@**********************************************************
15 // ************************************@@@@**@@%%%@@((    @@(((//////****////*******,,,,,,,,,(#@@********************************************************
16 // **************************************@@##@@%@@((((  @@%%%%%##////**///////**********,,,,,,,**##@@****************************************************
17 // **************************************@@//((@@@@@@@@@%%%%%%%((////////////*************,,,,,,,,,((@@**************************************************
18 // **************************************@@##@@ ....((@@%%%%%%(((((////////*****////********,,,,,,,,,@@@@************************************************
19 // **************************************@@,,((@@@  ..((@@%%((@@@@@@@@@@@/////**//****//**///**,,,,,,//@@@@@(********************************************
20 // ********.......**..**..***************@@((@@@@@@@  ..##@@((@@@@@@@@@@@@@@@@(/////******///**////////@@..@(*******************************........**..*
21 // **************************************@@((@@@@@@@  ..##@@((@@@%%%%//////%%@@@@@//////*********//////@@..@(********************************************
22 // **************************************@@((@@#@@@@  ..##@@(((&@@@&@,,..       ((&&@@/////////////////@@  @(********************************************
23 // **************************************@@((@@#%%@@  ..##@@(((((@@@@@@,,..       //&&@@///////////////@@//@(********************************************
24 // **************************************@@((@@#%%@@  ..##@@(((((/(@@@@@@,,..       //%%@@(((////((////@@&&@*.....,,,,..,,,,,****************************
25 // *******************,,...........,,,,,,@@((@@@@@@@  ..##@@(((((((((((((@@&&&&&&&&&&&@@((((@@&&&&&&&&&&&@@@@@@@****************************************,
26 // **********,,.........*****************@@..,,@@@  ,,##@@((((((((((((((((((((((((((((((((@@&&&&&@@@@&&#########@@@@@@@@**********************,,.........
27 // ****,,,,,,..****************************@@..,  ////%%@@((((((((((((((((((((((((((((((@@&&&&&@@&&&&&&&&&&#############@@@(*************,,,,,..*********
28 // ******************************************//&@@@@@@######((((((((((((((((((((((((((((@@&&&&&&&&&&&&&&&######################@@@@**********************
29 // *********************************************@@##########//((((((((((((((((((((((((@@&&&&&&&&&&&&&&&&&&&######################&&@@********************
30 // ,,............,,,,,,,**,,.............@@@@@@@//////########((((((((((((((((((((((((@@&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&#############&&@@...........,,,,,,,
31 // ******************************........**@@(((((////######%%%(((((((((((((((((((((@@&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&####&&&&@@****************
32 // ..............,**********,,.......********@@(((#(######%%%%##%(((((((((((((((((@@&&&&&&&&@@@@@@@@@@@@@&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&@/.......,,*****
33 // ********,,..**.........,,,,,,...************@@@((########%%%%%%%(((((((((((((@@&&&&&&@@@@&&&&&&&&&&&&&@@@@@@@@@@@@@&&&&&&&&&&&&&&&&&&&@(*,,..**.......
34 // ******,,..**********************,,,,,,,,@@((/////((&&@@@@@@#######%%%%(((((@@&&&&&&&&&&&&&@@@@@@@@////((&@@@@******///////////@@@@@@&&@(,..***********
35 // ....,,******************************,,@@((%%%%%((****((&&&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@##**%%%%%%%%%%%&&@@,,,,.................@@@(**************
36 // ************************************@@((((*******((####((%%&&&@@//@@###############%%%%%%@@@&&&&##******&&&&&@@***************************************
37 // *******************,,**,,,,,,.......,,,,@@%%%%%((((((////%%%&&&&@@@@((&&@@@@@@@@@@@@@@@@@/%&&&&&&&((((///////((@@************************************,
38 // ******,,,,,,,,********************,,..@@&&&&@@@@@@@@@******(%%&&&&@@@@  &&&%%%%%%%%%%&&  @&&&&&&&@*******#%&&&&@@**********************,,,,,,,,*******
39 // ,,,,,,,,,,************************,,@@&&&&&&&&&&&&&&&@@*****//%%%%&&@@@@  @@@@@@@@@@@  @@&@@&&%%****//(((&@@@@@..,,,,,,,,,,,,,,,,,,,,,,,,,,***********
40 // **,,..*********************,,.....@@&&&&&&&&&&&&&&&&&&&@@@@@&&////%%&&@@@@&&&..@@@@**@@@@&%%&&**((@@@@@@@@@@@@@*********************,,.,**************
41 // **......,,***********,,.........**@@@@&&&&&&&&&&&&&&&&&&&@@@@@@@@@##%%&&@@@@@@@////@@@@@@&&&**((@@@@@@@@@@@@@***********************.....,,***********
42 // ,,.......................,,,,,,,**@@@@@@&&%%%%&&&&&&&@@&&@@@@@##@@@@%%%%&&@@@@@  ,,@@@@@@@&&**##%%@@@@@@@&&@@*****************,,,,,,..................
43 // ,,,,.................,,,,,,,,,,,,,,,**@@@@%%%%&((%%&&&&@@@@@@@@@&&@@@@@@&&&@@@@  ..@@@@@@&&&%%%%@@@@@@@@&&&@@**,,,,,,,,,,,,,,,,,,,,,,,................
44 // ....................................@@@@&&&&%&&&&((&&&&@@@@@@@@@&&@@@@@@@@#&&@@@@@@@@@@@@@&&##%%@@@@@@&&&&&@@@@.......................................
45 // ********,,....,,,***************,,,,@@@@@@((&&&%%&&&&@@@@@@@@@@@&&&&@@@@..@@@@@@@@@@@@@@@@@&##&&@@@@@@@@&&&@@@@........,,,,,,,,,*********,,....,,,,***
46 // ************.......,,*************@@@@&&&&&&#((%%((@@@@@@@@@@@&&&&&&@@@@..@@@@@@@@@@@@@@@@#(@@@@@@@@@@@@@@@@@@@@@,,,,,,,*********************........,
47 // ********,,......................@@@@@@&&&&&&@@@((&&@@@@@@@@@@@@@@@&&@@@@//&,.@@@@@@@@@@@@@*.@@@@@@@@@@@@@@@@@&&@@,,,,,,,,,***************,,...........
48 // .............................,,,@@@@@@@@&&&&&&&%%&&@@@@@@@@@@@@@@@@@@@@@ .&@@@@@@@@@@@@@@@#/@@@@&&@@@@@@@@@&&&&@@@@...................................
49 // ....*******************,,,,,,,&&@@&&&&&&&&%%&&&&&@@@@@@@@&&&&&&&&@@@@@&&@@,%@,,@@@@@@@@@@/&@&&@@&&&&@@@@@&&&&&&&&@@&&.................****************
50 // ....,,***************,,,,,,,,,@@@@&&&&&&%%@@#%%@@@@@@@@@@&&&&&&&&@@@@@&&@@/&@@@@@@@@@@@@@.%@@@@@&&&&@@@@@@@&&&&&&&&@@.................,***************
51 // ........,,,,,,*******,,,,,,,,,@@&&&&&&@@@@@@@@@@@@@@@@@&&&&&&&&&&&@@@@&&@@.&@@@@@@@@@@@@@/&@@@@@&&&&@@@@@@@@@@@@@@@@@@@..................,,,,,,*******
52 
53 
54 // SPDX-License-Identifier: MIT
55 
56 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
57 
58 pragma solidity ^0.8.0;
59 
60 /**
61  * @dev Interface of the ERC165 standard, as defined in the
62  * https://eips.ethereum.org/EIPS/eip-165[EIP].
63  *
64  * Implementers can declare support of contract interfaces, which can then be
65  * queried by others ({ERC165Checker}).
66  *
67  * For an implementation, see {ERC165}.
68  */
69 interface IERC165 {
70     /**
71      * @dev Returns true if this contract implements the interface defined by
72      * `interfaceId`. See the corresponding
73      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
74      * to learn more about how these ids are created.
75      *
76      * This function call must use less than 30 000 gas.
77      */
78     function supportsInterface(bytes4 interfaceId) external view returns (bool);
79 }
80 
81 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
82 
83 pragma solidity ^0.8.0;
84 
85 
86 /**
87  * @dev Implementation of the {IERC165} interface.
88  *
89  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
90  * for the additional interface id that will be supported. For example:
91  *
92  * ```solidity
93  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
94  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
95  * }
96  * ```
97  *
98  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
99  */
100 abstract contract ERC165 is IERC165 {
101     /**
102      * @dev See {IERC165-supportsInterface}.
103      */
104     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
105         return interfaceId == type(IERC165).interfaceId;
106     }
107 }
108 
109 
110 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
111 
112 pragma solidity ^0.8.0;
113 
114 /**
115  * @dev String operations.
116  */
117 library Strings {
118     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
119 
120     /**
121      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
122      */
123     function toString(uint256 value) internal pure returns (string memory) {
124         // Inspired by OraclizeAPI's implementation - MIT licence
125         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
126 
127         if (value == 0) {
128             return "0";
129         }
130         uint256 temp = value;
131         uint256 digits;
132         while (temp != 0) {
133             digits++;
134             temp /= 10;
135         }
136         bytes memory buffer = new bytes(digits);
137         while (value != 0) {
138             digits -= 1;
139             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
140             value /= 10;
141         }
142         return string(buffer);
143     }
144 
145     /**
146      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
147      */
148     function toHexString(uint256 value) internal pure returns (string memory) {
149         if (value == 0) {
150             return "0x00";
151         }
152         uint256 temp = value;
153         uint256 length = 0;
154         while (temp != 0) {
155             length++;
156             temp >>= 8;
157         }
158         return toHexString(value, length);
159     }
160 
161     /**
162      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
163      */
164     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
165         bytes memory buffer = new bytes(2 * length + 2);
166         buffer[0] = "0";
167         buffer[1] = "x";
168         for (uint256 i = 2 * length + 1; i > 1; --i) {
169             buffer[i] = _HEX_SYMBOLS[value & 0xf];
170             value >>= 4;
171         }
172         require(value == 0, "Strings: hex length insufficient");
173         return string(buffer);
174     }
175 }
176 
177 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
178 
179 pragma solidity ^0.8.0;
180 
181 /**
182  * @dev Provides information about the current execution context, including the
183  * sender of the transaction and its data. While these are generally available
184  * via msg.sender and msg.data, they should not be accessed in such a direct
185  * manner, since when dealing with meta-transactions the account sending and
186  * paying for execution may not be the actual sender (as far as an application
187  * is concerned).
188  *
189  * This contract is only required for intermediate, library-like contracts.
190  */
191 abstract contract Context {
192     function _msgSender() internal view virtual returns (address) {
193         return msg.sender;
194     }
195 
196     function _msgData() internal view virtual returns (bytes calldata) {
197         return msg.data;
198     }
199 }
200 
201 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
202 
203 pragma solidity ^0.8.1;
204 
205 /**
206  * @dev Collection of functions related to the address type
207  */
208 library Address {
209     /**
210      * @dev Returns true if `account` is a contract.
211      *
212      * [IMPORTANT]
213      * ====
214      * It is unsafe to assume that an address for which this function returns
215      * false is an externally-owned account (EOA) and not a contract.
216      *
217      * Among others, `isContract` will return false for the following
218      * types of addresses:
219      *
220      *  - an externally-owned account
221      *  - a contract in construction
222      *  - an address where a contract will be created
223      *  - an address where a contract lived, but was destroyed
224      * ====
225      *
226      * [IMPORTANT]
227      * ====
228      * You shouldn't rely on `isContract` to protect against flash loan attacks!
229      *
230      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
231      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
232      * constructor.
233      * ====
234      */
235     function isContract(address account) internal view returns (bool) {
236         // This method relies on extcodesize/address.code.length, which returns 0
237         // for contracts in construction, since the code is only stored at the end
238         // of the constructor execution.
239 
240         return account.code.length > 0;
241     }
242 
243     /**
244      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
245      * `recipient`, forwarding all available gas and reverting on errors.
246      *
247      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
248      * of certain opcodes, possibly making contracts go over the 2300 gas limit
249      * imposed by `transfer`, making them unable to receive funds via
250      * `transfer`. {sendValue} removes this limitation.
251      *
252      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
253      *
254      * IMPORTANT: because control is transferred to `recipient`, care must be
255      * taken to not create reentrancy vulnerabilities. Consider using
256      * {ReentrancyGuard} or the
257      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
258      */
259     function sendValue(address payable recipient, uint256 amount) internal {
260         require(address(this).balance >= amount, "Address: insufficient balance");
261 
262         (bool success, ) = recipient.call{value: amount}("");
263         require(success, "Address: unable to send value, recipient may have reverted");
264     }
265 
266     /**
267      * @dev Performs a Solidity function call using a low level `call`. A
268      * plain `call` is an unsafe replacement for a function call: use this
269      * function instead.
270      *
271      * If `target` reverts with a revert reason, it is bubbled up by this
272      * function (like regular Solidity function calls).
273      *
274      * Returns the raw returned data. To convert to the expected return value,
275      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
276      *
277      * Requirements:
278      *
279      * - `target` must be a contract.
280      * - calling `target` with `data` must not revert.
281      *
282      * _Available since v3.1._
283      */
284     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
285         return functionCall(target, data, "Address: low-level call failed");
286     }
287 
288     /**
289      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
290      * `errorMessage` as a fallback revert reason when `target` reverts.
291      *
292      * _Available since v3.1._
293      */
294     function functionCall(
295         address target,
296         bytes memory data,
297         string memory errorMessage
298     ) internal returns (bytes memory) {
299         return functionCallWithValue(target, data, 0, errorMessage);
300     }
301 
302     /**
303      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
304      * but also transferring `value` wei to `target`.
305      *
306      * Requirements:
307      *
308      * - the calling contract must have an ETH balance of at least `value`.
309      * - the called Solidity function must be `payable`.
310      *
311      * _Available since v3.1._
312      */
313     function functionCallWithValue(
314         address target,
315         bytes memory data,
316         uint256 value
317     ) internal returns (bytes memory) {
318         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
319     }
320 
321     /**
322      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
323      * with `errorMessage` as a fallback revert reason when `target` reverts.
324      *
325      * _Available since v3.1._
326      */
327     function functionCallWithValue(
328         address target,
329         bytes memory data,
330         uint256 value,
331         string memory errorMessage
332     ) internal returns (bytes memory) {
333         require(address(this).balance >= value, "Address: insufficient balance for call");
334         require(isContract(target), "Address: call to non-contract");
335 
336         (bool success, bytes memory returndata) = target.call{value: value}(data);
337         return verifyCallResult(success, returndata, errorMessage);
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
342      * but performing a static call.
343      *
344      * _Available since v3.3._
345      */
346     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
347         return functionStaticCall(target, data, "Address: low-level static call failed");
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
352      * but performing a static call.
353      *
354      * _Available since v3.3._
355      */
356     function functionStaticCall(
357         address target,
358         bytes memory data,
359         string memory errorMessage
360     ) internal view returns (bytes memory) {
361         require(isContract(target), "Address: static call to non-contract");
362 
363         (bool success, bytes memory returndata) = target.staticcall(data);
364         return verifyCallResult(success, returndata, errorMessage);
365     }
366 
367     /**
368      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
369      * but performing a delegate call.
370      *
371      * _Available since v3.4._
372      */
373     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
374         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
375     }
376 
377     /**
378      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
379      * but performing a delegate call.
380      *
381      * _Available since v3.4._
382      */
383     function functionDelegateCall(
384         address target,
385         bytes memory data,
386         string memory errorMessage
387     ) internal returns (bytes memory) {
388         require(isContract(target), "Address: delegate call to non-contract");
389 
390         (bool success, bytes memory returndata) = target.delegatecall(data);
391         return verifyCallResult(success, returndata, errorMessage);
392     }
393 
394     /**
395      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
396      * revert reason using the provided one.
397      *
398      * _Available since v4.3._
399      */
400     function verifyCallResult(
401         bool success,
402         bytes memory returndata,
403         string memory errorMessage
404     ) internal pure returns (bytes memory) {
405         if (success) {
406             return returndata;
407         } else {
408             // Look for revert reason and bubble it up if present
409             if (returndata.length > 0) {
410                 // The easiest way to bubble the revert reason is using memory via assembly
411 
412                 assembly {
413                     let returndata_size := mload(returndata)
414                     revert(add(32, returndata), returndata_size)
415                 }
416             } else {
417                 revert(errorMessage);
418             }
419         }
420     }
421 }
422 
423 
424 
425 
426 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
427 
428 pragma solidity ^0.8.0;
429 
430 /**
431  * @title ERC721 token receiver interface
432  * @dev Interface for any contract that wants to support safeTransfers
433  * from ERC721 asset contracts.
434  */
435 interface IERC721Receiver {
436     /**
437      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
438      * by `operator` from `from`, this function is called.
439      *
440      * It must return its Solidity selector to confirm the token transfer.
441      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
442      *
443      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
444      */
445     function onERC721Received(
446         address operator,
447         address from,
448         uint256 tokenId,
449         bytes calldata data
450     ) external returns (bytes4);
451 }
452 
453 
454 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
455 
456 pragma solidity ^0.8.0;
457 
458 
459 /**
460  * @dev Required interface of an ERC721 compliant contract.
461  */
462 interface IERC721 is IERC165 {
463     /**
464      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
465      */
466     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
467 
468     /**
469      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
470      */
471     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
472 
473     /**
474      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
475      */
476     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
477 
478     /**
479      * @dev Returns the number of tokens in ``owner``'s account.
480      */
481     function balanceOf(address owner) external view returns (uint256 balance);
482 
483     /**
484      * @dev Returns the owner of the `tokenId` token.
485      *
486      * Requirements:
487      *
488      * - `tokenId` must exist.
489      */
490     function ownerOf(uint256 tokenId) external view returns (address owner);
491 
492     /**
493      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
494      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
495      *
496      * Requirements:
497      *
498      * - `from` cannot be the zero address.
499      * - `to` cannot be the zero address.
500      * - `tokenId` token must exist and be owned by `from`.
501      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
502      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
503      *
504      * Emits a {Transfer} event.
505      */
506     function safeTransferFrom(
507         address from,
508         address to,
509         uint256 tokenId
510     ) external;
511 
512     /**
513      * @dev Transfers `tokenId` token from `from` to `to`.
514      *
515      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
516      *
517      * Requirements:
518      *
519      * - `from` cannot be the zero address.
520      * - `to` cannot be the zero address.
521      * - `tokenId` token must be owned by `from`.
522      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
523      *
524      * Emits a {Transfer} event.
525      */
526     function transferFrom(
527         address from,
528         address to,
529         uint256 tokenId
530     ) external;
531 
532     /**
533      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
534      * The approval is cleared when the token is transferred.
535      *
536      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
537      *
538      * Requirements:
539      *
540      * - The caller must own the token or be an approved operator.
541      * - `tokenId` must exist.
542      *
543      * Emits an {Approval} event.
544      */
545     function approve(address to, uint256 tokenId) external;
546 
547     /**
548      * @dev Returns the account approved for `tokenId` token.
549      *
550      * Requirements:
551      *
552      * - `tokenId` must exist.
553      */
554     function getApproved(uint256 tokenId) external view returns (address operator);
555 
556     /**
557      * @dev Approve or remove `operator` as an operator for the caller.
558      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
559      *
560      * Requirements:
561      *
562      * - The `operator` cannot be the caller.
563      *
564      * Emits an {ApprovalForAll} event.
565      */
566     function setApprovalForAll(address operator, bool _approved) external;
567 
568     /**
569      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
570      *
571      * See {setApprovalForAll}
572      */
573     function isApprovedForAll(address owner, address operator) external view returns (bool);
574 
575     /**
576      * @dev Safely transfers `tokenId` token from `from` to `to`.
577      *
578      * Requirements:
579      *
580      * - `from` cannot be the zero address.
581      * - `to` cannot be the zero address.
582      * - `tokenId` token must exist and be owned by `from`.
583      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
584      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
585      *
586      * Emits a {Transfer} event.
587      */
588     function safeTransferFrom(
589         address from,
590         address to,
591         uint256 tokenId,
592         bytes calldata data
593     ) external;
594 }
595 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
596 
597 pragma solidity ^0.8.0;
598 
599 
600 /**
601  * @dev Contract module which provides a basic access control mechanism, where
602  * there is an account (an owner) that can be granted exclusive access to
603  * specific functions.
604  *
605  * By default, the owner account will be the one that deploys the contract. This
606  * can later be changed with {transferOwnership}.
607  *
608  * This module is used through inheritance. It will make available the modifier
609  * `onlyOwner`, which can be applied to your functions to restrict their use to
610  * the owner.
611  */
612 abstract contract Ownable is Context {
613     address private _owner;
614 
615     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
616 
617     /**
618      * @dev Initializes the contract setting the deployer as the initial owner.
619      */
620     constructor() {
621         _transferOwnership(_msgSender());
622     }
623 
624     /**
625      * @dev Returns the address of the current owner.
626      */
627     function owner() public view virtual returns (address) {
628         return _owner;
629     }
630 
631     /**
632      * @dev Throws if called by any account other than the owner.
633      */
634     modifier onlyOwner() {
635         require(owner() == _msgSender(), "Ownable: caller is not the owner");
636         _;
637     }
638 
639     /**
640      * @dev Leaves the contract without owner. It will not be possible to call
641      * `onlyOwner` functions anymore. Can only be called by the current owner.
642      *
643      * NOTE: Renouncing ownership will leave the contract without an owner,
644      * thereby removing any functionality that is only available to the owner.
645      */
646     function renounceOwnership() public virtual onlyOwner {
647         _transferOwnership(address(0));
648     }
649 
650     /**
651      * @dev Transfers ownership of the contract to a new account (`newOwner`).
652      * Can only be called by the current owner.
653      */
654     function transferOwnership(address newOwner) public virtual onlyOwner {
655         require(newOwner != address(0), "Ownable: new owner is the zero address");
656         _transferOwnership(newOwner);
657     }
658 
659     /**
660      * @dev Transfers ownership of the contract to a new account (`newOwner`).
661      * Internal function without access restriction.
662      */
663     function _transferOwnership(address newOwner) internal virtual {
664         address oldOwner = _owner;
665         _owner = newOwner;
666         emit OwnershipTransferred(oldOwner, newOwner);
667     }
668 }
669 
670 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
671 
672 pragma solidity ^0.8.0;
673 
674 
675 /**
676  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
677  * @dev See https://eips.ethereum.org/EIPS/eip-721
678  */
679 interface IERC721Metadata is IERC721 {
680     /**
681      * @dev Returns the token collection name.
682      */
683     function name() external view returns (string memory);
684 
685     /**
686      * @dev Returns the token collection symbol.
687      */
688     function symbol() external view returns (string memory);
689 
690     /**
691      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
692      */
693     function tokenURI(uint256 tokenId) external view returns (string memory);
694 }
695 
696 
697 // Creator: Chiru Labs
698 
699 pragma solidity ^0.8.4;
700 
701 error ApprovalCallerNotOwnerNorApproved();
702 error ApprovalQueryForNonexistentToken();
703 error ApproveToCaller();
704 error ApprovalToCurrentOwner();
705 error BalanceQueryForZeroAddress();
706 error MintToZeroAddress();
707 error MintZeroQuantity();
708 error OwnerQueryForNonexistentToken();
709 error TransferCallerNotOwnerNorApproved();
710 error TransferFromIncorrectOwner();
711 error TransferToNonERC721ReceiverImplementer();
712 error TransferToZeroAddress();
713 error URIQueryForNonexistentToken();
714 
715 /**
716  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
717  * the Metadata extension. Built to optimize for lower gas during batch mints.
718  *
719  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
720  *
721  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
722  *
723  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
724  */
725 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
726     using Address for address;
727     using Strings for uint256;
728 
729     // Compiler will pack this into a single 256bit word.
730     struct TokenOwnership {
731         // The address of the owner.
732         address addr;
733         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
734         uint64 startTimestamp;
735         // Whether the token has been burned.
736         bool burned;
737     }
738 
739     // Compiler will pack this into a single 256bit word.
740     struct AddressData {
741         // Realistically, 2**64-1 is more than enough.
742         uint64 balance;
743         // Keeps track of mint count with minimal overhead for tokenomics.
744         uint64 numberMinted;
745         // Keeps track of burn count with minimal overhead for tokenomics.
746         uint64 numberBurned;
747         // For miscellaneous variable(s) pertaining to the address
748         // (e.g. number of whitelist mint slots used).
749         // If there are multiple variables, please pack them into a uint64.
750         uint64 aux;
751     }
752 
753     // The tokenId of the next token to be minted.
754     uint256 internal _currentIndex;
755 
756     // The number of tokens burned.
757     uint256 internal _burnCounter;
758 
759     // Token name
760     string private _name;
761 
762     // Token symbol
763     string private _symbol;
764 
765     // Mapping from token ID to ownership details
766     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
767     mapping(uint256 => TokenOwnership) internal _ownerships;
768 
769     // Mapping owner address to address data
770     mapping(address => AddressData) private _addressData;
771 
772     // Mapping from token ID to approved address
773     mapping(uint256 => address) private _tokenApprovals;
774 
775     // Mapping from owner to operator approvals
776     mapping(address => mapping(address => bool)) private _operatorApprovals;
777 
778     constructor(string memory name_, string memory symbol_) {
779         _name = name_;
780         _symbol = symbol_;
781         _currentIndex = _startTokenId();
782     }
783 
784     /**
785      * To change the starting tokenId, please override this function.
786      */
787     function _startTokenId() internal view virtual returns (uint256) {
788         return 0;
789     }
790 
791     /**
792      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
793      */
794     function totalSupply() public view returns (uint256) {
795         // Counter underflow is impossible as _burnCounter cannot be incremented
796         // more than _currentIndex - _startTokenId() times
797         unchecked {
798             return _currentIndex - _burnCounter - _startTokenId();
799         }
800     }
801 
802     /**
803      * Returns the total amount of tokens minted in the contract.
804      */
805     function _totalMinted() internal view returns (uint256) {
806         // Counter underflow is impossible as _currentIndex does not decrement,
807         // and it is initialized to _startTokenId()
808         unchecked {
809             return _currentIndex - _startTokenId();
810         }
811     }
812 
813     /**
814      * @dev See {IERC165-supportsInterface}.
815      */
816     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
817         return
818             interfaceId == type(IERC721).interfaceId ||
819             interfaceId == type(IERC721Metadata).interfaceId ||
820             super.supportsInterface(interfaceId);
821     }
822 
823     /**
824      * @dev See {IERC721-balanceOf}.
825      */
826     function balanceOf(address owner) public view override returns (uint256) {
827         if (owner == address(0)) revert BalanceQueryForZeroAddress();
828         return uint256(_addressData[owner].balance);
829     }
830 
831     /**
832      * Returns the number of tokens minted by `owner`.
833      */
834     function _numberMinted(address owner) internal view returns (uint256) {
835         return uint256(_addressData[owner].numberMinted);
836     }
837 
838     /**
839      * Returns the number of tokens burned by or on behalf of `owner`.
840      */
841     function _numberBurned(address owner) internal view returns (uint256) {
842         return uint256(_addressData[owner].numberBurned);
843     }
844 
845     /**
846      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
847      */
848     function _getAux(address owner) internal view returns (uint64) {
849         return _addressData[owner].aux;
850     }
851 
852     /**
853      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
854      * If there are multiple variables, please pack them into a uint64.
855      */
856     function _setAux(address owner, uint64 aux) internal {
857         _addressData[owner].aux = aux;
858     }
859 
860     /**
861      * Gas spent here starts off proportional to the maximum mint batch size.
862      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
863      */
864     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
865         uint256 curr = tokenId;
866 
867         unchecked {
868             if (_startTokenId() <= curr && curr < _currentIndex) {
869                 TokenOwnership memory ownership = _ownerships[curr];
870                 if (!ownership.burned) {
871                     if (ownership.addr != address(0)) {
872                         return ownership;
873                     }
874                     // Invariant:
875                     // There will always be an ownership that has an address and is not burned
876                     // before an ownership that does not have an address and is not burned.
877                     // Hence, curr will not underflow.
878                     while (true) {
879                         curr--;
880                         ownership = _ownerships[curr];
881                         if (ownership.addr != address(0)) {
882                             return ownership;
883                         }
884                     }
885                 }
886             }
887         }
888         revert OwnerQueryForNonexistentToken();
889     }
890 
891     /**
892      * @dev See {IERC721-ownerOf}.
893      */
894     function ownerOf(uint256 tokenId) public view override returns (address) {
895         return _ownershipOf(tokenId).addr;
896     }
897 
898     /**
899      * @dev See {IERC721Metadata-name}.
900      */
901     function name() public view virtual override returns (string memory) {
902         return _name;
903     }
904 
905     /**
906      * @dev See {IERC721Metadata-symbol}.
907      */
908     function symbol() public view virtual override returns (string memory) {
909         return _symbol;
910     }
911 
912     /**
913      * @dev See {IERC721Metadata-tokenURI}.
914      */
915     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
916         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
917 
918         string memory baseURI = _baseURI();
919         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
920     }
921 
922     /**
923      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
924      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
925      * by default, can be overriden in child contracts.
926      */
927     function _baseURI() internal view virtual returns (string memory) {
928         return '';
929     }
930 
931     /**
932      * @dev See {IERC721-approve}.
933      */
934     function approve(address to, uint256 tokenId) public override {
935         address owner = ERC721A.ownerOf(tokenId);
936         if (to == owner) revert ApprovalToCurrentOwner();
937 
938         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
939             revert ApprovalCallerNotOwnerNorApproved();
940         }
941 
942         _approve(to, tokenId, owner);
943     }
944 
945     /**
946      * @dev See {IERC721-getApproved}.
947      */
948     function getApproved(uint256 tokenId) public view override returns (address) {
949         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
950 
951         return _tokenApprovals[tokenId];
952     }
953 
954     /**
955      * @dev See {IERC721-setApprovalForAll}.
956      */
957     function setApprovalForAll(address operator, bool approved) public virtual override {
958         if (operator == _msgSender()) revert ApproveToCaller();
959 
960         _operatorApprovals[_msgSender()][operator] = approved;
961         emit ApprovalForAll(_msgSender(), operator, approved);
962     }
963 
964     /**
965      * @dev See {IERC721-isApprovedForAll}.
966      */
967     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
968         return _operatorApprovals[owner][operator];
969     }
970 
971     /**
972      * @dev See {IERC721-transferFrom}.
973      */
974     function transferFrom(
975         address from,
976         address to,
977         uint256 tokenId
978     ) public virtual override {
979         _transfer(from, to, tokenId);
980     }
981 
982     /**
983      * @dev See {IERC721-safeTransferFrom}.
984      */
985     function safeTransferFrom(
986         address from,
987         address to,
988         uint256 tokenId
989     ) public virtual override {
990         safeTransferFrom(from, to, tokenId, '');
991     }
992 
993     /**
994      * @dev See {IERC721-safeTransferFrom}.
995      */
996     function safeTransferFrom(
997         address from,
998         address to,
999         uint256 tokenId,
1000         bytes memory _data
1001     ) public virtual override {
1002         _transfer(from, to, tokenId);
1003         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1004             revert TransferToNonERC721ReceiverImplementer();
1005         }
1006     }
1007 
1008     /**
1009      * @dev Returns whether `tokenId` exists.
1010      *
1011      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1012      *
1013      * Tokens start existing when they are minted (`_mint`),
1014      */
1015     function _exists(uint256 tokenId) internal view returns (bool) {
1016         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1017     }
1018 
1019     /**
1020      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1021      */
1022     function _safeMint(address to, uint256 quantity) internal {
1023         _safeMint(to, quantity, '');
1024     }
1025 
1026     /**
1027      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1028      *
1029      * Requirements:
1030      *
1031      * - If `to` refers to a smart contract, it must implement 
1032      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1033      * - `quantity` must be greater than 0.
1034      *
1035      * Emits a {Transfer} event.
1036      */
1037     function _safeMint(
1038         address to,
1039         uint256 quantity,
1040         bytes memory _data
1041     ) internal {
1042         uint256 startTokenId = _currentIndex;
1043         if (to == address(0)) revert MintToZeroAddress();
1044         if (quantity == 0) revert MintZeroQuantity();
1045 
1046         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1047 
1048         // Overflows are incredibly unrealistic.
1049         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1050         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1051         unchecked {
1052             _addressData[to].balance += uint64(quantity);
1053             _addressData[to].numberMinted += uint64(quantity);
1054 
1055             _ownerships[startTokenId].addr = to;
1056             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1057 
1058             uint256 updatedIndex = startTokenId;
1059             uint256 end = updatedIndex + quantity;
1060 
1061             if (to.isContract()) {
1062                 do {
1063                     emit Transfer(address(0), to, updatedIndex);
1064                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1065                         revert TransferToNonERC721ReceiverImplementer();
1066                     }
1067                 } while (updatedIndex != end);
1068                 // Reentrancy protection
1069                 if (_currentIndex != startTokenId) revert();
1070             } else {
1071                 do {
1072                     emit Transfer(address(0), to, updatedIndex++);
1073                 } while (updatedIndex != end);
1074             }
1075             _currentIndex = updatedIndex;
1076         }
1077         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1078     }
1079 
1080     /**
1081      * @dev Mints `quantity` tokens and transfers them to `to`.
1082      *
1083      * Requirements:
1084      *
1085      * - `to` cannot be the zero address.
1086      * - `quantity` must be greater than 0.
1087      *
1088      * Emits a {Transfer} event.
1089      */
1090     function _mint(address to, uint256 quantity) internal {
1091         uint256 startTokenId = _currentIndex;
1092         if (to == address(0)) revert MintToZeroAddress();
1093         if (quantity == 0) revert MintZeroQuantity();
1094 
1095         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1096 
1097         // Overflows are incredibly unrealistic.
1098         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1099         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1100         unchecked {
1101             _addressData[to].balance += uint64(quantity);
1102             _addressData[to].numberMinted += uint64(quantity);
1103 
1104             _ownerships[startTokenId].addr = to;
1105             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1106 
1107             uint256 updatedIndex = startTokenId;
1108             uint256 end = updatedIndex + quantity;
1109 
1110             do {
1111                 emit Transfer(address(0), to, updatedIndex++);
1112             } while (updatedIndex != end);
1113 
1114             _currentIndex = updatedIndex;
1115         }
1116         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1117     }
1118 
1119     /**
1120      * @dev Transfers `tokenId` from `from` to `to`.
1121      *
1122      * Requirements:
1123      *
1124      * - `to` cannot be the zero address.
1125      * - `tokenId` token must be owned by `from`.
1126      *
1127      * Emits a {Transfer} event.
1128      */
1129     function _transfer(
1130         address from,
1131         address to,
1132         uint256 tokenId
1133     ) private {
1134         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1135 
1136         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1137 
1138         bool isApprovedOrOwner = (_msgSender() == from ||
1139             isApprovedForAll(from, _msgSender()) ||
1140             getApproved(tokenId) == _msgSender());
1141 
1142         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1143         if (to == address(0)) revert TransferToZeroAddress();
1144 
1145         _beforeTokenTransfers(from, to, tokenId, 1);
1146 
1147         // Clear approvals from the previous owner
1148         _approve(address(0), tokenId, from);
1149 
1150         // Underflow of the sender's balance is impossible because we check for
1151         // ownership above and the recipient's balance can't realistically overflow.
1152         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1153         unchecked {
1154             _addressData[from].balance -= 1;
1155             _addressData[to].balance += 1;
1156 
1157             TokenOwnership storage currSlot = _ownerships[tokenId];
1158             currSlot.addr = to;
1159             currSlot.startTimestamp = uint64(block.timestamp);
1160 
1161             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1162             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1163             uint256 nextTokenId = tokenId + 1;
1164             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1165             if (nextSlot.addr == address(0)) {
1166                 // This will suffice for checking _exists(nextTokenId),
1167                 // as a burned slot cannot contain the zero address.
1168                 if (nextTokenId != _currentIndex) {
1169                     nextSlot.addr = from;
1170                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1171                 }
1172             }
1173         }
1174 
1175         emit Transfer(from, to, tokenId);
1176         _afterTokenTransfers(from, to, tokenId, 1);
1177     }
1178 
1179     /**
1180      * @dev Equivalent to `_burn(tokenId, false)`.
1181      */
1182     function _burn(uint256 tokenId) internal virtual {
1183         _burn(tokenId, false);
1184     }
1185 
1186     /**
1187      * @dev Destroys `tokenId`.
1188      * The approval is cleared when the token is burned.
1189      *
1190      * Requirements:
1191      *
1192      * - `tokenId` must exist.
1193      *
1194      * Emits a {Transfer} event.
1195      */
1196     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1197         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1198 
1199         address from = prevOwnership.addr;
1200 
1201         if (approvalCheck) {
1202             bool isApprovedOrOwner = (_msgSender() == from ||
1203                 isApprovedForAll(from, _msgSender()) ||
1204                 getApproved(tokenId) == _msgSender());
1205 
1206             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1207         }
1208 
1209         _beforeTokenTransfers(from, address(0), tokenId, 1);
1210 
1211         // Clear approvals from the previous owner
1212         _approve(address(0), tokenId, from);
1213 
1214         // Underflow of the sender's balance is impossible because we check for
1215         // ownership above and the recipient's balance can't realistically overflow.
1216         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1217         unchecked {
1218             AddressData storage addressData = _addressData[from];
1219             addressData.balance -= 1;
1220             addressData.numberBurned += 1;
1221 
1222             // Keep track of who burned the token, and the timestamp of burning.
1223             TokenOwnership storage currSlot = _ownerships[tokenId];
1224             currSlot.addr = from;
1225             currSlot.startTimestamp = uint64(block.timestamp);
1226             currSlot.burned = true;
1227 
1228             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1229             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1230             uint256 nextTokenId = tokenId + 1;
1231             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1232             if (nextSlot.addr == address(0)) {
1233                 // This will suffice for checking _exists(nextTokenId),
1234                 // as a burned slot cannot contain the zero address.
1235                 if (nextTokenId != _currentIndex) {
1236                     nextSlot.addr = from;
1237                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1238                 }
1239             }
1240         }
1241 
1242         emit Transfer(from, address(0), tokenId);
1243         _afterTokenTransfers(from, address(0), tokenId, 1);
1244 
1245         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1246         unchecked {
1247             _burnCounter++;
1248         }
1249     }
1250 
1251     /**
1252      * @dev Approve `to` to operate on `tokenId`
1253      *
1254      * Emits a {Approval} event.
1255      */
1256     function _approve(
1257         address to,
1258         uint256 tokenId,
1259         address owner
1260     ) private {
1261         _tokenApprovals[tokenId] = to;
1262         emit Approval(owner, to, tokenId);
1263     }
1264 
1265     /**
1266      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1267      *
1268      * @param from address representing the previous owner of the given token ID
1269      * @param to target address that will receive the tokens
1270      * @param tokenId uint256 ID of the token to be transferred
1271      * @param _data bytes optional data to send along with the call
1272      * @return bool whether the call correctly returned the expected magic value
1273      */
1274     function _checkContractOnERC721Received(
1275         address from,
1276         address to,
1277         uint256 tokenId,
1278         bytes memory _data
1279     ) private returns (bool) {
1280         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1281             return retval == IERC721Receiver(to).onERC721Received.selector;
1282         } catch (bytes memory reason) {
1283             if (reason.length == 0) {
1284                 revert TransferToNonERC721ReceiverImplementer();
1285             } else {
1286                 assembly {
1287                     revert(add(32, reason), mload(reason))
1288                 }
1289             }
1290         }
1291     }
1292 
1293     /**
1294      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1295      * And also called before burning one token.
1296      *
1297      * startTokenId - the first token id to be transferred
1298      * quantity - the amount to be transferred
1299      *
1300      * Calling conditions:
1301      *
1302      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1303      * transferred to `to`.
1304      * - When `from` is zero, `tokenId` will be minted for `to`.
1305      * - When `to` is zero, `tokenId` will be burned by `from`.
1306      * - `from` and `to` are never both zero.
1307      */
1308     function _beforeTokenTransfers(
1309         address from,
1310         address to,
1311         uint256 startTokenId,
1312         uint256 quantity
1313     ) internal virtual {}
1314 
1315     /**
1316      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1317      * minting.
1318      * And also called after one token has been burned.
1319      *
1320      * startTokenId - the first token id to be transferred
1321      * quantity - the amount to be transferred
1322      *
1323      * Calling conditions:
1324      *
1325      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1326      * transferred to `to`.
1327      * - When `from` is zero, `tokenId` has been minted for `to`.
1328      * - When `to` is zero, `tokenId` has been burned by `from`.
1329      * - `from` and `to` are never both zero.
1330      */
1331     function _afterTokenTransfers(
1332         address from,
1333         address to,
1334         uint256 startTokenId,
1335         uint256 quantity
1336     ) internal virtual {}
1337 }
1338 
1339 
1340 // Creator: Chiru Labs
1341 
1342 pragma solidity ^0.8.4;
1343 
1344 error InvalidQueryRange();
1345 
1346 /**
1347  * @title ERC721A Queryable
1348  * @dev ERC721A subclass with convenience query functions.
1349  */
1350 abstract contract ERC721AQueryable is ERC721A {
1351     /**
1352      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1353      *
1354      * If the `tokenId` is out of bounds:
1355      *   - `addr` = `address(0)`
1356      *   - `startTimestamp` = `0`
1357      *   - `burned` = `false`
1358      *
1359      * If the `tokenId` is burned:
1360      *   - `addr` = `<Address of owner before token was burned>`
1361      *   - `startTimestamp` = `<Timestamp when token was burned>`
1362      *   - `burned = `true`
1363      *
1364      * Otherwise:
1365      *   - `addr` = `<Address of owner>`
1366      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1367      *   - `burned = `false`
1368      */
1369     function explicitOwnershipOf(uint256 tokenId) public view returns (TokenOwnership memory) {
1370         TokenOwnership memory ownership;
1371         if (tokenId < _startTokenId() || tokenId >= _currentIndex) {
1372             return ownership;
1373         }
1374         ownership = _ownerships[tokenId];
1375         if (ownership.burned) {
1376             return ownership;
1377         }
1378         return _ownershipOf(tokenId);
1379     }
1380 
1381     /**
1382      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1383      * See {ERC721AQueryable-explicitOwnershipOf}
1384      */
1385     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory) {
1386         unchecked {
1387             uint256 tokenIdsLength = tokenIds.length;
1388             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1389             for (uint256 i; i != tokenIdsLength; ++i) {
1390                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1391             }
1392             return ownerships;
1393         }
1394     }
1395 
1396     /**
1397      * @dev Returns an array of token IDs owned by `owner`,
1398      * in the range [`start`, `stop`)
1399      * (i.e. `start <= tokenId < stop`).
1400      *
1401      * This function allows for tokens to be queried if the collection
1402      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1403      *
1404      * Requirements:
1405      *
1406      * - `start` < `stop`
1407      */
1408     function tokensOfOwnerIn(
1409         address owner,
1410         uint256 start,
1411         uint256 stop
1412     ) external view returns (uint256[] memory) {
1413         unchecked {
1414             if (start >= stop) revert InvalidQueryRange();
1415             uint256 tokenIdsIdx;
1416             uint256 stopLimit = _currentIndex;
1417             // Set `start = max(start, _startTokenId())`.
1418             if (start < _startTokenId()) {
1419                 start = _startTokenId();
1420             }
1421             // Set `stop = min(stop, _currentIndex)`.
1422             if (stop > stopLimit) {
1423                 stop = stopLimit;
1424             }
1425             uint256 tokenIdsMaxLength = balanceOf(owner);
1426             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1427             // to cater for cases where `balanceOf(owner)` is too big.
1428             if (start < stop) {
1429                 uint256 rangeLength = stop - start;
1430                 if (rangeLength < tokenIdsMaxLength) {
1431                     tokenIdsMaxLength = rangeLength;
1432                 }
1433             } else {
1434                 tokenIdsMaxLength = 0;
1435             }
1436             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1437             if (tokenIdsMaxLength == 0) {
1438                 return tokenIds;
1439             }
1440             // We need to call `explicitOwnershipOf(start)`,
1441             // because the slot at `start` may not be initialized.
1442             TokenOwnership memory ownership = explicitOwnershipOf(start);
1443             address currOwnershipAddr;
1444             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1445             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1446             if (!ownership.burned) {
1447                 currOwnershipAddr = ownership.addr;
1448             }
1449             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1450                 ownership = _ownerships[i];
1451                 if (ownership.burned) {
1452                     continue;
1453                 }
1454                 if (ownership.addr != address(0)) {
1455                     currOwnershipAddr = ownership.addr;
1456                 }
1457                 if (currOwnershipAddr == owner) {
1458                     tokenIds[tokenIdsIdx++] = i;
1459                 }
1460             }
1461             // Downsize the array to fit.
1462             assembly {
1463                 mstore(tokenIds, tokenIdsIdx)
1464             }
1465             return tokenIds;
1466         }
1467     }
1468 
1469     /**
1470      * @dev Returns an array of token IDs owned by `owner`.
1471      *
1472      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1473      * It is meant to be called off-chain.
1474      *
1475      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1476      * multiple smaller scans if the collection is large enough to cause
1477      * an out-of-gas error (10K pfp collections should be fine).
1478      */
1479     function tokensOfOwner(address owner) external view returns (uint256[] memory) {
1480         unchecked {
1481             uint256 tokenIdsIdx;
1482             address currOwnershipAddr;
1483             uint256 tokenIdsLength = balanceOf(owner);
1484             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1485             TokenOwnership memory ownership;
1486             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1487                 ownership = _ownerships[i];
1488                 if (ownership.burned) {
1489                     continue;
1490                 }
1491                 if (ownership.addr != address(0)) {
1492                     currOwnershipAddr = ownership.addr;
1493                 }
1494                 if (currOwnershipAddr == owner) {
1495                     tokenIds[tokenIdsIdx++] = i;
1496                 }
1497             }
1498             return tokenIds;
1499         }
1500     }
1501 }
1502 
1503 
1504 
1505 pragma solidity ^0.8.14;
1506 
1507 contract RaveRavens is ERC721AQueryable, Ownable {
1508     using Strings for uint256;
1509     
1510     uint256 public MAX_PARTY = 5555;
1511     uint256 public PLUS_ONE = 2;
1512     uint256 public MAX_GUESTS = 10;
1513     uint256 public ENTRY_TICKET = 0.0069 ether;
1514 
1515     uint256 public RAAAAAVE = 5;
1516 
1517     mapping(uint256 => uint256) public tokenTransfersCount;
1518 
1519     address RA = 0x02bB8CfAFe1666742A42A348cAd8A4a5Df838055;
1520     address VEN = 0x01eEf68380E0854b21b0cC36F4df338eD80bbc99;
1521 
1522     bool public partyOn = false;
1523 
1524     string private unRAVEaled;
1525     string private RAVEn;
1526     string private RAVING;
1527     string private RAVElation;
1528 
1529     mapping(address => uint) public guestsWasted;
1530 
1531     constructor() ERC721A("RaveRavens", "RAVE") {}
1532 
1533     function _startTokenId() internal view virtual override returns (uint256) {
1534         return 1;
1535     }
1536 
1537     function mint(uint256 _count) external payable {
1538         uint256 supply = totalSupply();
1539         uint256 ravensRaved = guestsWasted[_msgSender()];
1540 
1541         require(partyOn,  "Club is closed");
1542         require(supply + _count <= MAX_PARTY, "Too late");
1543         require(_count <= MAX_GUESTS, "Too many");
1544 
1545         if ( ravensRaved < PLUS_ONE && _count <= (PLUS_ONE - ravensRaved)  ) {
1546             require(msg.value == 0, "Nope");
1547         }
1548         else if (ravensRaved >= PLUS_ONE) {
1549             require(msg.value == ENTRY_TICKET * _count, "Nope");
1550         }
1551         else {
1552             require(msg.value == ENTRY_TICKET * ( _count + ravensRaved - PLUS_ONE), "Nope");
1553         }
1554 
1555         guestsWasted[_msgSender()] += _count;
1556         _safeMint(msg.sender, _count);
1557      
1558     }
1559 
1560     function invite(uint256 _count, address _address) external onlyOwner {
1561         uint256 supply = totalSupply();
1562         require(supply + _count <= MAX_PARTY, "Too late");
1563         _safeMint(_address, _count);
1564     }    
1565 
1566 
1567     //checks if address owns more than RAAAAAVE number of tokens
1568     function isPartyAnimal(address _wallet) public view returns (bool) {
1569         uint256 ownedByAddress = balanceOf(_wallet);
1570         return (ownedByAddress >= RAAAAAVE);
1571     }
1572 
1573     //baseURI is assigned based on the number of tokens held and transfers count
1574     function _baseURI(uint256 _tokenId) internal view virtual returns (string memory) {
1575         (bool _partyAnimal) = isPartyAnimal(ownerOf(_tokenId));
1576         uint256 transfersCount = tokenTransfersCount[_tokenId];
1577 
1578         if (transfersCount == 0) {
1579             return unRAVEaled;
1580         } else if (transfersCount < RAAAAAVE)
1581         {      
1582             if (!_partyAnimal) {
1583                 return RAVEn;
1584             } else
1585             {
1586                 return RAVING;
1587             }
1588         
1589         } else {
1590             return RAVElation;
1591         }
1592     }
1593 
1594     // check how many times the token has been transfered
1595     function transferFrom(
1596         address from,
1597         address to,
1598         uint256 tokenId
1599     ) public virtual override(ERC721A) {
1600         super.transferFrom(from, to, tokenId);
1601             unchecked {
1602                 tokenTransfersCount[tokenId]++;
1603             }
1604     }    
1605 
1606     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1607         require(_exists(_tokenId), "Nope");
1608         return string(abi.encodePacked(_baseURI(_tokenId), _tokenId.toString(),".json"));
1609     }
1610 
1611     function getPartyStarted() external onlyOwner {
1612         partyOn = !partyOn;
1613     }
1614 
1615     function setBaseURI_0(string memory baseURI) public onlyOwner {
1616         unRAVEaled = baseURI;
1617     }
1618 
1619     function setBaseURI_1(string memory baseURI) public onlyOwner {
1620         RAVEn = baseURI;
1621     }
1622 
1623     function setBaseURI_2(string memory baseURI) public onlyOwner {
1624         RAVING = baseURI;
1625     }
1626 
1627     function setBaseURI_3(string memory baseURI) public onlyOwner {
1628         RAVElation = baseURI;
1629     }
1630 
1631     function setMaxFree(uint256 _supply) public onlyOwner {
1632         PLUS_ONE = _supply;
1633     }
1634 
1635     function setENTRY_TICKET(uint256 _newENTRY_TICKET) external onlyOwner {
1636         ENTRY_TICKET = _newENTRY_TICKET;
1637     }
1638 
1639     //cap supply
1640     function callBouncer() public onlyOwner {
1641         MAX_PARTY = totalSupply();
1642     }
1643 
1644     function goHome() public payable onlyOwner {
1645         uint256 _share = address(this).balance / 100;
1646         require(payable(RA).send(_share * 50));
1647         require(payable(VEN).send(_share * 50));
1648     }
1649 }