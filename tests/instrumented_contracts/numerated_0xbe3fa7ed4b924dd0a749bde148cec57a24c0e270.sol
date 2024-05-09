1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
3 
4 /**
5 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
6 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWX0ONMWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
7 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWNKx:,oKNNWWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
8 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWMMMMWN0d:.'oKXXNWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
9 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWMWWWKxc,..:OKXNWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
10 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWNkc,'...c0XNWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
11 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWWXd;'.....:OXNWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
12 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWX0kl''''''''';lodddxxkO0KNWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
13 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWNKkdl:,''''''''''''''''',,,,;:cloxOKWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
14 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWX0koc;,,,,,,,,,;;;;,,,,''',,,,;;:ccc::::ldOXWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
15 MMMMMMMMMMMMMMMMMMMMMMMMMMWX0xoc;,,,,,,;;;;;;;;;;:::;,,,,,,,,,,;;:cllooolcloOXWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
16 MMMMMMMMMMMMMMMMWMMMMWWN0koc;;;;;;;;;;;;;;:::::::::;;,,,,,,,,,,,;;::cloodddolldONWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
17 MMMMMMMMMMMMMMMMMMMWN0dl:;;;;;;;;;;;::::::::;;;;;;;;;;;;;;;;;;;;;;;::cclooddxxdookXWWWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
18 MMMMMMMMMMMMMMMMMWXkl:;;:::;;;:::::::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:::clloddxxkxdoxKWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
19 MMMMMMMMMMMMMMMMNkl:;:;;:::::::::::::::::;;;;::::;;;:;;;;;;::::;;;;;::::cclooodxkOkdoxXWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
20 MMMMMMMMMMMMMWWKo:;;;::;;;;:;;;;;;::;;::::::::::::::::::::::::::::::::::::ccloodxxkkkddONWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
21 MMMMMMMMMMMMWNk:;::;;;;;;;;;;;;;;;;;::::ccccccccc:::::::::::::::;;;;;;;;;:::cclooddxkkkdxXWWWMMMMMMMMMMMMMMMMMMMMMMMMMMM
22 MMMMMMMMMMMWNx:::;;;;;;;;;;;;;;;::::cccccccc:cc::::::::::::;;;;;;;;;;;;;;;;;::cclloddxkkxd0NWWMMMMMMMMMMMMMMMMMMMMMMMMMM
23 MMMMMMMMMMWXx:;;;;;;;;;;;;;;;:::cccccccc:::::::::::::::;;;;;;;;;;;;;;;;;;;;;;;::cclloodxkxokXWWWMMMMMMMMMMMMMMMMMMMMMMMM
24 MMMMMMMMWWNx:;;;;;;,,;;;;;;::ccccccc::::;;:::::::;;;;;:cclloooooooollllcc::;;;;;;:::cloodxdco0NWWMMMMMMMMMMMMMMMMMMMMMMM
25 MMMMMMMMMWk:,;;;;,'.',;;::ccccccc:::;;;;;;;;;;;;;:::cokOO0000000000000OOOkxxdolc:;;;;:::ccc;;ckXNWMMMMMMMMMMMMMMMMMMMMMM
26 MMMMMMMWW0c,;;;;,,,,;:ccccccc::::::;;:::::::::cclodxk00KKKXXXXXXXXXXXXXKKKKKK00Okxdlc;;;;;,;;;;o0NWWMMMMMMMMMMMMMMMMMMMM
27 MMMMMMMWXo;;;;,,,;:ccccccc:::;;;;;;:cccccccllodxxO00KKXNNNWWWWWWWWWWWWWNNNNNNXXKKKK0Okdl:;;;;,,;ckXNWWMMMMMMMMMMMMMMMMMM
28 MMMMMMWNO;,,,,,,;:cccloooool:;,,,,,;ldxkkkkkO000KKXXNNWWWMMMMMMMMMMMMMMMMWWWWWWNNNXXXKK0Oxl:;,,,,;d0NNWMMMMMMMMMMMMMMMMM
29 MMMMMWWKo,,,,,,',codxkO000000kxdolllldO0KKXXXXXNNNWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWWWNNXXXK0Odc;,,,,ckXNWWMMMMMMMMMMMMMMM
30 MMMMWWXd;,;,,;:ldk0000KKXXXXXXXXXKKKKKKKXNNWWWWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWWNNXXK0xl;,,,;dKXNWWMMMMMMMMMMMMM
31 MMMMWXx;,;:coxO000KKXXNNNWWWWWWWWNNNNNNWWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWNNXK0kc,,,,lkKXNWWWMMMMMMMMMM
32 MMMWW0lcodkOO00KKXXNNWWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWWNXX0d;,,';dO0KXNWWWWMMMMMM
33 MMMMWX00000KKKXNNWWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWNXKd,',,,,;:ldkOKNNWWMMM
34 MMMMMWNNNNNNNWWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWNXk:',''''''',;:cdOKNNWW
35 MMMMMMMMWWWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWXd;''''''''''''',,:okKXN
36 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWXo,''''''''''''''''',;oOX
37 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWNx,'''''',coolc:;;,'''''lO
38 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWNo'..''.,lO0KXXK0OOxo:,''o
39 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWNx,...';dOKKXNNNNNNXXKklcd
40 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWO;..'lk0KXNWWWMMMWWWNNXXX
41 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWNo'.;x00XXNWMMMMMMMMMWWWW
42 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWKl,lO0KXNWMMMMMMMMMMMMMM
43 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWNKKXXNNWMMMMMMMMMMMMMMM
44 
45 */
46 pragma solidity ^0.8.0;
47 
48 /**
49  * @dev Interface of the ERC165 standard, as defined in the
50  * https://eips.ethereum.org/EIPS/eip-165[EIP].
51  *
52  * Implementers can declare support of contract interfaces, which can then be
53  * queried by others ({ERC165Checker}).
54  *
55  * For an implementation, see {ERC165}.
56  */
57 interface IERC165 {
58     /**
59      * @dev Returns true if this contract implements the interface defined by
60      * `interfaceId`. See the corresponding
61      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
62      * to learn more about how these ids are created.
63      *
64      * This function call must use less than 30 000 gas.
65      */
66     function supportsInterface(bytes4 interfaceId) external view returns (bool);
67 }
68 
69 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
70 
71 pragma solidity ^0.8.0;
72 
73 /**
74  * @dev Required interface of an ERC721 compliant contract.
75  */
76 interface IERC721 is IERC165 {
77     /**
78      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
79      */
80     event Transfer(
81         address indexed from,
82         address indexed to,
83         uint256 indexed tokenId
84     );
85 
86     /**
87      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
88      */
89     event Approval(
90         address indexed owner,
91         address indexed approved,
92         uint256 indexed tokenId
93     );
94 
95     /**
96      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
97      */
98     event ApprovalForAll(
99         address indexed owner,
100         address indexed operator,
101         bool approved
102     );
103 
104     /**
105      * @dev Returns the number of tokens in ``owner``'s account.
106      */
107     function balanceOf(address owner) external view returns (uint256 balance);
108 
109     /**
110      * @dev Returns the owner of the `tokenId` token.
111      *
112      * Requirements:
113      *
114      * - `tokenId` must exist.
115      */
116     function ownerOf(uint256 tokenId) external view returns (address owner);
117 
118     /**
119      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
120      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
121      *
122      * Requirements:
123      *
124      * - `from` cannot be the zero address.
125      * - `to` cannot be the zero address.
126      * - `tokenId` token must exist and be owned by `from`.
127      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
128      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
129      *
130      * Emits a {Transfer} event.
131      */
132     function safeTransferFrom(
133         address from,
134         address to,
135         uint256 tokenId
136     ) external;
137 
138     /**
139      * @dev Transfers `tokenId` token from `from` to `to`.
140      *
141      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
142      *
143      * Requirements:
144      *
145      * - `from` cannot be the zero address.
146      * - `to` cannot be the zero address.
147      * - `tokenId` token must be owned by `from`.
148      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
149      *
150      * Emits a {Transfer} event.
151      */
152     function transferFrom(
153         address from,
154         address to,
155         uint256 tokenId
156     ) external;
157 
158     /**
159      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
160      * The approval is cleared when the token is transferred.
161      *
162      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
163      *
164      * Requirements:
165      *
166      * - The caller must own the token or be an approved operator.
167      * - `tokenId` must exist.
168      *
169      * Emits an {Approval} event.
170      */
171     function approve(address to, uint256 tokenId) external;
172 
173     /**
174      * @dev Returns the account approved for `tokenId` token.
175      *
176      * Requirements:
177      *
178      * - `tokenId` must exist.
179      */
180     function getApproved(uint256 tokenId)
181         external
182         view
183         returns (address operator);
184 
185     /**
186      * @dev Approve or remove `operator` as an operator for the caller.
187      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
188      *
189      * Requirements:
190      *
191      * - The `operator` cannot be the caller.
192      *
193      * Emits an {ApprovalForAll} event.
194      */
195     function setApprovalForAll(address operator, bool _approved) external;
196 
197     /**
198      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
199      *
200      * See {setApprovalForAll}
201      */
202     function isApprovedForAll(address owner, address operator)
203         external
204         view
205         returns (bool);
206 
207     /**
208      * @dev Safely transfers `tokenId` token from `from` to `to`.
209      *
210      * Requirements:
211      *
212      * - `from` cannot be the zero address.
213      * - `to` cannot be the zero address.
214      * - `tokenId` token must exist and be owned by `from`.
215      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
216      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
217      *
218      * Emits a {Transfer} event.
219      */
220     function safeTransferFrom(
221         address from,
222         address to,
223         uint256 tokenId,
224         bytes calldata data
225     ) external;
226 }
227 
228 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
229 
230 pragma solidity ^0.8.0;
231 
232 /**
233  * @title ERC721 token receiver interface
234  * @dev Interface for any contract that wants to support safeTransfers
235  * from ERC721 asset contracts.
236  */
237 interface IERC721Receiver {
238     /**
239      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
240      * by `operator` from `from`, this function is called.
241      *
242      * It must return its Solidity selector to confirm the token transfer.
243      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
244      *
245      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
246      */
247     function onERC721Received(
248         address operator,
249         address from,
250         uint256 tokenId,
251         bytes calldata data
252     ) external returns (bytes4);
253 }
254 
255 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
256 
257 pragma solidity ^0.8.0;
258 
259 /**
260  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
261  * @dev See https://eips.ethereum.org/EIPS/eip-721
262  */
263 interface IERC721Metadata is IERC721 {
264     /**
265      * @dev Returns the token collection name.
266      */
267     function name() external view returns (string memory);
268 
269     /**
270      * @dev Returns the token collection symbol.
271      */
272     function symbol() external view returns (string memory);
273 
274     /**
275      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
276      */
277     function tokenURI(uint256 tokenId) external view returns (string memory);
278 }
279 
280 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
281 
282 pragma solidity ^0.8.0;
283 
284 /**
285  * @dev Implementation of the {IERC165} interface.
286  *
287  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
288  * for the additional interface id that will be supported. For example:
289  *
290  * ```solidity
291  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
292  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
293  * }
294  * ```
295  *
296  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
297  */
298 abstract contract ERC165 is IERC165 {
299     /**
300      * @dev See {IERC165-supportsInterface}.
301      */
302     function supportsInterface(bytes4 interfaceId)
303         public
304         view
305         virtual
306         override
307         returns (bool)
308     {
309         return interfaceId == type(IERC165).interfaceId;
310     }
311 }
312 
313 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
314 
315 pragma solidity ^0.8.0;
316 
317 /**
318  * @dev Collection of functions related to the address type
319  */
320 library Address {
321     /**
322      * @dev Returns true if `account` is a contract.
323      *
324      * [IMPORTANT]
325      * ====
326      * It is unsafe to assume that an address for which this function returns
327      * false is an externally-owned account (EOA) and not a contract.
328      *
329      * Among others, `isContract` will return false for the following
330      * types of addresses:
331      *
332      *  - an externally-owned account
333      *  - a contract in construction
334      *  - an address where a contract will be created
335      *  - an address where a contract lived, but was destroyed
336      * ====
337      */
338     function isContract(address account) internal view returns (bool) {
339         // This method relies on extcodesize, which returns 0 for contracts in
340         // construction, since the code is only stored at the end of the
341         // constructor execution.
342 
343         uint256 size;
344         assembly {
345             size := extcodesize(account)
346         }
347         return size > 0;
348     }
349 
350     /**
351      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
352      * `recipient`, forwarding all available gas and reverting on errors.
353      *
354      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
355      * of certain opcodes, possibly making contracts go over the 2300 gas limit
356      * imposed by `transfer`, making them unable to receive funds via
357      * `transfer`. {sendValue} removes this limitation.
358      *
359      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
360      *
361      * IMPORTANT: because control is transferred to `recipient`, care must be
362      * taken to not create reentrancy vulnerabilities. Consider using
363      * {ReentrancyGuard} or the
364      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
365      */
366     function sendValue(address payable recipient, uint256 amount) internal {
367         require(
368             address(this).balance >= amount,
369             "Address: insufficient balance"
370         );
371 
372         (bool success, ) = recipient.call{value: amount}("");
373         require(
374             success,
375             "Address: unable to send value, recipient may have reverted"
376         );
377     }
378 
379     /**
380      * @dev Performs a Solidity function call using a low level `call`. A
381      * plain `call` is an unsafe replacement for a function call: use this
382      * function instead.
383      *
384      * If `target` reverts with a revert reason, it is bubbled up by this
385      * function (like regular Solidity function calls).
386      *
387      * Returns the raw returned data. To convert to the expected return value,
388      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
389      *
390      * Requirements:
391      *
392      * - `target` must be a contract.
393      * - calling `target` with `data` must not revert.
394      *
395      * _Available since v3.1._
396      */
397     function functionCall(address target, bytes memory data)
398         internal
399         returns (bytes memory)
400     {
401         return functionCall(target, data, "Address: low-level call failed");
402     }
403 
404     /**
405      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
406      * `errorMessage` as a fallback revert reason when `target` reverts.
407      *
408      * _Available since v3.1._
409      */
410     function functionCall(
411         address target,
412         bytes memory data,
413         string memory errorMessage
414     ) internal returns (bytes memory) {
415         return functionCallWithValue(target, data, 0, errorMessage);
416     }
417 
418     /**
419      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
420      * but also transferring `value` wei to `target`.
421      *
422      * Requirements:
423      *
424      * - the calling contract must have an ETH balance of at least `value`.
425      * - the called Solidity function must be `payable`.
426      *
427      * _Available since v3.1._
428      */
429     function functionCallWithValue(
430         address target,
431         bytes memory data,
432         uint256 value
433     ) internal returns (bytes memory) {
434         return
435             functionCallWithValue(
436                 target,
437                 data,
438                 value,
439                 "Address: low-level call with value failed"
440             );
441     }
442 
443     /**
444      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
445      * with `errorMessage` as a fallback revert reason when `target` reverts.
446      *
447      * _Available since v3.1._
448      */
449     function functionCallWithValue(
450         address target,
451         bytes memory data,
452         uint256 value,
453         string memory errorMessage
454     ) internal returns (bytes memory) {
455         require(
456             address(this).balance >= value,
457             "Address: insufficient balance for call"
458         );
459         require(isContract(target), "Address: call to non-contract");
460 
461         (bool success, bytes memory returndata) = target.call{value: value}(
462             data
463         );
464         return verifyCallResult(success, returndata, errorMessage);
465     }
466 
467     /**
468      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
469      * but performing a static call.
470      *
471      * _Available since v3.3._
472      */
473     function functionStaticCall(address target, bytes memory data)
474         internal
475         view
476         returns (bytes memory)
477     {
478         return
479             functionStaticCall(
480                 target,
481                 data,
482                 "Address: low-level static call failed"
483             );
484     }
485 
486     /**
487      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
488      * but performing a static call.
489      *
490      * _Available since v3.3._
491      */
492     function functionStaticCall(
493         address target,
494         bytes memory data,
495         string memory errorMessage
496     ) internal view returns (bytes memory) {
497         require(isContract(target), "Address: static call to non-contract");
498 
499         (bool success, bytes memory returndata) = target.staticcall(data);
500         return verifyCallResult(success, returndata, errorMessage);
501     }
502 
503     /**
504      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
505      * but performing a delegate call.
506      *
507      * _Available since v3.4._
508      */
509     function functionDelegateCall(address target, bytes memory data)
510         internal
511         returns (bytes memory)
512     {
513         return
514             functionDelegateCall(
515                 target,
516                 data,
517                 "Address: low-level delegate call failed"
518             );
519     }
520 
521     /**
522      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
523      * but performing a delegate call.
524      *
525      * _Available since v3.4._
526      */
527     function functionDelegateCall(
528         address target,
529         bytes memory data,
530         string memory errorMessage
531     ) internal returns (bytes memory) {
532         require(isContract(target), "Address: delegate call to non-contract");
533 
534         (bool success, bytes memory returndata) = target.delegatecall(data);
535         return verifyCallResult(success, returndata, errorMessage);
536     }
537 
538     /**
539      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
540      * revert reason using the provided one.
541      *
542      * _Available since v4.3._
543      */
544     function verifyCallResult(
545         bool success,
546         bytes memory returndata,
547         string memory errorMessage
548     ) internal pure returns (bytes memory) {
549         if (success) {
550             return returndata;
551         } else {
552             // Look for revert reason and bubble it up if present
553             if (returndata.length > 0) {
554                 // The easiest way to bubble the revert reason is using memory via assembly
555 
556                 assembly {
557                     let returndata_size := mload(returndata)
558                     revert(add(32, returndata), returndata_size)
559                 }
560             } else {
561                 revert(errorMessage);
562             }
563         }
564     }
565 }
566 
567 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
568 
569 pragma solidity ^0.8.0;
570 
571 /**
572  * @dev Provides information about the current execution context, including the
573  * sender of the transaction and its data. While these are generally available
574  * via msg.sender and msg.data, they should not be accessed in such a direct
575  * manner, since when dealing with meta-transactions the account sending and
576  * paying for execution may not be the actual sender (as far as an application
577  * is concerned).
578  *
579  * This contract is only required for intermediate, library-like contracts.
580  */
581 abstract contract Context {
582     function _msgSender() internal view virtual returns (address) {
583         return msg.sender;
584     }
585 
586     function _msgData() internal view virtual returns (bytes calldata) {
587         return msg.data;
588     }
589 }
590 
591 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
592 
593 pragma solidity ^0.8.0;
594 
595 /**
596  * @dev String operations.
597  */
598 library Strings {
599     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
600 
601     /**
602      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
603      */
604     function toString(uint256 value) internal pure returns (string memory) {
605         // Inspired by OraclizeAPI's implementation - MIT licence
606         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
607 
608         if (value == 0) {
609             return "0";
610         }
611         uint256 temp = value;
612         uint256 digits;
613         while (temp != 0) {
614             digits++;
615             temp /= 10;
616         }
617         bytes memory buffer = new bytes(digits);
618         while (value != 0) {
619             digits -= 1;
620             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
621             value /= 10;
622         }
623         return string(buffer);
624     }
625 
626     /**
627      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
628      */
629     function toHexString(uint256 value) internal pure returns (string memory) {
630         if (value == 0) {
631             return "0x00";
632         }
633         uint256 temp = value;
634         uint256 length = 0;
635         while (temp != 0) {
636             length++;
637             temp >>= 8;
638         }
639         return toHexString(value, length);
640     }
641 
642     /**
643      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
644      */
645     function toHexString(uint256 value, uint256 length)
646         internal
647         pure
648         returns (string memory)
649     {
650         bytes memory buffer = new bytes(2 * length + 2);
651         buffer[0] = "0";
652         buffer[1] = "x";
653         for (uint256 i = 2 * length + 1; i > 1; --i) {
654             buffer[i] = _HEX_SYMBOLS[value & 0xf];
655             value >>= 4;
656         }
657         require(value == 0, "Strings: hex length insufficient");
658         return string(buffer);
659     }
660 }
661 
662 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
663 
664 pragma solidity ^0.8.0;
665 
666 /**
667  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
668  * @dev See https://eips.ethereum.org/EIPS/eip-721
669  */
670 interface IERC721Enumerable is IERC721 {
671     /**
672      * @dev Returns the total amount of tokens stored by the contract.
673      */
674     function totalSupply() external view returns (uint256);
675 
676     /**
677      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
678      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
679      */
680     function tokenOfOwnerByIndex(address owner, uint256 index)
681         external
682         view
683         returns (uint256 tokenId);
684 
685     /**
686      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
687      * Use along with {totalSupply} to enumerate all tokens.
688      */
689     function tokenByIndex(uint256 index) external view returns (uint256);
690 }
691 
692 pragma solidity ^0.8.0;
693 
694 /**
695  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
696  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
697  *
698  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
699  *
700  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
701  *
702  * Does not support burning tokens to address(0).
703  */
704 contract ERC721A is
705   Context,
706   ERC165,
707   IERC721,
708   IERC721Metadata,
709   IERC721Enumerable
710 {
711   using Address for address;
712   using Strings for uint256;
713 
714   struct TokenOwnership {
715     address addr;
716     uint64 startTimestamp;
717   }
718 
719   struct AddressData {
720     uint128 balance;
721     uint128 numberMinted;
722   }
723 
724   uint256 private currentIndex = 0;
725 
726   uint256 internal immutable collectionSize;
727   uint256 internal immutable maxBatchSize;
728 
729   // Token name
730   string private _name;
731 
732   // Token symbol
733   string private _symbol;
734 
735   // Mapping from token ID to ownership details
736   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
737   mapping(uint256 => TokenOwnership) private _ownerships;
738 
739   // Mapping owner address to address data
740   mapping(address => AddressData) private _addressData;
741 
742   // Mapping from token ID to approved address
743   mapping(uint256 => address) private _tokenApprovals;
744 
745   // Mapping from owner to operator approvals
746   mapping(address => mapping(address => bool)) private _operatorApprovals;
747 
748   /**
749    * @dev
750    * `maxBatchSize` refers to how much a minter can mint at a time.
751    * `collectionSize_` refers to how many tokens are in the collection.
752    */
753   constructor(
754     string memory name_,
755     string memory symbol_,
756     uint256 maxBatchSize_,
757     uint256 collectionSize_
758   ) {
759     require(
760       collectionSize_ > 0,
761       "ERC721A: collection must have a nonzero supply"
762     );
763     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
764     _name = name_;
765     _symbol = symbol_;
766     maxBatchSize = maxBatchSize_;
767     collectionSize = collectionSize_;
768   }
769 
770   /**
771    * @dev See {IERC721Enumerable-totalSupply}.
772    */
773   function totalSupply() public view override returns (uint256) {
774     return currentIndex;
775   }
776 
777   /**
778    * @dev See {IERC721Enumerable-tokenByIndex}.
779    */
780   function tokenByIndex(uint256 index) public view override returns (uint256) {
781     require(index < totalSupply(), "ERC721A: global index out of bounds");
782     return index;
783   }
784 
785   /**
786    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
787    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
788    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
789    */
790   function tokenOfOwnerByIndex(address owner, uint256 index)
791     public
792     view
793     override
794     returns (uint256)
795   {
796     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
797     uint256 numMintedSoFar = totalSupply();
798     uint256 tokenIdsIdx = 0;
799     address currOwnershipAddr = address(0);
800     for (uint256 i = 0; i < numMintedSoFar; i++) {
801       TokenOwnership memory ownership = _ownerships[i];
802       if (ownership.addr != address(0)) {
803         currOwnershipAddr = ownership.addr;
804       }
805       if (currOwnershipAddr == owner) {
806         if (tokenIdsIdx == index) {
807           return i;
808         }
809         tokenIdsIdx++;
810       }
811     }
812     revert("ERC721A: unable to get token of owner by index");
813   }
814 
815   /**
816    * @dev See {IERC165-supportsInterface}.
817    */
818   function supportsInterface(bytes4 interfaceId)
819     public
820     view
821     virtual
822     override(ERC165, IERC165)
823     returns (bool)
824   {
825     return
826       interfaceId == type(IERC721).interfaceId ||
827       interfaceId == type(IERC721Metadata).interfaceId ||
828       interfaceId == type(IERC721Enumerable).interfaceId ||
829       super.supportsInterface(interfaceId);
830   }
831 
832   /**
833    * @dev See {IERC721-balanceOf}.
834    */
835   function balanceOf(address owner) public view override returns (uint256) {
836     require(owner != address(0), "ERC721A: balance query for the zero address");
837     return uint256(_addressData[owner].balance);
838   }
839 
840   function _numberMinted(address owner) internal view returns (uint256) {
841     require(
842       owner != address(0),
843       "ERC721A: number minted query for the zero address"
844     );
845     return uint256(_addressData[owner].numberMinted);
846   }
847 
848   function ownershipOf(uint256 tokenId)
849     internal
850     view
851     returns (TokenOwnership memory)
852   {
853     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
854 
855     uint256 lowestTokenToCheck;
856     if (tokenId >= maxBatchSize) {
857       lowestTokenToCheck = tokenId - maxBatchSize + 1;
858     }
859 
860     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
861       TokenOwnership memory ownership = _ownerships[curr];
862       if (ownership.addr != address(0)) {
863         return ownership;
864       }
865     }
866 
867     revert("ERC721A: unable to determine the owner of token");
868   }
869 
870   /**
871    * @dev See {IERC721-ownerOf}.
872    */
873   function ownerOf(uint256 tokenId) public view override returns (address) {
874     return ownershipOf(tokenId).addr;
875   }
876 
877   /**
878    * @dev See {IERC721Metadata-name}.
879    */
880   function name() public view virtual override returns (string memory) {
881     return _name;
882   }
883 
884   /**
885    * @dev See {IERC721Metadata-symbol}.
886    */
887   function symbol() public view virtual override returns (string memory) {
888     return _symbol;
889   }
890 
891   /**
892    * @dev See {IERC721Metadata-tokenURI}.
893    */
894   function tokenURI(uint256 tokenId)
895     public
896     view
897     virtual
898     override
899     returns (string memory)
900   {
901     require(
902       _exists(tokenId),
903       "ERC721Metadata: URI query for nonexistent token"
904     );
905 
906     string memory baseURI = _baseURI();
907     return
908       bytes(baseURI).length > 0
909         ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json"))
910         : "";
911   }
912 
913   /**
914    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
915    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
916    * by default, can be overriden in child contracts.
917    */
918   function _baseURI() internal view virtual returns (string memory) {
919     return "";
920   }
921 
922   /**
923    * @dev See {IERC721-approve}.
924    */
925   function approve(address to, uint256 tokenId) public override {
926     address owner = ERC721A.ownerOf(tokenId);
927     require(to != owner, "ERC721A: approval to current owner");
928 
929     require(
930       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
931       "ERC721A: approve caller is not owner nor approved for all"
932     );
933 
934     _approve(to, tokenId, owner);
935   }
936 
937   /**
938    * @dev See {IERC721-getApproved}.
939    */
940   function getApproved(uint256 tokenId) public view override returns (address) {
941     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
942 
943     return _tokenApprovals[tokenId];
944   }
945 
946   /**
947    * @dev See {IERC721-setApprovalForAll}.
948    */
949   function setApprovalForAll(address operator, bool approved) public override {
950     require(operator != _msgSender(), "ERC721A: approve to caller");
951 
952     _operatorApprovals[_msgSender()][operator] = approved;
953     emit ApprovalForAll(_msgSender(), operator, approved);
954   }
955 
956   /**
957    * @dev See {IERC721-isApprovedForAll}.
958    */
959   function isApprovedForAll(address owner, address operator)
960     public
961     view
962     virtual
963     override
964     returns (bool)
965   {
966     return _operatorApprovals[owner][operator];
967   }
968 
969   /**
970    * @dev See {IERC721-transferFrom}.
971    */
972   function transferFrom(
973     address from,
974     address to,
975     uint256 tokenId
976   ) public override {
977     _transfer(from, to, tokenId);
978   }
979 
980   /**
981    * @dev See {IERC721-safeTransferFrom}.
982    */
983   function safeTransferFrom(
984     address from,
985     address to,
986     uint256 tokenId
987   ) public override {
988     safeTransferFrom(from, to, tokenId, "");
989   }
990 
991   /**
992    * @dev See {IERC721-safeTransferFrom}.
993    */
994   function safeTransferFrom(
995     address from,
996     address to,
997     uint256 tokenId,
998     bytes memory _data
999   ) public override {
1000     _transfer(from, to, tokenId);
1001     require(
1002       _checkOnERC721Received(from, to, tokenId, _data),
1003       "ERC721A: transfer to non ERC721Receiver implementer"
1004     );
1005   }
1006 
1007   /**
1008    * @dev Returns whether `tokenId` exists.
1009    *
1010    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1011    *
1012    * Tokens start existing when they are minted (`_mint`),
1013    */
1014   function _exists(uint256 tokenId) internal view returns (bool) {
1015     return tokenId < currentIndex;
1016   }
1017 
1018   function _safeMint(address to, uint256 quantity) internal {
1019     _safeMint(to, quantity, "");
1020   }
1021 
1022   /**
1023    * @dev Mints `quantity` tokens and transfers them to `to`.
1024    *
1025    * Requirements:
1026    *
1027    * - there must be `quantity` tokens remaining unminted in the total collection.
1028    * - `to` cannot be the zero address.
1029    * - `quantity` cannot be larger than the max batch size.
1030    *
1031    * Emits a {Transfer} event.
1032    */
1033   function _safeMint(
1034     address to,
1035     uint256 quantity,
1036     bytes memory _data
1037   ) internal {
1038     uint256 startTokenId = currentIndex;
1039     require(to != address(0), "ERC721A: mint to the zero address");
1040     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1041     require(!_exists(startTokenId), "ERC721A: token already minted");
1042     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1043 
1044     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1045 
1046     AddressData memory addressData = _addressData[to];
1047     _addressData[to] = AddressData(
1048       addressData.balance + uint128(quantity),
1049       addressData.numberMinted + uint128(quantity)
1050     );
1051     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1052 
1053     uint256 updatedIndex = startTokenId;
1054 
1055     for (uint256 i = 0; i < quantity; i++) {
1056       emit Transfer(address(0), to, updatedIndex);
1057       require(
1058         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1059         "ERC721A: transfer to non ERC721Receiver implementer"
1060       );
1061       updatedIndex++;
1062     }
1063 
1064     currentIndex = updatedIndex;
1065     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1066   }
1067 
1068   /**
1069    * @dev Transfers `tokenId` from `from` to `to`.
1070    *
1071    * Requirements:
1072    *
1073    * - `to` cannot be the zero address.
1074    * - `tokenId` token must be owned by `from`.
1075    *
1076    * Emits a {Transfer} event.
1077    */
1078   function _transfer(
1079     address from,
1080     address to,
1081     uint256 tokenId
1082   ) private {
1083     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1084 
1085     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1086       getApproved(tokenId) == _msgSender() ||
1087       isApprovedForAll(prevOwnership.addr, _msgSender()));
1088 
1089     require(
1090       isApprovedOrOwner,
1091       "ERC721A: transfer caller is not owner nor approved"
1092     );
1093 
1094     require(
1095       prevOwnership.addr == from,
1096       "ERC721A: transfer from incorrect owner"
1097     );
1098     require(to != address(0), "ERC721A: transfer to the zero address");
1099 
1100     _beforeTokenTransfers(from, to, tokenId, 1);
1101 
1102     // Clear approvals from the previous owner
1103     _approve(address(0), tokenId, prevOwnership.addr);
1104 
1105     _addressData[from].balance -= 1;
1106     _addressData[to].balance += 1;
1107     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1108 
1109     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1110     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1111     uint256 nextTokenId = tokenId + 1;
1112     if (_ownerships[nextTokenId].addr == address(0)) {
1113       if (_exists(nextTokenId)) {
1114         _ownerships[nextTokenId] = TokenOwnership(
1115           prevOwnership.addr,
1116           prevOwnership.startTimestamp
1117         );
1118       }
1119     }
1120 
1121     emit Transfer(from, to, tokenId);
1122     _afterTokenTransfers(from, to, tokenId, 1);
1123   }
1124 
1125   /**
1126    * @dev Approve `to` to operate on `tokenId`
1127    *
1128    * Emits a {Approval} event.
1129    */
1130   function _approve(
1131     address to,
1132     uint256 tokenId,
1133     address owner
1134   ) private {
1135     _tokenApprovals[tokenId] = to;
1136     emit Approval(owner, to, tokenId);
1137   }
1138 
1139   uint256 public nextOwnerToExplicitlySet = 0;
1140 
1141   /**
1142    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1143    */
1144   function _setOwnersExplicit(uint256 quantity) internal {
1145     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1146     require(quantity > 0, "quantity must be nonzero");
1147     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1148     if (endIndex > collectionSize - 1) {
1149       endIndex = collectionSize - 1;
1150     }
1151     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1152     require(_exists(endIndex), "not enough minted yet for this cleanup");
1153     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1154       if (_ownerships[i].addr == address(0)) {
1155         TokenOwnership memory ownership = ownershipOf(i);
1156         _ownerships[i] = TokenOwnership(
1157           ownership.addr,
1158           ownership.startTimestamp
1159         );
1160       }
1161     }
1162     nextOwnerToExplicitlySet = endIndex + 1;
1163   }
1164 
1165   /**
1166    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1167    * The call is not executed if the target address is not a contract.
1168    *
1169    * @param from address representing the previous owner of the given token ID
1170    * @param to target address that will receive the tokens
1171    * @param tokenId uint256 ID of the token to be transferred
1172    * @param _data bytes optional data to send along with the call
1173    * @return bool whether the call correctly returned the expected magic value
1174    */
1175   function _checkOnERC721Received(
1176     address from,
1177     address to,
1178     uint256 tokenId,
1179     bytes memory _data
1180   ) private returns (bool) {
1181     if (to.isContract()) {
1182       try
1183         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1184       returns (bytes4 retval) {
1185         return retval == IERC721Receiver(to).onERC721Received.selector;
1186       } catch (bytes memory reason) {
1187         if (reason.length == 0) {
1188           revert("ERC721A: transfer to non ERC721Receiver implementer");
1189         } else {
1190           assembly {
1191             revert(add(32, reason), mload(reason))
1192           }
1193         }
1194       }
1195     } else {
1196       return true;
1197     }
1198   }
1199 
1200   /**
1201    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1202    *
1203    * startTokenId - the first token id to be transferred
1204    * quantity - the amount to be transferred
1205    *
1206    * Calling conditions:
1207    *
1208    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1209    * transferred to `to`.
1210    * - When `from` is zero, `tokenId` will be minted for `to`.
1211    */
1212   function _beforeTokenTransfers(
1213     address from,
1214     address to,
1215     uint256 startTokenId,
1216     uint256 quantity
1217   ) internal virtual {}
1218 
1219   /**
1220    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1221    * minting.
1222    *
1223    * startTokenId - the first token id to be transferred
1224    * quantity - the amount to be transferred
1225    *
1226    * Calling conditions:
1227    *
1228    * - when `from` and `to` are both non-zero.
1229    * - `from` and `to` are never both zero.
1230    */
1231   function _afterTokenTransfers(
1232     address from,
1233     address to,
1234     uint256 startTokenId,
1235     uint256 quantity
1236   ) internal virtual {}
1237 }
1238 
1239 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1240 
1241 pragma solidity ^0.8.0;
1242 
1243 /**
1244  * @dev Contract module which provides a basic access control mechanism, where
1245  * there is an account (an owner) that can be granted exclusive access to
1246  * specific functions.
1247  *
1248  * By default, the owner account will be the one that deploys the contract. This
1249  * can later be changed with {transferOwnership}.
1250  *
1251  * This module is used through inheritance. It will make available the modifier
1252  * `onlyOwner`, which can be applied to your functions to restrict their use to
1253  * the owner.
1254  */
1255 abstract contract Ownable is Context {
1256     address private _owner;
1257 
1258     event OwnershipTransferred(
1259         address indexed previousOwner,
1260         address indexed newOwner
1261     );
1262 
1263     /**
1264      * @dev Initializes the contract setting the deployer as the initial owner.
1265      */
1266     constructor() {
1267         _transferOwnership(_msgSender());
1268     }
1269 
1270     /**
1271      * @dev Returns the address of the current owner.
1272      */
1273     function owner() public view virtual returns (address) {
1274         return _owner;
1275     }
1276 
1277     /**
1278      * @dev Throws if called by any account other than the owner.
1279      */
1280     modifier onlyOwner() {
1281         require(owner() == _msgSender(), "You are not the owner");
1282         _;
1283     }
1284 
1285     /**
1286      * @dev Leaves the contract without owner. It will not be possible to call
1287      * `onlyOwner` functions anymore. Can only be called by the current owner.
1288      *
1289      * NOTE: Renouncing ownership will leave the contract without an owner,
1290      * thereby removing any functionality that is only available to the owner.
1291      */
1292     function renounceOwnership() public virtual onlyOwner {
1293         _transferOwnership(address(0));
1294     }
1295 
1296     /**
1297      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1298      * Can only be called by the current owner.
1299      */
1300     function transferOwnership(address newOwner) public virtual onlyOwner {
1301         require(
1302             newOwner != address(0),
1303             "Ownable: new owner is the zero address"
1304         );
1305         _transferOwnership(newOwner);
1306     }
1307 
1308     
1309     function _transferOwnership(address newOwner) internal virtual {
1310         address oldOwner = _owner;
1311         _owner = newOwner;
1312         emit OwnershipTransferred(oldOwner, newOwner);
1313     }
1314 }
1315 
1316 pragma solidity ^0.8.7;
1317 
1318 contract DiscombobulatedDolphins is ERC721A, Ownable {
1319     uint256 public NFT_PRICE = 0.003 ether;
1320     uint256 public MAX_SUPPLY = 3333;
1321     uint256 public MAX_MINTS = 9;
1322     string public baseURI = "";
1323     string public baseExtension = ".json";
1324      bool public paused = true;   
1325     
1326     constructor() ERC721A("Discombobulated Dolphins", "EEEE", MAX_MINTS, MAX_SUPPLY) { 
1327         
1328     }
1329     
1330 
1331     function MinteeeEEEe(uint256 numTokens) public payable {
1332         require(!paused, "Paused");
1333         require(numTokens > 0 && numTokens <= MAX_MINTS);
1334         require(totalSupply() + numTokens <= MAX_SUPPLY);
1335         require(msg.value >= numTokens * NFT_PRICE, "Invalid funds provided");
1336         
1337         _safeMint(msg.sender, numTokens);
1338     }
1339     function pause(bool _state) public onlyOwner {
1340         paused = _state;
1341     }
1342     function setBaseURI(string memory newBaseURI) public onlyOwner {
1343         baseURI = newBaseURI;
1344     }
1345     function tokenURI(uint256 _tokenId)
1346         public
1347         view
1348         override
1349         returns (string memory)
1350     {
1351         require(_exists(_tokenId), "That token doesn't exist");
1352         return
1353             bytes(baseURI).length > 0
1354                 ? string(
1355                     abi.encodePacked(
1356                         baseURI,
1357                         Strings.toString(_tokenId),
1358                         baseExtension
1359                     )
1360                 )
1361                 : "";
1362     }
1363 
1364 
1365     function setPrice(uint256 newPrice) public onlyOwner {
1366         NFT_PRICE = newPrice;
1367     }
1368 
1369     function _baseURI() internal view virtual override returns (string memory) {
1370         return baseURI;
1371     }
1372 
1373     function withdraw() public onlyOwner {
1374         require(payable(msg.sender).send(address(this).balance));
1375     }
1376 }