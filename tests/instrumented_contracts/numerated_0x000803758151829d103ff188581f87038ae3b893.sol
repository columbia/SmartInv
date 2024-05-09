1 /**
2  *Submitted for verification at Etherscan.io on 2022-03-08
3 */
4 
5 // SPDX-License-Identifier: MIT
6 // File: @openzeppelin/contracts/utils/Strings.sol
7 
8 
9 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
10 
11 /**
12  _____ _            _                     _   _____                 
13 |_   _| |          | |                   | | |  _  |                
14   | | | |__   ___  | |     ___  _   _  __| | | | | |_ __   ___  ___ 
15   | | | '_ \ / _ \ | |    / _ \| | | |/ _` | | | | | '_ \ / _ \/ __|
16   | | | | | |  __/ | |___| (_) | |_| | (_| | \ \_/ / | | |  __/\__ \
17   \_/ |_| |_|\___| \_____/\___/ \__,_|\__,_|  \___/|_| |_|\___||___/
18 
19 
20 7777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
21 ????????????????????????????????????????????????????????????????????????????????????????????????????
22 ????????????????????????????????????????????????????????????????????????????????????????????????????
23 ????????????????????????????????????????????????????????????????????????????????????????????????????
24 ???????????????????????????????????JY?5???JJJJ???JJJJ?????JJJJJJJJJ?????????????????????????????????
25 ???????????????????????????????????JY?5?JJ7^.     .:!JJJJ?!^:.. .:^7JJ??????????????????????????????
26 ??????????????????????????????JJ?YY??JJ5!.     ~?5Y?: !5:     :!??~. !5?????????????????????????????
27 ??????????????????????????????YJ!?5JYYG!     .5~~&@@@? ^?    J5^J@@#~ ^5????????????????????????????
28 ??????????????????????????????JYYY5Y!YY      :&BB@@@@G  7!  .&&5B@@@J  J5JJ?????????????????????????
29 ???????????????????????????JYJ?7!!??!5?.      !B&@@#P^  ^J   !B@@&#J.  J?~7JYY??????????????????????
30 ??????????????????????????YJ!!?JJ?~~!5Y~:..     :^:.    !?     .::.   :5!~~~~?5J???JJ???????????????
31 JJJJJJJJJJJJJJJJJJJJJJJ??JPJY5PGJPY~!77!!!7!!77!~^^. .::57^:  .^~!!!!!Y?~~~!~~B5?JY??YJ?JJJJJJJJJJJJ
32 JJJJJJJJJJJJJJJJJJJJJJJY5PP5YYYGJYG!~!J?~~~!J!~~~~~!??77!!!!!?J7!~~~~~!!~~!~~5B5?5^  :5JJJJJJJJJJJJJ
33 JJJJJJJJJJJJJJJJJJJJJ5P5YYYYYYYGYJPY!55G7~!~~7?7~!~~7!~~~~~~~!!!!!~~!!~~~~~^5YP5JP.   ?5JJJJJJJJJJJJ
34 JJJJJJJJJJJJJJJJJJJJJP5YYYYYYYYPPJJY5YJGJ~~^J5YGY~~~~~~~~~~~~^YY557~~~7!~!^7GJP5JP:   !5JJJJJJJJJJJJ
35 JJJJJJJJJJJJJJJJJJJJJ5PYYYYYYYY5GJJJGPJP5~~^PYJ5G~~7JY5PPPP5YYPJJYPJ?Y5P!~^!PJP5JP:   75JYYJJJJJJJJJ
36 JJJJJJJJJJJJJJY55555JYGYYYYYYYYYGJJYP5YYG!~~PJJYB5BBGP&@@@@@@@@&GYJYYJJPY!~?5J5PJP:   ?P?77Y5YJJJJJJ
37 JJJJJJJJJJJJJYG?!!7JP5GYYYYYY55YGYJ55!PJ55J5YJJP@@J..~B@@@@@@@@@@&5JJJJJ5YYYJJ5PJP~^~~Y^^!^^!J5JJJJJ
38 YYYYYYYYYYYYJ5G!!!!!7PB5YY5P5JJJGPJ55~PJJJYJJJJB@@BG#@@@@@@@@@&B#@5JJJJJJJJJJJ5P5J^..:^??  :: 5YYYYY
39 YYYYYYYYYYYYYYGJ!!!!!7#PYP57!!!!?GJJYYYJJJJJJJJ5#@@@@@@@@@&&#BB##PJJJYP#5JJJJJ5G5  .:   J^:7. 55YYYY
40 YYYYYYYYYYYYYYYPJ!!!!!Y#P?!!!!!7PBJJJJJJY#GYYJJJY5GB#&####BBBBG5YYYYJ7#@PJJJJJ5G5. .J!~~?~^. ~PYYYYY
41 YYYYYYYYYYY55555GG?!???PJ7!!7JGGYGYJJJJJJB@J!JYYYYJYYY555555YYY5Y?!^ :&@5JJJJJ5G5Y: ..     .!PYYYYYY
42 YYYYYYYYY5PJ?777?JYP!!??~!55GB#B5GPJJJJJJY&#: .:~!P??JJJY5??7~^Y?    Y@@YJJJJJ5GY5P7~^::^^!!G5YYYYYY
43 YYYYYYYY5G!!!!!!!!Y7.Y#&J ?Y!!!!7J55JJJJJJP@G.    G?    ~B. .: P&7^^Y@@#JJJJJJ5GYYP^.::::. :P5YYYYYY
44 555555555P5JJJJJ5PYY~~!!^!57!!!!!!!PYJJJJJJ#@#J!~Y@&J^:!G@G7B#P@@@@@@@@PJJJJJJY&PY55Y?!!!?5#5Y555555
45 55555555555555PB5?!!??55?5#BP5YYJJPPJJJJJJJ5@@@@@@@@@&&@@@@@@@@@@@@@@@#JJJJJJJY&@G55&@@@@@B#55555555
46 5555555555555GB?!!!!!?#BJ7PGPP&#5YPPJJJJJJJJG@&#BP5YJ?JJYP#GYJ??J5G&@@5JJJJJJJY&@@@&@@@@@@G#55555555
47 555555555555G@J!!!!!JG55G7?GY55YYY5GJJJJJJJJJGPYJ???????777YJ7??777?PGJJJYJJJJY&@@@@@@@@@@G#55555555
48 55555555555P&&G?77JPG555GP755YYYYYYGJJJJJJJJJJ5BGJ?????JJJ??????JJ?J?JPJ55JJJJY&@@@@@@@@@#GB55555555
49 55555555555B#&@@&&#P5555P&J7GYYYYYYGYJJJJJJYYJJYB#Y??JY!:~Y????5!  :Y?JGPJJJJJYBG#&@@@@@&BBP55555555
50 55555555555BB#@@@@B555555#G7YPYYYYYPPJJJJJJJ5PYJJ5GJ?P~ !:^5??J5 ^J:!Y755JJJJJYB55PGB###BGP555555555
51 PPPPPPPPPP5G&P&@@@&P5PPPPBGY7GYY5Y55GJJJJJJJJY5P55PP?P:JB#:Y??J5 5@P:5?JPJJJJJYBPPP5555555PPPPPPPPPP
52 PPPPPPPPPPPP#BG&@@@&GPG??PGG7555?!55GJJJJJJJJJJY5PPB?5!5##?5Y?B#YBBP?5J?PJJJJJJBPPPPPPPPPPPPPPPPPPPP
53 PPPPPPPPPPPPP##G#@@@@#BP77JBJ?BY775YGYJJJJJJJJJJJJ5GJJY??7Y&PP@@@@B?????PYYYYYYBPPPPPPPPPPPPPPPPPPPP
54 PPPPPPPPPPPPPPB#GG&@@@5!?YJYP7PJJJP5GPYYYYYYYYYYY5PG5?J5J?J#@@&&##G?J5J?5~~~~^~BPPPPPPPPPPPPPPPPPPPP
55 PPPPPPPPPPPPPPPPB#B&&~ 7!::7Y7??JJ!~?P~!!~~~~~^^^Y??5?YG?JJJY5P55YJJ7YYJY~~~~^7BPPPPPPPPPPPPPPPPPPPP
56 PPPPPPPPPPPPPPPPPGB&5 ?~         .J^^P^:^^^^^^^~?!!?P??5!:^Y!!7Y!~?7~5?5?!!!!!JBPPPPPPPPPPPPPPPPPPPP
57 PPPPPPPPPPPPPPPPPPPPG?Y        .:~J^:5!~~!!!777!~^~7PJ?Y@#GB5JJGY5B&@Y?5^^^^^:JGPPPPPPPPPPPPPPPPPPPP
58 GGGGGGGGGGGGGGGGGGGGGGG:       :!Y^^:JJ!!!~~~^^^^^^!J5??P#P5G##G5Y5#5?57^^^^^:PGGGGGGGGGGGGGGGGGGGGG
59 GGGGGGGGGGGGGGGGGGGGGGGG7^.  ^77P?:^:7J:^^^^^^^^^^^^~YY??5YJ??JJJY5J?Y?:^^::^7BGGGGGGGGGGGGGGGGGGGGG
60 GGGGGGGGGGGGGGGGGGGGGGGGGGP55GB7P5:::~Y^^^^^^^^^^^^^:^JP???YYYYYJ???Y7^^~!?Y5GGGGGGGGGGGGGGGGGGGGGGG
61 GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGB?Y#PY7!5^^^^^^^^^~~!!?YPBG5J??????YP#BGB##B@#GGGGGGGGGGGGGGGGGGGGGGGG
62 GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGBJ5BB@@&&BGGGBB##B##GBBGGGGGGGGB##&@@@@@@@#P&#GGGGGGGGGGGGGGGGGGGGGGGG
63 GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGBGB@@@@@@@@@@@@GB&GGGGGGGGGGG&@@@@@@@@@@&P&#GGGGGGGGGGGGGGGGGGGGGGGG
64 GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGB&@@@@@@@@@@@GB&GGGGGGGGGGG&@@@@@@@@@@#P&#GGGGGGGGGGGGGGGGGGGGGGGG
65 GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGB&@@@@@@@@@@@GB&GGGGGGGGGGG&@@@@@@@@@@#P@BGGGGGGGGGGGGGGGGGGGGGGGG
66 GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGB&@@@@@@@@@@@GB&GGGGGGGGGGG&@@@@@@@@@@#P@BGGGGGGGGGGGGGGGGGGGGGGGG
67                                                             
68 */
69 
70 
71 pragma solidity ^0.8.0;
72 
73 /**
74  * @dev String operations.
75  */
76 library Strings {
77     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
78 
79     /**
80      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
81      */
82     function toString(uint256 value) internal pure returns (string memory) {
83         // Inspired by OraclizeAPI's implementation - MIT licence
84         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
85 
86         if (value == 0) {
87             return "0";
88         }
89         uint256 temp = value;
90         uint256 digits;
91         while (temp != 0) {
92             digits++;
93             temp /= 10;
94         }
95         bytes memory buffer = new bytes(digits);
96         while (value != 0) {
97             digits -= 1;
98             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
99             value /= 10;
100         }
101         return string(buffer);
102     }
103 
104     /**
105      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
106      */
107     function toHexString(uint256 value) internal pure returns (string memory) {
108         if (value == 0) {
109             return "0x00";
110         }
111         uint256 temp = value;
112         uint256 length = 0;
113         while (temp != 0) {
114             length++;
115             temp >>= 8;
116         }
117         return toHexString(value, length);
118     }
119 
120     /**
121      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
122      */
123     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
124         bytes memory buffer = new bytes(2 * length + 2);
125         buffer[0] = "0";
126         buffer[1] = "x";
127         for (uint256 i = 2 * length + 1; i > 1; --i) {
128             buffer[i] = _HEX_SYMBOLS[value & 0xf];
129             value >>= 4;
130         }
131         require(value == 0, "Strings: hex length insufficient");
132         return string(buffer);
133     }
134 }
135 
136 // File: @openzeppelin/contracts/utils/Context.sol
137 
138 
139 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
140 
141 pragma solidity ^0.8.0;
142 
143 /**
144  * @dev Provides information about the current execution context, including the
145  * sender of the transaction and its data. While these are generally available
146  * via msg.sender and msg.data, they should not be accessed in such a direct
147  * manner, since when dealing with meta-transactions the account sending and
148  * paying for execution may not be the actual sender (as far as an application
149  * is concerned).
150  *
151  * This contract is only required for intermediate, library-like contracts.
152  */
153 abstract contract Context {
154     function _msgSender() internal view virtual returns (address) {
155         return msg.sender;
156     }
157 
158     function _msgData() internal view virtual returns (bytes calldata) {
159         return msg.data;
160     }
161 }
162 
163 // File: @openzeppelin/contracts/access/Ownable.sol
164 
165 
166 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
167 
168 pragma solidity ^0.8.0;
169 
170 
171 /**
172  * @dev Contract module which provides a basic access control mechanism, where
173  * there is an account (an owner) that can be granted exclusive access to
174  * specific functions.
175  *
176  * By default, the owner account will be the one that deploys the contract. This
177  * can later be changed with {transferOwnership}.
178  *
179  * This module is used through inheritance. It will make available the modifier
180  * `onlyOwner`, which can be applied to your functions to restrict their use to
181  * the owner.
182  */
183 abstract contract Ownable is Context {
184     address private _owner;
185 
186     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
187 
188     /**
189      * @dev Initializes the contract setting the deployer as the initial owner.
190      */
191     constructor() {
192         _transferOwnership(_msgSender());
193     }
194 
195     /**
196      * @dev Returns the address of the current owner.
197      */
198     function owner() public view virtual returns (address) {
199         return _owner;
200     }
201 
202     /**
203      * @dev Throws if called by any account other than the owner.
204      */
205     modifier onlyOwner() {
206         require(owner() == _msgSender(), "Ownable: caller is not the owner");
207         _;
208     }
209 
210     /**
211      * @dev Leaves the contract without owner. It will not be possible to call
212      * `onlyOwner` functions anymore. Can only be called by the current owner.
213      *
214      * NOTE: Renouncing ownership will leave the contract without an owner,
215      * thereby removing any functionality that is only available to the owner.
216      */
217     function renounceOwnership() public virtual onlyOwner {
218         _transferOwnership(address(0));
219     }
220 
221     /**
222      * @dev Transfers ownership of the contract to a new account (`newOwner`).
223      * Can only be called by the current owner.
224      */
225     function transferOwnership(address newOwner) public virtual onlyOwner {
226         require(newOwner != address(0), "Ownable: new owner is the zero address");
227         _transferOwnership(newOwner);
228     }
229 
230     /**
231      * @dev Transfers ownership of the contract to a new account (`newOwner`).
232      * Internal function without access restriction.
233      */
234     function _transferOwnership(address newOwner) internal virtual {
235         address oldOwner = _owner;
236         _owner = newOwner;
237         emit OwnershipTransferred(oldOwner, newOwner);
238     }
239 }
240 
241 // File: @openzeppelin/contracts/utils/Address.sol
242 
243 
244 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
245 
246 pragma solidity ^0.8.1;
247 
248 /**
249  * @dev Collection of functions related to the address type
250  */
251 library Address {
252     /**
253      * @dev Returns true if `account` is a contract.
254      *
255      * [IMPORTANT]
256      * ====
257      * It is unsafe to assume that an address for which this function returns
258      * false is an externally-owned account (EOA) and not a contract.
259      *
260      * Among others, `isContract` will return false for the following
261      * types of addresses:
262      *
263      *  - an externally-owned account
264      *  - a contract in construction
265      *  - an address where a contract will be created
266      *  - an address where a contract lived, but was destroyed
267      * ====
268      *
269      * [IMPORTANT]
270      * ====
271      * You shouldn't rely on `isContract` to protect against flash loan attacks!
272      *
273      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
274      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
275      * constructor.
276      * ====
277      */
278     function isContract(address account) internal view returns (bool) {
279         // This method relies on extcodesize/address.code.length, which returns 0
280         // for contracts in construction, since the code is only stored at the end
281         // of the constructor execution.
282 
283         return account.code.length > 0;
284     }
285 
286     /**
287      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
288      * `recipient`, forwarding all available gas and reverting on errors.
289      *
290      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
291      * of certain opcodes, possibly making contracts go over the 2300 gas limit
292      * imposed by `transfer`, making them unable to receive funds via
293      * `transfer`. {sendValue} removes this limitation.
294      *
295      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
296      *
297      * IMPORTANT: because control is transferred to `recipient`, care must be
298      * taken to not create reentrancy vulnerabilities. Consider using
299      * {ReentrancyGuard} or the
300      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
301      */
302     function sendValue(address payable recipient, uint256 amount) internal {
303         require(address(this).balance >= amount, "Address: insufficient balance");
304 
305         (bool success, ) = recipient.call{value: amount}("");
306         require(success, "Address: unable to send value, recipient may have reverted");
307     }
308 
309     /**
310      * @dev Performs a Solidity function call using a low level `call`. A
311      * plain `call` is an unsafe replacement for a function call: use this
312      * function instead.
313      *
314      * If `target` reverts with a revert reason, it is bubbled up by this
315      * function (like regular Solidity function calls).
316      *
317      * Returns the raw returned data. To convert to the expected return value,
318      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
319      *
320      * Requirements:
321      *
322      * - `target` must be a contract.
323      * - calling `target` with `data` must not revert.
324      *
325      * _Available since v3.1._
326      */
327     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
328         return functionCall(target, data, "Address: low-level call failed");
329     }
330 
331     /**
332      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
333      * `errorMessage` as a fallback revert reason when `target` reverts.
334      *
335      * _Available since v3.1._
336      */
337     function functionCall(
338         address target,
339         bytes memory data,
340         string memory errorMessage
341     ) internal returns (bytes memory) {
342         return functionCallWithValue(target, data, 0, errorMessage);
343     }
344 
345     /**
346      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
347      * but also transferring `value` wei to `target`.
348      *
349      * Requirements:
350      *
351      * - the calling contract must have an ETH balance of at least `value`.
352      * - the called Solidity function must be `payable`.
353      *
354      * _Available since v3.1._
355      */
356     function functionCallWithValue(
357         address target,
358         bytes memory data,
359         uint256 value
360     ) internal returns (bytes memory) {
361         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
362     }
363 
364     /**
365      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
366      * with `errorMessage` as a fallback revert reason when `target` reverts.
367      *
368      * _Available since v3.1._
369      */
370     function functionCallWithValue(
371         address target,
372         bytes memory data,
373         uint256 value,
374         string memory errorMessage
375     ) internal returns (bytes memory) {
376         require(address(this).balance >= value, "Address: insufficient balance for call");
377         require(isContract(target), "Address: call to non-contract");
378 
379         (bool success, bytes memory returndata) = target.call{value: value}(data);
380         return verifyCallResult(success, returndata, errorMessage);
381     }
382 
383     /**
384      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
385      * but performing a static call.
386      *
387      * _Available since v3.3._
388      */
389     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
390         return functionStaticCall(target, data, "Address: low-level static call failed");
391     }
392 
393     /**
394      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
395      * but performing a static call.
396      *
397      * _Available since v3.3._
398      */
399     function functionStaticCall(
400         address target,
401         bytes memory data,
402         string memory errorMessage
403     ) internal view returns (bytes memory) {
404         require(isContract(target), "Address: static call to non-contract");
405 
406         (bool success, bytes memory returndata) = target.staticcall(data);
407         return verifyCallResult(success, returndata, errorMessage);
408     }
409 
410     /**
411      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
412      * but performing a delegate call.
413      *
414      * _Available since v3.4._
415      */
416     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
417         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
418     }
419 
420     /**
421      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
422      * but performing a delegate call.
423      *
424      * _Available since v3.4._
425      */
426     function functionDelegateCall(
427         address target,
428         bytes memory data,
429         string memory errorMessage
430     ) internal returns (bytes memory) {
431         require(isContract(target), "Address: delegate call to non-contract");
432 
433         (bool success, bytes memory returndata) = target.delegatecall(data);
434         return verifyCallResult(success, returndata, errorMessage);
435     }
436 
437     /**
438      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
439      * revert reason using the provided one.
440      *
441      * _Available since v4.3._
442      */
443     function verifyCallResult(
444         bool success,
445         bytes memory returndata,
446         string memory errorMessage
447     ) internal pure returns (bytes memory) {
448         if (success) {
449             return returndata;
450         } else {
451             // Look for revert reason and bubble it up if present
452             if (returndata.length > 0) {
453                 // The easiest way to bubble the revert reason is using memory via assembly
454 
455                 assembly {
456                     let returndata_size := mload(returndata)
457                     revert(add(32, returndata), returndata_size)
458                 }
459             } else {
460                 revert(errorMessage);
461             }
462         }
463     }
464 }
465 
466 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
467 
468 
469 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
470 
471 pragma solidity ^0.8.0;
472 
473 /**
474  * @title ERC721 token receiver interface
475  * @dev Interface for any contract that wants to support safeTransfers
476  * from ERC721 asset contracts.
477  */
478 interface IERC721Receiver {
479     /**
480      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
481      * by `operator` from `from`, this function is called.
482      *
483      * It must return its Solidity selector to confirm the token transfer.
484      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
485      *
486      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
487      */
488     function onERC721Received(
489         address operator,
490         address from,
491         uint256 tokenId,
492         bytes calldata data
493     ) external returns (bytes4);
494 }
495 
496 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
497 
498 
499 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
500 
501 pragma solidity ^0.8.0;
502 
503 /**
504  * @dev Interface of the ERC165 standard, as defined in the
505  * https://eips.ethereum.org/EIPS/eip-165[EIP].
506  *
507  * Implementers can declare support of contract interfaces, which can then be
508  * queried by others ({ERC165Checker}).
509  *
510  * For an implementation, see {ERC165}.
511  */
512 interface IERC165 {
513     /**
514      * @dev Returns true if this contract implements the interface defined by
515      * `interfaceId`. See the corresponding
516      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
517      * to learn more about how these ids are created.
518      *
519      * This function call must use less than 30 000 gas.
520      */
521     function supportsInterface(bytes4 interfaceId) external view returns (bool);
522 }
523 
524 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
525 
526 
527 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
528 
529 pragma solidity ^0.8.0;
530 
531 
532 /**
533  * @dev Implementation of the {IERC165} interface.
534  *
535  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
536  * for the additional interface id that will be supported. For example:
537  *
538  * ```solidity
539  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
540  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
541  * }
542  * ```
543  *
544  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
545  */
546 abstract contract ERC165 is IERC165 {
547     /**
548      * @dev See {IERC165-supportsInterface}.
549      */
550     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
551         return interfaceId == type(IERC165).interfaceId;
552     }
553 }
554 
555 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
556 
557 
558 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
559 
560 pragma solidity ^0.8.0;
561 
562 
563 /**
564  * @dev Required interface of an ERC721 compliant contract.
565  */
566 interface IERC721 is IERC165 {
567     /**
568      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
569      */
570     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
571 
572     /**
573      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
574      */
575     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
576 
577     /**
578      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
579      */
580     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
581 
582     /**
583      * @dev Returns the number of tokens in ``owner``'s account.
584      */
585     function balanceOf(address owner) external view returns (uint256 balance);
586 
587     /**
588      * @dev Returns the owner of the `tokenId` token.
589      *
590      * Requirements:
591      *
592      * - `tokenId` must exist.
593      */
594     function ownerOf(uint256 tokenId) external view returns (address owner);
595 
596     /**
597      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
598      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
599      *
600      * Requirements:
601      *
602      * - `from` cannot be the zero address.
603      * - `to` cannot be the zero address.
604      * - `tokenId` token must exist and be owned by `from`.
605      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
606      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
607      *
608      * Emits a {Transfer} event.
609      */
610     function safeTransferFrom(
611         address from,
612         address to,
613         uint256 tokenId
614     ) external;
615 
616     /**
617      * @dev Transfers `tokenId` token from `from` to `to`.
618      *
619      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
620      *
621      * Requirements:
622      *
623      * - `from` cannot be the zero address.
624      * - `to` cannot be the zero address.
625      * - `tokenId` token must be owned by `from`.
626      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
627      *
628      * Emits a {Transfer} event.
629      */
630     function transferFrom(
631         address from,
632         address to,
633         uint256 tokenId
634     ) external;
635 
636     /**
637      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
638      * The approval is cleared when the token is transferred.
639      *
640      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
641      *
642      * Requirements:
643      *
644      * - The caller must own the token or be an approved operator.
645      * - `tokenId` must exist.
646      *
647      * Emits an {Approval} event.
648      */
649     function approve(address to, uint256 tokenId) external;
650 
651     /**
652      * @dev Returns the account approved for `tokenId` token.
653      *
654      * Requirements:
655      *
656      * - `tokenId` must exist.
657      */
658     function getApproved(uint256 tokenId) external view returns (address operator);
659 
660     /**
661      * @dev Approve or remove `operator` as an operator for the caller.
662      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
663      *
664      * Requirements:
665      *
666      * - The `operator` cannot be the caller.
667      *
668      * Emits an {ApprovalForAll} event.
669      */
670     function setApprovalForAll(address operator, bool _approved) external;
671 
672     /**
673      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
674      *
675      * See {setApprovalForAll}
676      */
677     function isApprovedForAll(address owner, address operator) external view returns (bool);
678 
679     /**
680      * @dev Safely transfers `tokenId` token from `from` to `to`.
681      *
682      * Requirements:
683      *
684      * - `from` cannot be the zero address.
685      * - `to` cannot be the zero address.
686      * - `tokenId` token must exist and be owned by `from`.
687      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
688      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
689      *
690      * Emits a {Transfer} event.
691      */
692     function safeTransferFrom(
693         address from,
694         address to,
695         uint256 tokenId,
696         bytes calldata data
697     ) external;
698 }
699 
700 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
701 
702 
703 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
704 
705 pragma solidity ^0.8.0;
706 
707 
708 /**
709  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
710  * @dev See https://eips.ethereum.org/EIPS/eip-721
711  */
712 interface IERC721Enumerable is IERC721 {
713     /**
714      * @dev Returns the total amount of tokens stored by the contract.
715      */
716     function totalSupply() external view returns (uint256);
717 
718     /**
719      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
720      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
721      */
722     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
723 
724     /**
725      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
726      * Use along with {totalSupply} to enumerate all tokens.
727      */
728     function tokenByIndex(uint256 index) external view returns (uint256);
729 }
730 
731 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
732 
733 
734 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
735 
736 pragma solidity ^0.8.0;
737 
738 
739 /**
740  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
741  * @dev See https://eips.ethereum.org/EIPS/eip-721
742  */
743 interface IERC721Metadata is IERC721 {
744     /**
745      * @dev Returns the token collection name.
746      */
747     function name() external view returns (string memory);
748 
749     /**
750      * @dev Returns the token collection symbol.
751      */
752     function symbol() external view returns (string memory);
753 
754     /**
755      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
756      */
757     function tokenURI(uint256 tokenId) external view returns (string memory);
758 }
759 
760 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
761 
762 
763 // Creator: Chiru Labs
764 
765 pragma solidity ^0.8.4;
766 
767 
768 
769 
770 
771 
772 
773 
774 
775 error ApprovalCallerNotOwnerNorApproved();
776 error ApprovalQueryForNonexistentToken();
777 error ApproveToCaller();
778 error ApprovalToCurrentOwner();
779 error BalanceQueryForZeroAddress();
780 error MintedQueryForZeroAddress();
781 error BurnedQueryForZeroAddress();
782 error AuxQueryForZeroAddress();
783 error MintToZeroAddress();
784 error MintZeroQuantity();
785 error OwnerIndexOutOfBounds();
786 error OwnerQueryForNonexistentToken();
787 error TokenIndexOutOfBounds();
788 error TransferCallerNotOwnerNorApproved();
789 error TransferFromIncorrectOwner();
790 error TransferToNonERC721ReceiverImplementer();
791 error TransferToZeroAddress();
792 error URIQueryForNonexistentToken();
793 
794 /**
795  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
796  * the Metadata extension. Built to optimize for lower gas during batch mints.
797  *
798  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
799  *
800  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
801  *
802  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
803  */
804 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
805     using Address for address;
806     using Strings for uint256;
807 
808     // Compiler will pack this into a single 256bit word.
809     struct TokenOwnership {
810         // The address of the owner.
811         address addr;
812         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
813         uint64 startTimestamp;
814         // Whether the token has been burned.
815         bool burned;
816     }
817 
818     // Compiler will pack this into a single 256bit word.
819     struct AddressData {
820         // Realistically, 2**64-1 is more than enough.
821         uint64 balance;
822         // Keeps track of mint count with minimal overhead for tokenomics.
823         uint64 numberMinted;
824         // Keeps track of burn count with minimal overhead for tokenomics.
825         uint64 numberBurned;
826         // For miscellaneous variable(s) pertaining to the address
827         // (e.g. number of whitelist mint slots used).
828         // If there are multiple variables, please pack them into a uint64.
829         uint64 aux;
830     }
831 
832     // The tokenId of the next token to be minted.
833     uint256 internal _currentIndex;
834 
835     // The number of tokens burned.
836     uint256 internal _burnCounter;
837 
838     // Token name
839     string private _name;
840 
841     // Token symbol
842     string private _symbol;
843 
844     // Mapping from token ID to ownership details
845     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
846     mapping(uint256 => TokenOwnership) internal _ownerships;
847 
848     // Mapping owner address to address data
849     mapping(address => AddressData) private _addressData;
850 
851     // Mapping from token ID to approved address
852     mapping(uint256 => address) private _tokenApprovals;
853 
854     // Mapping from owner to operator approvals
855     mapping(address => mapping(address => bool)) private _operatorApprovals;
856 
857     constructor(string memory name_, string memory symbol_) {
858         _name = name_;
859         _symbol = symbol_;
860         _currentIndex = _startTokenId();
861     }
862 
863     /**
864      * To change the starting tokenId, please override this function.
865      */
866     function _startTokenId() internal view virtual returns (uint256) {
867         return 0;
868     }
869 
870     /**
871      * @dev See {IERC721Enumerable-totalSupply}.
872      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
873      */
874     function totalSupply() public view returns (uint256) {
875         // Counter underflow is impossible as _burnCounter cannot be incremented
876         // more than _currentIndex - _startTokenId() times
877         unchecked {
878             return _currentIndex - _burnCounter - _startTokenId();
879         }
880     }
881 
882     /**
883      * Returns the total amount of tokens minted in the contract.
884      */
885     function _totalMinted() internal view returns (uint256) {
886         // Counter underflow is impossible as _currentIndex does not decrement,
887         // and it is initialized to _startTokenId()
888         unchecked {
889             return _currentIndex - _startTokenId();
890         }
891     }
892 
893     /**
894      * @dev See {IERC165-supportsInterface}.
895      */
896     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
897         return
898             interfaceId == type(IERC721).interfaceId ||
899             interfaceId == type(IERC721Metadata).interfaceId ||
900             super.supportsInterface(interfaceId);
901     }
902 
903     /**
904      * @dev See {IERC721-balanceOf}.
905      */
906     function balanceOf(address owner) public view override returns (uint256) {
907         if (owner == address(0)) revert BalanceQueryForZeroAddress();
908         return uint256(_addressData[owner].balance);
909     }
910 
911     /**
912      * Returns the number of tokens minted by `owner`.
913      */
914     function _numberMinted(address owner) internal view returns (uint256) {
915         if (owner == address(0)) revert MintedQueryForZeroAddress();
916         return uint256(_addressData[owner].numberMinted);
917     }
918 
919     /**
920      * Returns the number of tokens burned by or on behalf of `owner`.
921      */
922     function _numberBurned(address owner) internal view returns (uint256) {
923         if (owner == address(0)) revert BurnedQueryForZeroAddress();
924         return uint256(_addressData[owner].numberBurned);
925     }
926 
927     /**
928      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
929      */
930     function _getAux(address owner) internal view returns (uint64) {
931         if (owner == address(0)) revert AuxQueryForZeroAddress();
932         return _addressData[owner].aux;
933     }
934 
935     /**
936      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
937      * If there are multiple variables, please pack them into a uint64.
938      */
939     function _setAux(address owner, uint64 aux) internal {
940         if (owner == address(0)) revert AuxQueryForZeroAddress();
941         _addressData[owner].aux = aux;
942     }
943 
944     /**
945      * Gas spent here starts off proportional to the maximum mint batch size.
946      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
947      */
948     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
949         uint256 curr = tokenId;
950 
951         unchecked {
952             if (_startTokenId() <= curr && curr < _currentIndex) {
953                 TokenOwnership memory ownership = _ownerships[curr];
954                 if (!ownership.burned) {
955                     if (ownership.addr != address(0)) {
956                         return ownership;
957                     }
958                     // Invariant:
959                     // There will always be an ownership that has an address and is not burned
960                     // before an ownership that does not have an address and is not burned.
961                     // Hence, curr will not underflow.
962                     while (true) {
963                         curr--;
964                         ownership = _ownerships[curr];
965                         if (ownership.addr != address(0)) {
966                             return ownership;
967                         }
968                     }
969                 }
970             }
971         }
972         revert OwnerQueryForNonexistentToken();
973     }
974 
975     /**
976      * @dev See {IERC721-ownerOf}.
977      */
978     function ownerOf(uint256 tokenId) public view override returns (address) {
979         return ownershipOf(tokenId).addr;
980     }
981 
982     /**
983      * @dev See {IERC721Metadata-name}.
984      */
985     function name() public view virtual override returns (string memory) {
986         return _name;
987     }
988 
989     /**
990      * @dev See {IERC721Metadata-symbol}.
991      */
992     function symbol() public view virtual override returns (string memory) {
993         return _symbol;
994     }
995 
996     /**
997      * @dev See {IERC721Metadata-tokenURI}.
998      */
999     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1000         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1001 
1002         string memory baseURI = _baseURI();
1003         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1004     }
1005 
1006     /**
1007      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1008      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1009      * by default, can be overriden in child contracts.
1010      */
1011     function _baseURI() internal view virtual returns (string memory) {
1012         return '';
1013     }
1014 
1015     /**
1016      * @dev See {IERC721-approve}.
1017      */
1018     function approve(address to, uint256 tokenId) public override {
1019         address owner = ERC721A.ownerOf(tokenId);
1020         if (to == owner) revert ApprovalToCurrentOwner();
1021 
1022         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1023             revert ApprovalCallerNotOwnerNorApproved();
1024         }
1025 
1026         _approve(to, tokenId, owner);
1027     }
1028 
1029     /**
1030      * @dev See {IERC721-getApproved}.
1031      */
1032     function getApproved(uint256 tokenId) public view override returns (address) {
1033         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1034 
1035         return _tokenApprovals[tokenId];
1036     }
1037 
1038     /**
1039      * @dev See {IERC721-setApprovalForAll}.
1040      */
1041     function setApprovalForAll(address operator, bool approved) public override {
1042         if (operator == _msgSender()) revert ApproveToCaller();
1043 
1044         _operatorApprovals[_msgSender()][operator] = approved;
1045         emit ApprovalForAll(_msgSender(), operator, approved);
1046     }
1047 
1048     /**
1049      * @dev See {IERC721-isApprovedForAll}.
1050      */
1051     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1052         return _operatorApprovals[owner][operator];
1053     }
1054 
1055     /**
1056      * @dev See {IERC721-transferFrom}.
1057      */
1058     function transferFrom(
1059         address from,
1060         address to,
1061         uint256 tokenId
1062     ) public virtual override {
1063         _transfer(from, to, tokenId);
1064     }
1065 
1066     /**
1067      * @dev See {IERC721-safeTransferFrom}.
1068      */
1069     function safeTransferFrom(
1070         address from,
1071         address to,
1072         uint256 tokenId
1073     ) public virtual override {
1074         safeTransferFrom(from, to, tokenId, '');
1075     }
1076 
1077     /**
1078      * @dev See {IERC721-safeTransferFrom}.
1079      */
1080     function safeTransferFrom(
1081         address from,
1082         address to,
1083         uint256 tokenId,
1084         bytes memory _data
1085     ) public virtual override {
1086         _transfer(from, to, tokenId);
1087         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1088             revert TransferToNonERC721ReceiverImplementer();
1089         }
1090     }
1091 
1092     /**
1093      * @dev Returns whether `tokenId` exists.
1094      *
1095      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1096      *
1097      * Tokens start existing when they are minted (`_mint`),
1098      */
1099     function _exists(uint256 tokenId) internal view returns (bool) {
1100         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1101             !_ownerships[tokenId].burned;
1102     }
1103 
1104     function _safeMint(address to, uint256 quantity) internal {
1105         _safeMint(to, quantity, '');
1106     }
1107 
1108     /**
1109      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1110      *
1111      * Requirements:
1112      *
1113      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1114      * - `quantity` must be greater than 0.
1115      *
1116      * Emits a {Transfer} event.
1117      */
1118     function _safeMint(
1119         address to,
1120         uint256 quantity,
1121         bytes memory _data
1122     ) internal {
1123         _mint(to, quantity, _data, true);
1124     }
1125 
1126     /**
1127      * @dev Mints `quantity` tokens and transfers them to `to`.
1128      *
1129      * Requirements:
1130      *
1131      * - `to` cannot be the zero address.
1132      * - `quantity` must be greater than 0.
1133      *
1134      * Emits a {Transfer} event.
1135      */
1136     function _mint(
1137         address to,
1138         uint256 quantity,
1139         bytes memory _data,
1140         bool safe
1141     ) internal {
1142         uint256 startTokenId = _currentIndex;
1143         if (to == address(0)) revert MintToZeroAddress();
1144         if (quantity == 0) revert MintZeroQuantity();
1145 
1146         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1147 
1148         // Overflows are incredibly unrealistic.
1149         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1150         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1151         unchecked {
1152             _addressData[to].balance += uint64(quantity);
1153             _addressData[to].numberMinted += uint64(quantity);
1154 
1155             _ownerships[startTokenId].addr = to;
1156             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1157 
1158             uint256 updatedIndex = startTokenId;
1159             uint256 end = updatedIndex + quantity;
1160 
1161             if (safe && to.isContract()) {
1162                 do {
1163                     emit Transfer(address(0), to, updatedIndex);
1164                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1165                         revert TransferToNonERC721ReceiverImplementer();
1166                     }
1167                 } while (updatedIndex != end);
1168                 // Reentrancy protection
1169                 if (_currentIndex != startTokenId) revert();
1170             } else {
1171                 do {
1172                     emit Transfer(address(0), to, updatedIndex++);
1173                 } while (updatedIndex != end);
1174             }
1175             _currentIndex = updatedIndex;
1176         }
1177         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1178     }
1179 
1180     /**
1181      * @dev Transfers `tokenId` from `from` to `to`.
1182      *
1183      * Requirements:
1184      *
1185      * - `to` cannot be the zero address.
1186      * - `tokenId` token must be owned by `from`.
1187      *
1188      * Emits a {Transfer} event.
1189      */
1190     function _transfer(
1191         address from,
1192         address to,
1193         uint256 tokenId
1194     ) private {
1195         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1196 
1197         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1198             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1199             getApproved(tokenId) == _msgSender());
1200 
1201         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1202         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1203         if (to == address(0)) revert TransferToZeroAddress();
1204 
1205         _beforeTokenTransfers(from, to, tokenId, 1);
1206 
1207         // Clear approvals from the previous owner
1208         _approve(address(0), tokenId, prevOwnership.addr);
1209 
1210         // Underflow of the sender's balance is impossible because we check for
1211         // ownership above and the recipient's balance can't realistically overflow.
1212         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1213         unchecked {
1214             _addressData[from].balance -= 1;
1215             _addressData[to].balance += 1;
1216 
1217             _ownerships[tokenId].addr = to;
1218             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1219 
1220             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1221             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1222             uint256 nextTokenId = tokenId + 1;
1223             if (_ownerships[nextTokenId].addr == address(0)) {
1224                 // This will suffice for checking _exists(nextTokenId),
1225                 // as a burned slot cannot contain the zero address.
1226                 if (nextTokenId < _currentIndex) {
1227                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1228                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1229                 }
1230             }
1231         }
1232 
1233         emit Transfer(from, to, tokenId);
1234         _afterTokenTransfers(from, to, tokenId, 1);
1235     }
1236 
1237     /**
1238      * @dev Destroys `tokenId`.
1239      * The approval is cleared when the token is burned.
1240      *
1241      * Requirements:
1242      *
1243      * - `tokenId` must exist.
1244      *
1245      * Emits a {Transfer} event.
1246      */
1247     function _burn(uint256 tokenId) internal virtual {
1248         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1249 
1250         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1251 
1252         // Clear approvals from the previous owner
1253         _approve(address(0), tokenId, prevOwnership.addr);
1254 
1255         // Underflow of the sender's balance is impossible because we check for
1256         // ownership above and the recipient's balance can't realistically overflow.
1257         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1258         unchecked {
1259             _addressData[prevOwnership.addr].balance -= 1;
1260             _addressData[prevOwnership.addr].numberBurned += 1;
1261 
1262             // Keep track of who burned the token, and the timestamp of burning.
1263             _ownerships[tokenId].addr = prevOwnership.addr;
1264             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1265             _ownerships[tokenId].burned = true;
1266 
1267             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1268             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1269             uint256 nextTokenId = tokenId + 1;
1270             if (_ownerships[nextTokenId].addr == address(0)) {
1271                 // This will suffice for checking _exists(nextTokenId),
1272                 // as a burned slot cannot contain the zero address.
1273                 if (nextTokenId < _currentIndex) {
1274                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1275                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1276                 }
1277             }
1278         }
1279 
1280         emit Transfer(prevOwnership.addr, address(0), tokenId);
1281         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1282 
1283         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1284         unchecked {
1285             _burnCounter++;
1286         }
1287     }
1288 
1289     /**
1290      * @dev Approve `to` to operate on `tokenId`
1291      *
1292      * Emits a {Approval} event.
1293      */
1294     function _approve(
1295         address to,
1296         uint256 tokenId,
1297         address owner
1298     ) private {
1299         _tokenApprovals[tokenId] = to;
1300         emit Approval(owner, to, tokenId);
1301     }
1302 
1303     /**
1304      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1305      *
1306      * @param from address representing the previous owner of the given token ID
1307      * @param to target address that will receive the tokens
1308      * @param tokenId uint256 ID of the token to be transferred
1309      * @param _data bytes optional data to send along with the call
1310      * @return bool whether the call correctly returned the expected magic value
1311      */
1312     function _checkContractOnERC721Received(
1313         address from,
1314         address to,
1315         uint256 tokenId,
1316         bytes memory _data
1317     ) private returns (bool) {
1318         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1319             return retval == IERC721Receiver(to).onERC721Received.selector;
1320         } catch (bytes memory reason) {
1321             if (reason.length == 0) {
1322                 revert TransferToNonERC721ReceiverImplementer();
1323             } else {
1324                 assembly {
1325                     revert(add(32, reason), mload(reason))
1326                 }
1327             }
1328         }
1329     }
1330 
1331     /**
1332      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1333      * And also called before burning one token.
1334      *
1335      * startTokenId - the first token id to be transferred
1336      * quantity - the amount to be transferred
1337      *
1338      * Calling conditions:
1339      *
1340      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1341      * transferred to `to`.
1342      * - When `from` is zero, `tokenId` will be minted for `to`.
1343      * - When `to` is zero, `tokenId` will be burned by `from`.
1344      * - `from` and `to` are never both zero.
1345      */
1346     function _beforeTokenTransfers(
1347         address from,
1348         address to,
1349         uint256 startTokenId,
1350         uint256 quantity
1351     ) internal virtual {}
1352 
1353     /**
1354      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1355      * minting.
1356      * And also called after one token has been burned.
1357      *
1358      * startTokenId - the first token id to be transferred
1359      * quantity - the amount to be transferred
1360      *
1361      * Calling conditions:
1362      *
1363      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1364      * transferred to `to`.
1365      * - When `from` is zero, `tokenId` has been minted for `to`.
1366      * - When `to` is zero, `tokenId` has been burned by `from`.
1367      * - `from` and `to` are never both zero.
1368      */
1369     function _afterTokenTransfers(
1370         address from,
1371         address to,
1372         uint256 startTokenId,
1373         uint256 quantity
1374     ) internal virtual {}
1375 }
1376 
1377 // File: Ownable.sol
1378 
1379 
1380 
1381 pragma solidity >=0.7.0 <0.9.0;
1382 
1383 
1384 
1385 contract TheLoudOnes is ERC721A, Ownable {
1386   using Strings for uint256;
1387 
1388   string baseURI;
1389   string notRevURI;
1390   string public baseExtension = ".json";
1391   uint256 public cost = 0.01 ether;
1392   uint256 public maxSupply = 5000;
1393   uint256 public maxMintAmount = 5;
1394   uint256 public freeAmount = 1000;
1395 
1396   bool public paused = false;
1397   bool public revealed = false;
1398   mapping(address => uint256) nftPerWallet;
1399 
1400   constructor(
1401     string memory _initBaseURI,
1402     string memory _initNotRevURI
1403   ) ERC721A("The Loud Ones", "TLONES") {
1404     setBaseURI(_initBaseURI);
1405     notRevURI = _initNotRevURI;
1406   }
1407 
1408   modifier checks(uint256 _mintAmount) {
1409     require(!paused);
1410     require(_mintAmount > 0);
1411     require(totalSupply() + _mintAmount <= maxSupply, "Max supply exceeded!");
1412     require(nftPerWallet[msg.sender] < 5, "You can't mint more than 5");
1413 
1414     if(totalSupply() >= freeAmount){
1415         if(msg.sender != owner()) require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1416         nftPerWallet[msg.sender]++;
1417     }
1418     else require(totalSupply() + _mintAmount <= freeAmount, "Free NFTs amount exceeded");
1419     require(_mintAmount <= maxMintAmount, "Max mint amount exceeded");
1420     _;
1421   }
1422 
1423   function mint(uint256 _mintAmount) public payable checks(_mintAmount) {
1424       _safeMint(msg.sender, _mintAmount);
1425   }
1426 
1427   function _baseURI() internal view virtual override returns (string memory) {
1428     return baseURI;
1429   }
1430 
1431   function tokenURI(uint256 tokenId)
1432     public
1433     view
1434     virtual
1435     override
1436     returns (string memory)
1437   {
1438     require(
1439       _exists(tokenId),
1440       "ERC721Metadata: URI query for nonexistent token"
1441     );
1442 
1443     if(!revealed){
1444       return notRevURI;
1445     }
1446 
1447     string memory currentBaseURI = _baseURI();
1448     return bytes(currentBaseURI).length > 0
1449         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1450         : "";
1451   }
1452 
1453   function setCost(uint256 _newCost) public onlyOwner {
1454     cost = _newCost;
1455   }
1456 
1457   function reveal() public onlyOwner {
1458     revealed = true;
1459   }
1460 
1461   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1462     maxMintAmount = _newmaxMintAmount;
1463   }
1464 
1465   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1466     baseURI = _newBaseURI;
1467   }
1468 
1469   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1470     baseExtension = _newBaseExtension;
1471   }
1472 
1473   function pause() public onlyOwner {
1474     paused = !paused;
1475   }
1476  
1477   function withdraw() public payable onlyOwner {
1478     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1479     require(os);
1480   }
1481 }