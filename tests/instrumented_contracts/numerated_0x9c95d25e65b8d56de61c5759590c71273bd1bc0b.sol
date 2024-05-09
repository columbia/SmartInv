1 // SPDX-License-Identifier: MIT
2 
3 //MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
4 //MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
5 //MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
6 //MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
7 //MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWX00KNWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
8 //MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNKk;..'.'l0WMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
9 //MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNl...d0KOc..OMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
10 //MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM0' .dMMMMX: cNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
11 //MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMO. .xMMMMNc cNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
12 //MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMO. .xMMMMNc cNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
13 //MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMO. .xMMMMNc cNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
14 //MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMO' .xMMMMNc cNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
15 //MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWNNWO' .xMMMMNc cNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
16 //MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWXKKXWW0o;'',,. .xMMMMNc cNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
17 //MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNx;'''.,;..cxxo,  .xMMMMNc cNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
18 //MMMMMMMMMMMMMMMMMMMMMMMMMMXklccld:.'d00k: .dWMMMK, .xMMMMNc cNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
19 //MMMMMMMMMMMMMMMMMMMMMMMMWk'.,cc;. .kMWMMK,.kMMMMN: .xMMMMNc cNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
20 //MMMMMMMMMMMMMMMMMMMMMMMMO..oNMMWx..OMMMMX;.kMMMMN: .xMMMMNc cNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
21 //MMMMMMMMMMMMMMMMMMMMMMMMk..OMMMMK,.OMMMMX;.kMMMMN: .xMMMMNc cNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
22 //MMMMMMMMMMMMMMMMMMMMMMMMk..OMMMMK;.OMMMMX;.kMMMMN: .xMMMMNc cNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
23 //MMMMMMMMMMMMMMMMMMMMMMMMk..OMMMMK,.kMMMMX;.kMMMMN: .xMMMMNc cNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
24 //MMMMMMMMMMMMMMMMMMMMMMMMk..OMMMMK,.OMMMMX;.kMMMMX: .xMMMMNc cNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
25 //MMMMMMMMMMMMMMMMMMMMMMMMx..kWMMM0'.xWMMM0,.dWMMMK, .kMMMMNc :NMMMWXK0kdocc::cld0NMMMMMMMMMMMMMMMMMMM
26 //MMMMMMMMMMMMMMMMMMMMMMMMx. .lxko,..'lxkd,...cxkd,..lNMMMMWd..coc:,'.'',:cllll:'.;OWMMMMMMMMMMMMMMMMM
27 //MMMMMMMMMMMMMMMMMMMMMMMMx..:c;;:o0Kxc;;:o0Kxc:;:lOXNNXK0KNNkc;;cldkOKXWMMMMMMWXl..OMMMMMMMMMMMMMMMMM
28 //MMMMMMMMMMMMMMMMMMMMMMMMx..OWWWMMMMMMWWMMMMMMWNKxlc:;;;;c0MMMMWMMMMMMMMMMMMWNKOl..kMMMMMMMMMMMMMMMMM
29 //MMMMMMMMMMMMMMMMMMMMMMMMk..OMMMMMMMMMMMMMMMMXx;',coxOKXNNWMMMMMMMMMMMMWXOdl;'..':kWMMMMMMMMMMMMMMMMM
30 //MMMMMMMMMMMMMMMMMMMMMMMMk..OMMMMMMMMMMMMMMNd''lONMMMMMMMMMMMMMMMMMWXkl;..':lxOKNWMMMMMMMMMMMMMMMMMMM
31 //MMMMMMMMMMMMMMMMMMMMMMMMk..OMMMMMMMMMMMMMWx;lKWMMMMMMMMMMMMMMMMMNOc..,lx0NWMMMMMMMMMMMMMMMMMMMMMMMMM
32 //MMMMMMMMMMMMMMMMMMMMMMMM0'.dWMMMMMMMMMMMMMWNWMMMMMMMMMMMMMMMMMWO;..l0NMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
33 //MMMMMMMMMMMMMMMMMMMMMMMMNl ;KMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXl..oXMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
34 //MMMMMMMMMMMMMMMMMMMMMMMMM0, lNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNx'.;0WMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
35 //MMMMMMMMMMMMMMMMMMMMMMMMMWO'.:KWMMMMMMMMMMMMMMMMMMMMMMMMMNx,.'xNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
36 //MMMMMMMMMMMMMMMMMMMMMMMMMMMKc..l0NMMMMMMMMMMMMMMMMMMMMNOo'.,dXMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
37 //MMMMMMMMMMMMMMMMMMMMMMMMMMMMNOc..,lx0XNWMMMMMMMWNXKOdc'.'ckNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
38 //MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWXxl;'.',;:ccccc:;,'..';okXMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
39 //MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWX0kxollcccclodkO0NWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
40 //MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
41 //MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
42 //MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
43 //MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
44 //MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
45 //MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
46 
47 
48 
49 // File: @openzeppelin/contracts/utils/Counters.sol
50 
51 
52 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
53 
54 pragma solidity ^0.8.0;
55 
56 /**
57  * @title Counters
58  * @author Matt Condon (@shrugs)
59  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
60  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
61  *
62  * Include with `using Counters for Counters.Counter;`
63  */
64 library Counters {
65     struct Counter {
66         // This variable should never be directly accessed by users of the library: interactions must be restricted to
67         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
68         // this feature: see https://github.com/ethereum/solidity/issues/4637
69         uint256 _value; // default: 0
70     }
71 
72     function current(Counter storage counter) internal view returns (uint256) {
73         return counter._value;
74     }
75 
76     function increment(Counter storage counter) internal {
77         unchecked {
78             counter._value += 1;
79         }
80     }
81 
82     function decrement(Counter storage counter) internal {
83         uint256 value = counter._value;
84         require(value > 0, "Counter: decrement overflow");
85         unchecked {
86             counter._value = value - 1;
87         }
88     }
89 
90     function reset(Counter storage counter) internal {
91         counter._value = 0;
92     }
93 }
94 
95 // File: @openzeppelin/contracts/utils/Strings.sol
96 
97 
98 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
99 
100 pragma solidity ^0.8.0;
101 
102 /**
103  * @dev String operations.
104  */
105 library Strings {
106     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
107 
108     /**
109      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
110      */
111     function toString(uint256 value) internal pure returns (string memory) {
112         // Inspired by OraclizeAPI's implementation - MIT licence
113         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
114 
115         if (value == 0) {
116             return "0";
117         }
118         uint256 temp = value;
119         uint256 digits;
120         while (temp != 0) {
121             digits++;
122             temp /= 10;
123         }
124         bytes memory buffer = new bytes(digits);
125         while (value != 0) {
126             digits -= 1;
127             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
128             value /= 10;
129         }
130         return string(buffer);
131     }
132 
133     /**
134      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
135      */
136     function toHexString(uint256 value) internal pure returns (string memory) {
137         if (value == 0) {
138             return "0x00";
139         }
140         uint256 temp = value;
141         uint256 length = 0;
142         while (temp != 0) {
143             length++;
144             temp >>= 8;
145         }
146         return toHexString(value, length);
147     }
148 
149     /**
150      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
151      */
152     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
153         bytes memory buffer = new bytes(2 * length + 2);
154         buffer[0] = "0";
155         buffer[1] = "x";
156         for (uint256 i = 2 * length + 1; i > 1; --i) {
157             buffer[i] = _HEX_SYMBOLS[value & 0xf];
158             value >>= 4;
159         }
160         require(value == 0, "Strings: hex length insufficient");
161         return string(buffer);
162     }
163 }
164 
165 // File: @openzeppelin/contracts/utils/Context.sol
166 
167 
168 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
169 
170 pragma solidity ^0.8.0;
171 
172 /**
173  * @dev Provides information about the current execution context, including the
174  * sender of the transaction and its data. While these are generally available
175  * via msg.sender and msg.data, they should not be accessed in such a direct
176  * manner, since when dealing with meta-transactions the account sending and
177  * paying for execution may not be the actual sender (as far as an application
178  * is concerned).
179  *
180  * This contract is only required for intermediate, library-like contracts.
181  */
182 abstract contract Context {
183     function _msgSender() internal view virtual returns (address) {
184         return msg.sender;
185     }
186 
187     function _msgData() internal view virtual returns (bytes calldata) {
188         return msg.data;
189     }
190 }
191 
192 // File: @openzeppelin/contracts/access/Ownable.sol
193 
194 
195 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
196 
197 pragma solidity ^0.8.0;
198 
199 
200 /**
201  * @dev Contract module which provides a basic access control mechanism, where
202  * there is an account (an owner) that can be granted exclusive access to
203  * specific functions.
204  *
205  * By default, the owner account will be the one that deploys the contract. This
206  * can later be changed with {transferOwnership}.
207  *
208  * This module is used through inheritance. It will make available the modifier
209  * `onlyOwner`, which can be applied to your functions to restrict their use to
210  * the owner.
211  */
212 abstract contract Ownable is Context {
213     address private _owner;
214 
215     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
216 
217     /**
218      * @dev Initializes the contract setting the deployer as the initial owner.
219      */
220     constructor() {
221         _transferOwnership(_msgSender());
222     }
223 
224     /**
225      * @dev Returns the address of the current owner.
226      */
227     function owner() public view virtual returns (address) {
228         return _owner;
229     }
230 
231     /**
232      * @dev Throws if called by any account other than the owner.
233      */
234     modifier onlyOwner() {
235         require(owner() == _msgSender(), "Ownable: caller is not the owner");
236         _;
237     }
238 
239     /**
240      * @dev Leaves the contract without owner. It will not be possible to call
241      * `onlyOwner` functions anymore. Can only be called by the current owner.
242      *
243      * NOTE: Renouncing ownership will leave the contract without an owner,
244      * thereby removing any functionality that is only available to the owner.
245      */
246     function renounceOwnership() public virtual onlyOwner {
247         _transferOwnership(address(0));
248     }
249 
250     /**
251      * @dev Transfers ownership of the contract to a new account (`newOwner`).
252      * Can only be called by the current owner.
253      */
254     function transferOwnership(address newOwner) public virtual onlyOwner {
255         require(newOwner != address(0), "Ownable: new owner is the zero address");
256         _transferOwnership(newOwner);
257     }
258 
259     /**
260      * @dev Transfers ownership of the contract to a new account (`newOwner`).
261      * Internal function without access restriction.
262      */
263     function _transferOwnership(address newOwner) internal virtual {
264         address oldOwner = _owner;
265         _owner = newOwner;
266         emit OwnershipTransferred(oldOwner, newOwner);
267     }
268 }
269 
270 // File: @openzeppelin/contracts/utils/Address.sol
271 
272 
273 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
274 
275 pragma solidity ^0.8.1;
276 
277 /**
278  * @dev Collection of functions related to the address type
279  */
280 library Address {
281     /**
282      * @dev Returns true if `account` is a contract.
283      *
284      * [IMPORTANT]
285      * ====
286      * It is unsafe to assume that an address for which this function returns
287      * false is an externally-owned account (EOA) and not a contract.
288      *
289      * Among others, `isContract` will return false for the following
290      * types of addresses:
291      *
292      *  - an externally-owned account
293      *  - a contract in construction
294      *  - an address where a contract will be created
295      *  - an address where a contract lived, but was destroyed
296      * ====
297      *
298      * [IMPORTANT]
299      * ====
300      * You shouldn't rely on `isContract` to protect against flash loan attacks!
301      *
302      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
303      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
304      * constructor.
305      * ====
306      */
307     function isContract(address account) internal view returns (bool) {
308         // This method relies on extcodesize/address.code.length, which returns 0
309         // for contracts in construction, since the code is only stored at the end
310         // of the constructor execution.
311 
312         return account.code.length > 0;
313     }
314 
315     /**
316      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
317      * `recipient`, forwarding all available gas and reverting on errors.
318      *
319      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
320      * of certain opcodes, possibly making contracts go over the 2300 gas limit
321      * imposed by `transfer`, making them unable to receive funds via
322      * `transfer`. {sendValue} removes this limitation.
323      *
324      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
325      *
326      * IMPORTANT: because control is transferred to `recipient`, care must be
327      * taken to not create reentrancy vulnerabilities. Consider using
328      * {ReentrancyGuard} or the
329      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
330      */
331     function sendValue(address payable recipient, uint256 amount) internal {
332         require(address(this).balance >= amount, "Address: insufficient balance");
333 
334         (bool success, ) = recipient.call{value: amount}("");
335         require(success, "Address: unable to send value, recipient may have reverted");
336     }
337 
338     /**
339      * @dev Performs a Solidity function call using a low level `call`. A
340      * plain `call` is an unsafe replacement for a function call: use this
341      * function instead.
342      *
343      * If `target` reverts with a revert reason, it is bubbled up by this
344      * function (like regular Solidity function calls).
345      *
346      * Returns the raw returned data. To convert to the expected return value,
347      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
348      *
349      * Requirements:
350      *
351      * - `target` must be a contract.
352      * - calling `target` with `data` must not revert.
353      *
354      * _Available since v3.1._
355      */
356     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
357         return functionCall(target, data, "Address: low-level call failed");
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
362      * `errorMessage` as a fallback revert reason when `target` reverts.
363      *
364      * _Available since v3.1._
365      */
366     function functionCall(
367         address target,
368         bytes memory data,
369         string memory errorMessage
370     ) internal returns (bytes memory) {
371         return functionCallWithValue(target, data, 0, errorMessage);
372     }
373 
374     /**
375      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
376      * but also transferring `value` wei to `target`.
377      *
378      * Requirements:
379      *
380      * - the calling contract must have an ETH balance of at least `value`.
381      * - the called Solidity function must be `payable`.
382      *
383      * _Available since v3.1._
384      */
385     function functionCallWithValue(
386         address target,
387         bytes memory data,
388         uint256 value
389     ) internal returns (bytes memory) {
390         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
391     }
392 
393     /**
394      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
395      * with `errorMessage` as a fallback revert reason when `target` reverts.
396      *
397      * _Available since v3.1._
398      */
399     function functionCallWithValue(
400         address target,
401         bytes memory data,
402         uint256 value,
403         string memory errorMessage
404     ) internal returns (bytes memory) {
405         require(address(this).balance >= value, "Address: insufficient balance for call");
406         require(isContract(target), "Address: call to non-contract");
407 
408         (bool success, bytes memory returndata) = target.call{value: value}(data);
409         return verifyCallResult(success, returndata, errorMessage);
410     }
411 
412     /**
413      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
414      * but performing a static call.
415      *
416      * _Available since v3.3._
417      */
418     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
419         return functionStaticCall(target, data, "Address: low-level static call failed");
420     }
421 
422     /**
423      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
424      * but performing a static call.
425      *
426      * _Available since v3.3._
427      */
428     function functionStaticCall(
429         address target,
430         bytes memory data,
431         string memory errorMessage
432     ) internal view returns (bytes memory) {
433         require(isContract(target), "Address: static call to non-contract");
434 
435         (bool success, bytes memory returndata) = target.staticcall(data);
436         return verifyCallResult(success, returndata, errorMessage);
437     }
438 
439     /**
440      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
441      * but performing a delegate call.
442      *
443      * _Available since v3.4._
444      */
445     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
446         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
447     }
448 
449     /**
450      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
451      * but performing a delegate call.
452      *
453      * _Available since v3.4._
454      */
455     function functionDelegateCall(
456         address target,
457         bytes memory data,
458         string memory errorMessage
459     ) internal returns (bytes memory) {
460         require(isContract(target), "Address: delegate call to non-contract");
461 
462         (bool success, bytes memory returndata) = target.delegatecall(data);
463         return verifyCallResult(success, returndata, errorMessage);
464     }
465 
466     /**
467      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
468      * revert reason using the provided one.
469      *
470      * _Available since v4.3._
471      */
472     function verifyCallResult(
473         bool success,
474         bytes memory returndata,
475         string memory errorMessage
476     ) internal pure returns (bytes memory) {
477         if (success) {
478             return returndata;
479         } else {
480             // Look for revert reason and bubble it up if present
481             if (returndata.length > 0) {
482                 // The easiest way to bubble the revert reason is using memory via assembly
483 
484                 assembly {
485                     let returndata_size := mload(returndata)
486                     revert(add(32, returndata), returndata_size)
487                 }
488             } else {
489                 revert(errorMessage);
490             }
491         }
492     }
493 }
494 
495 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
496 
497 
498 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
499 
500 pragma solidity ^0.8.0;
501 
502 /**
503  * @title ERC721 token receiver interface
504  * @dev Interface for any contract that wants to support safeTransfers
505  * from ERC721 asset contracts.
506  */
507 interface IERC721Receiver {
508     /**
509      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
510      * by `operator` from `from`, this function is called.
511      *
512      * It must return its Solidity selector to confirm the token transfer.
513      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
514      *
515      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
516      */
517     function onERC721Received(
518         address operator,
519         address from,
520         uint256 tokenId,
521         bytes calldata data
522     ) external returns (bytes4);
523 }
524 
525 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
526 
527 
528 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
529 
530 pragma solidity ^0.8.0;
531 
532 /**
533  * @dev Interface of the ERC165 standard, as defined in the
534  * https://eips.ethereum.org/EIPS/eip-165[EIP].
535  *
536  * Implementers can declare support of contract interfaces, which can then be
537  * queried by others ({ERC165Checker}).
538  *
539  * For an implementation, see {ERC165}.
540  */
541 interface IERC165 {
542     /**
543      * @dev Returns true if this contract implements the interface defined by
544      * `interfaceId`. See the corresponding
545      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
546      * to learn more about how these ids are created.
547      *
548      * This function call must use less than 30 000 gas.
549      */
550     function supportsInterface(bytes4 interfaceId) external view returns (bool);
551 }
552 
553 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
554 
555 
556 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
557 
558 pragma solidity ^0.8.0;
559 
560 
561 /**
562  * @dev Implementation of the {IERC165} interface.
563  *
564  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
565  * for the additional interface id that will be supported. For example:
566  *
567  * ```solidity
568  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
569  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
570  * }
571  * ```
572  *
573  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
574  */
575 abstract contract ERC165 is IERC165 {
576     /**
577      * @dev See {IERC165-supportsInterface}.
578      */
579     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
580         return interfaceId == type(IERC165).interfaceId;
581     }
582 }
583 
584 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
585 
586 
587 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
588 
589 pragma solidity ^0.8.0;
590 
591 
592 /**
593  * @dev Required interface of an ERC721 compliant contract.
594  */
595 interface IERC721 is IERC165 {
596     /**
597      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
598      */
599     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
600 
601     /**
602      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
603      */
604     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
605 
606     /**
607      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
608      */
609     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
610 
611     /**
612      * @dev Returns the number of tokens in ``owner``'s account.
613      */
614     function balanceOf(address owner) external view returns (uint256 balance);
615 
616     /**
617      * @dev Returns the owner of the `tokenId` token.
618      *
619      * Requirements:
620      *
621      * - `tokenId` must exist.
622      */
623     function ownerOf(uint256 tokenId) external view returns (address owner);
624 
625     /**
626      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
627      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
628      *
629      * Requirements:
630      *
631      * - `from` cannot be the zero address.
632      * - `to` cannot be the zero address.
633      * - `tokenId` token must exist and be owned by `from`.
634      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
635      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
636      *
637      * Emits a {Transfer} event.
638      */
639     function safeTransferFrom(
640         address from,
641         address to,
642         uint256 tokenId
643     ) external;
644 
645     /**
646      * @dev Transfers `tokenId` token from `from` to `to`.
647      *
648      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
649      *
650      * Requirements:
651      *
652      * - `from` cannot be the zero address.
653      * - `to` cannot be the zero address.
654      * - `tokenId` token must be owned by `from`.
655      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
656      *
657      * Emits a {Transfer} event.
658      */
659     function transferFrom(
660         address from,
661         address to,
662         uint256 tokenId
663     ) external;
664 
665     /**
666      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
667      * The approval is cleared when the token is transferred.
668      *
669      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
670      *
671      * Requirements:
672      *
673      * - The caller must own the token or be an approved operator.
674      * - `tokenId` must exist.
675      *
676      * Emits an {Approval} event.
677      */
678     function approve(address to, uint256 tokenId) external;
679 
680     /**
681      * @dev Returns the account approved for `tokenId` token.
682      *
683      * Requirements:
684      *
685      * - `tokenId` must exist.
686      */
687     function getApproved(uint256 tokenId) external view returns (address operator);
688 
689     /**
690      * @dev Approve or remove `operator` as an operator for the caller.
691      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
692      *
693      * Requirements:
694      *
695      * - The `operator` cannot be the caller.
696      *
697      * Emits an {ApprovalForAll} event.
698      */
699     function setApprovalForAll(address operator, bool _approved) external;
700 
701     /**
702      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
703      *
704      * See {setApprovalForAll}
705      */
706     function isApprovedForAll(address owner, address operator) external view returns (bool);
707 
708     /**
709      * @dev Safely transfers `tokenId` token from `from` to `to`.
710      *
711      * Requirements:
712      *
713      * - `from` cannot be the zero address.
714      * - `to` cannot be the zero address.
715      * - `tokenId` token must exist and be owned by `from`.
716      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
717      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
718      *
719      * Emits a {Transfer} event.
720      */
721     function safeTransferFrom(
722         address from,
723         address to,
724         uint256 tokenId,
725         bytes calldata data
726     ) external;
727 }
728 
729 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
730 
731 
732 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
733 
734 pragma solidity ^0.8.0;
735 
736 
737 /**
738  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
739  * @dev See https://eips.ethereum.org/EIPS/eip-721
740  */
741 interface IERC721Metadata is IERC721 {
742     /**
743      * @dev Returns the token collection name.
744      */
745     function name() external view returns (string memory);
746 
747     /**
748      * @dev Returns the token collection symbol.
749      */
750     function symbol() external view returns (string memory);
751 
752     /**
753      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
754      */
755     function tokenURI(uint256 tokenId) external view returns (string memory);
756 }
757 
758 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
759 
760 
761 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
762 
763 pragma solidity ^0.8.0;
764 
765 
766 
767 
768 
769 
770 
771 
772 /**
773  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
774  * the Metadata extension, but not including the Enumerable extension, which is available separately as
775  * {ERC721Enumerable}.
776  */
777 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
778     using Address for address;
779     using Strings for uint256;
780 
781     // Token name
782     string private _name;
783 
784     // Token symbol
785     string private _symbol;
786 
787     // Mapping from token ID to owner address
788     mapping(uint256 => address) private _owners;
789 
790     // Mapping owner address to token count
791     mapping(address => uint256) private _balances;
792 
793     // Mapping from token ID to approved address
794     mapping(uint256 => address) private _tokenApprovals;
795 
796     // Mapping from owner to operator approvals
797     mapping(address => mapping(address => bool)) private _operatorApprovals;
798 
799     /**
800      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
801      */
802     constructor(string memory name_, string memory symbol_) {
803         _name = name_;
804         _symbol = symbol_;
805     }
806 
807     /**
808      * @dev See {IERC165-supportsInterface}.
809      */
810     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
811         return
812             interfaceId == type(IERC721).interfaceId ||
813             interfaceId == type(IERC721Metadata).interfaceId ||
814             super.supportsInterface(interfaceId);
815     }
816 
817     /**
818      * @dev See {IERC721-balanceOf}.
819      */
820     function balanceOf(address owner) public view virtual override returns (uint256) {
821         require(owner != address(0), "ERC721: balance query for the zero address");
822         return _balances[owner];
823     }
824 
825     /**
826      * @dev See {IERC721-ownerOf}.
827      */
828     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
829         address owner = _owners[tokenId];
830         require(owner != address(0), "ERC721: owner query for nonexistent token");
831         return owner;
832     }
833 
834     /**
835      * @dev See {IERC721Metadata-name}.
836      */
837     function name() public view virtual override returns (string memory) {
838         return _name;
839     }
840 
841     /**
842      * @dev See {IERC721Metadata-symbol}.
843      */
844     function symbol() public view virtual override returns (string memory) {
845         return _symbol;
846     }
847 
848     /**
849      * @dev See {IERC721Metadata-tokenURI}.
850      */
851     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
852         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
853 
854         string memory baseURI = _baseURI();
855         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
856     }
857 
858     /**
859      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
860      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
861      * by default, can be overriden in child contracts.
862      */
863     function _baseURI() internal view virtual returns (string memory) {
864         return "";
865     }
866 
867     /**
868      * @dev See {IERC721-approve}.
869      */
870     function approve(address to, uint256 tokenId) public virtual override {
871         address owner = ERC721.ownerOf(tokenId);
872         require(to != owner, "ERC721: approval to current owner");
873 
874         require(
875             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
876             "ERC721: approve caller is not owner nor approved for all"
877         );
878 
879         _approve(to, tokenId);
880     }
881 
882     /**
883      * @dev See {IERC721-getApproved}.
884      */
885     function getApproved(uint256 tokenId) public view virtual override returns (address) {
886         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
887 
888         return _tokenApprovals[tokenId];
889     }
890 
891     /**
892      * @dev See {IERC721-setApprovalForAll}.
893      */
894     function setApprovalForAll(address operator, bool approved) public virtual override {
895         _setApprovalForAll(_msgSender(), operator, approved);
896     }
897 
898     /**
899      * @dev See {IERC721-isApprovedForAll}.
900      */
901     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
902         return _operatorApprovals[owner][operator];
903     }
904 
905     /**
906      * @dev See {IERC721-transferFrom}.
907      */
908     function transferFrom(
909         address from,
910         address to,
911         uint256 tokenId
912     ) public virtual override {
913         //solhint-disable-next-line max-line-length
914         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
915 
916         _transfer(from, to, tokenId);
917     }
918 
919     /**
920      * @dev See {IERC721-safeTransferFrom}.
921      */
922     function safeTransferFrom(
923         address from,
924         address to,
925         uint256 tokenId
926     ) public virtual override {
927         safeTransferFrom(from, to, tokenId, "");
928     }
929 
930     /**
931      * @dev See {IERC721-safeTransferFrom}.
932      */
933     function safeTransferFrom(
934         address from,
935         address to,
936         uint256 tokenId,
937         bytes memory _data
938     ) public virtual override {
939         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
940         _safeTransfer(from, to, tokenId, _data);
941     }
942 
943     /**
944      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
945      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
946      *
947      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
948      *
949      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
950      * implement alternative mechanisms to perform token transfer, such as signature-based.
951      *
952      * Requirements:
953      *
954      * - `from` cannot be the zero address.
955      * - `to` cannot be the zero address.
956      * - `tokenId` token must exist and be owned by `from`.
957      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
958      *
959      * Emits a {Transfer} event.
960      */
961     function _safeTransfer(
962         address from,
963         address to,
964         uint256 tokenId,
965         bytes memory _data
966     ) internal virtual {
967         _transfer(from, to, tokenId);
968         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
969     }
970 
971     /**
972      * @dev Returns whether `tokenId` exists.
973      *
974      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
975      *
976      * Tokens start existing when they are minted (`_mint`),
977      * and stop existing when they are burned (`_burn`).
978      */
979     function _exists(uint256 tokenId) internal view virtual returns (bool) {
980         return _owners[tokenId] != address(0);
981     }
982 
983     /**
984      * @dev Returns whether `spender` is allowed to manage `tokenId`.
985      *
986      * Requirements:
987      *
988      * - `tokenId` must exist.
989      */
990     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
991         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
992         address owner = ERC721.ownerOf(tokenId);
993         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
994     }
995 
996     /**
997      * @dev Safely mints `tokenId` and transfers it to `to`.
998      *
999      * Requirements:
1000      *
1001      * - `tokenId` must not exist.
1002      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1003      *
1004      * Emits a {Transfer} event.
1005      */
1006     function _safeMint(address to, uint256 tokenId) internal virtual {
1007         _safeMint(to, tokenId, "");
1008     }
1009 
1010     /**
1011      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1012      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1013      */
1014     function _safeMint(
1015         address to,
1016         uint256 tokenId,
1017         bytes memory _data
1018     ) internal virtual {
1019         _mint(to, tokenId);
1020         require(
1021             _checkOnERC721Received(address(0), to, tokenId, _data),
1022             "ERC721: transfer to non ERC721Receiver implementer"
1023         );
1024     }
1025 
1026     /**
1027      * @dev Mints `tokenId` and transfers it to `to`.
1028      *
1029      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1030      *
1031      * Requirements:
1032      *
1033      * - `tokenId` must not exist.
1034      * - `to` cannot be the zero address.
1035      *
1036      * Emits a {Transfer} event.
1037      */
1038     function _mint(address to, uint256 tokenId) internal virtual {
1039         require(to != address(0), "ERC721: mint to the zero address");
1040         require(!_exists(tokenId), "ERC721: token already minted");
1041 
1042         _beforeTokenTransfer(address(0), to, tokenId);
1043 
1044         _balances[to] += 1;
1045         _owners[tokenId] = to;
1046 
1047         emit Transfer(address(0), to, tokenId);
1048 
1049         _afterTokenTransfer(address(0), to, tokenId);
1050     }
1051 
1052     /**
1053      * @dev Destroys `tokenId`.
1054      * The approval is cleared when the token is burned.
1055      *
1056      * Requirements:
1057      *
1058      * - `tokenId` must exist.
1059      *
1060      * Emits a {Transfer} event.
1061      */
1062     function _burn(uint256 tokenId) internal virtual {
1063         address owner = ERC721.ownerOf(tokenId);
1064 
1065         _beforeTokenTransfer(owner, address(0), tokenId);
1066 
1067         // Clear approvals
1068         _approve(address(0), tokenId);
1069 
1070         _balances[owner] -= 1;
1071         delete _owners[tokenId];
1072 
1073         emit Transfer(owner, address(0), tokenId);
1074 
1075         _afterTokenTransfer(owner, address(0), tokenId);
1076     }
1077 
1078     /**
1079      * @dev Transfers `tokenId` from `from` to `to`.
1080      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1081      *
1082      * Requirements:
1083      *
1084      * - `to` cannot be the zero address.
1085      * - `tokenId` token must be owned by `from`.
1086      *
1087      * Emits a {Transfer} event.
1088      */
1089     function _transfer(
1090         address from,
1091         address to,
1092         uint256 tokenId
1093     ) internal virtual {
1094         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1095         require(to != address(0), "ERC721: transfer to the zero address");
1096 
1097         _beforeTokenTransfer(from, to, tokenId);
1098 
1099         // Clear approvals from the previous owner
1100         _approve(address(0), tokenId);
1101 
1102         _balances[from] -= 1;
1103         _balances[to] += 1;
1104         _owners[tokenId] = to;
1105 
1106         emit Transfer(from, to, tokenId);
1107 
1108         _afterTokenTransfer(from, to, tokenId);
1109     }
1110 
1111     /**
1112      * @dev Approve `to` to operate on `tokenId`
1113      *
1114      * Emits a {Approval} event.
1115      */
1116     function _approve(address to, uint256 tokenId) internal virtual {
1117         _tokenApprovals[tokenId] = to;
1118         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1119     }
1120 
1121     /**
1122      * @dev Approve `operator` to operate on all of `owner` tokens
1123      *
1124      * Emits a {ApprovalForAll} event.
1125      */
1126     function _setApprovalForAll(
1127         address owner,
1128         address operator,
1129         bool approved
1130     ) internal virtual {
1131         require(owner != operator, "ERC721: approve to caller");
1132         _operatorApprovals[owner][operator] = approved;
1133         emit ApprovalForAll(owner, operator, approved);
1134     }
1135 
1136     /**
1137      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1138      * The call is not executed if the target address is not a contract.
1139      *
1140      * @param from address representing the previous owner of the given token ID
1141      * @param to target address that will receive the tokens
1142      * @param tokenId uint256 ID of the token to be transferred
1143      * @param _data bytes optional data to send along with the call
1144      * @return bool whether the call correctly returned the expected magic value
1145      */
1146     function _checkOnERC721Received(
1147         address from,
1148         address to,
1149         uint256 tokenId,
1150         bytes memory _data
1151     ) private returns (bool) {
1152         if (to.isContract()) {
1153             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1154                 return retval == IERC721Receiver.onERC721Received.selector;
1155             } catch (bytes memory reason) {
1156                 if (reason.length == 0) {
1157                     revert("ERC721: transfer to non ERC721Receiver implementer");
1158                 } else {
1159                     assembly {
1160                         revert(add(32, reason), mload(reason))
1161                     }
1162                 }
1163             }
1164         } else {
1165             return true;
1166         }
1167     }
1168 
1169     /**
1170      * @dev Hook that is called before any token transfer. This includes minting
1171      * and burning.
1172      *
1173      * Calling conditions:
1174      *
1175      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1176      * transferred to `to`.
1177      * - When `from` is zero, `tokenId` will be minted for `to`.
1178      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1179      * - `from` and `to` are never both zero.
1180      *
1181      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1182      */
1183     function _beforeTokenTransfer(
1184         address from,
1185         address to,
1186         uint256 tokenId
1187     ) internal virtual {}
1188 
1189     /**
1190      * @dev Hook that is called after any transfer of tokens. This includes
1191      * minting and burning.
1192      *
1193      * Calling conditions:
1194      *
1195      * - when `from` and `to` are both non-zero.
1196      * - `from` and `to` are never both zero.
1197      *
1198      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1199      */
1200     function _afterTokenTransfer(
1201         address from,
1202         address to,
1203         uint256 tokenId
1204     ) internal virtual {}
1205 }
1206 
1207 // File: Lucky777.sol
1208 
1209 
1210 pragma solidity ^0.8.2;
1211 
1212 
1213 
1214 
1215 
1216 contract Lucky777 is ERC721, Ownable {
1217 
1218     using Strings for uint256;
1219 
1220     using Counters for Counters.Counter;
1221 
1222     Counters.Counter private supply;
1223 
1224     string public uriPrefix = "ipfs://QmZDzm1w8iFh8VnNNsa7iDGAzzD3ijDVvQGT81ek42JaYM/";
1225     string public uriSuffix = ".json";
1226     string public hiddenMetadataUri;
1227 
1228     uint256 public cost = 0.007 ether;
1229     uint256 public maxSupply = 777;
1230     uint256 public maxMintAmountPerTx = 2;
1231 
1232     bool public paused = false;
1233     bool public revealed = true;
1234 
1235     constructor() ERC721("Lucky 7s", "LUCKY7") {
1236         setHiddenMetadataUri("ipfs://QmZDzm1w8iFh8VnNNsa7iDGAzzD3ijDVvQGT81ek42JaYM/");
1237     }
1238 
1239      modifier mintCompliance(uint256 _mintAmount) {
1240         require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1241         require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
1242         _;
1243     }
1244 
1245     function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1246         require(!paused, "The contract is paused!");
1247 
1248         if(supply.current() < 666) {
1249             require(total_nft(msg.sender) < 10,  "NFT Per Wallet Limit Exceeds!!");
1250             _mintLoop(msg.sender, _mintAmount);
1251         }
1252         else{
1253             require(total_nft(msg.sender) < 10,  "NFT Per Wallet Limit Exceeds!!");
1254             require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1255             _mintLoop(msg.sender, _mintAmount);
1256         }
1257     }
1258 
1259     
1260     function total_nft(address _buyer) public view returns (uint256) {
1261        uint256[] memory _num = walletOfOwner(_buyer);
1262        return _num.length;
1263     }
1264 
1265     function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1266         for (uint256 i = 0; i < _mintAmount; i++) {
1267             supply.increment();
1268             _safeMint(_receiver, supply.current());
1269         }
1270     }
1271 
1272     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory){
1273         require(
1274         _exists(_tokenId),
1275         "ERC721Metadata: URI query for nonexistent token"
1276         );
1277 
1278         if (revealed == false) {
1279             return hiddenMetadataUri;
1280         }
1281 
1282         string memory currentBaseURI = _baseURI();
1283         return bytes(currentBaseURI).length > 0
1284             ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1285             : "";
1286     }
1287 
1288     function walletOfOwner(address _owner) public view returns (uint256[] memory) {
1289         uint256 ownerTokenCount = balanceOf(_owner);
1290         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1291         uint256 currentTokenId = 1;
1292         uint256 ownedTokenIndex = 0;
1293 
1294         while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1295 
1296             address currentTokenOwner = ownerOf(currentTokenId);
1297 
1298             if (currentTokenOwner == _owner) {
1299                 ownedTokenIds[ownedTokenIndex] = currentTokenId;
1300 
1301                 ownedTokenIndex++;
1302             }
1303 
1304             currentTokenId++;
1305         }
1306 
1307         return ownedTokenIds;
1308     }
1309 
1310 
1311     function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1312         uriPrefix = _uriPrefix;
1313     }
1314 
1315     function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1316         uriSuffix = _uriSuffix;
1317     }
1318 
1319     function setPaused(bool _state) public onlyOwner {
1320         paused = _state;
1321     }
1322 
1323     function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1324 		hiddenMetadataUri = _hiddenMetadataUri;
1325 	}
1326 
1327     function setRevealed(bool _state) public onlyOwner {
1328         revealed = _state;
1329     }
1330 
1331     function setCost(uint256 _cost) public onlyOwner {
1332         cost = _cost;
1333     }
1334 
1335     function totalSupply() public view returns (uint256) {
1336         return supply.current();
1337     }
1338 
1339     function _baseURI() internal view virtual override returns (string memory) {
1340         return uriPrefix;
1341     }
1342 
1343     function withdraw() public onlyOwner {
1344         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1345         require(os);
1346     }    
1347    
1348 }