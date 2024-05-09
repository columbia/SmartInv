1 // SPDX-License-Identifier: MIT
2 
3 //⠀⠀⢀⣠⠤⠶⠖⠒⠒⠶⠦⠤⣄⠀⠀⠀⣀⡤⠤⠤⠤⠤⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
4 //⠀⣴⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⣦⠞⠁⠀⠀⠀⠀⠀⠀⠉⠳⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
5 //⡾⠁⠀⠀⠀⠀⠀⠀⣀⣀⣀⣀⣀⣀⣘⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
6 //⠀⠀⠀⠀⢀⡴⠚⠉⠁⠀⠀⠀⠀⠈⠉⠙⠲⣄⣤⠤⠶⠒⠒⠲⠦⢤⣜⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
7 //⠀⠀⠀⠀⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠳⡄⠀⠀⠀⠀⠀⠀⠀⠉⠳⢄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
8 //⠀⠀⠀⠀⠀⠀⠀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⠹⣆⠀⠀⠀⠀⠀⠀⣀⣀⣀⣹⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀
9 //⠀⠀⠀⠀⣠⠞⣉⣡⠤⠴⠿⠗⠳⠶⣬⣙⠓⢦⡈⠙⢿⡀⠀⠀⢀⣼⣿⣿⣿⣿⣿⡿⣷⣤⡀⠀⠀⠀⠀⠀⠀
10 //⠀⠀⠀⣾⣡⠞⣁⣀⣀⣀⣠⣤⣤⣤⣄⣭⣷⣦⣽⣦⡀⢻⡄⠰⢟⣥⣾⣿⣏⣉⡙⠓⢦⣻⠃⠀⠀⠀⠀⠀⠀
11 //⠀⠀⠀⠉⠉⠙⠻⢤⣄⣼⣿⣽⣿⠟⠻⣿⠄⠀⠀⢻⡝⢿⡇⣠⣿⣿⣻⣿⠿⣿⡉⠓⠮⣿⠀⠀⠀⠀⠀⠀⠀
12 //⠀⠀⠀⠀⠀⠀⠙⢦⡈⠛⠿⣾⣿⣶⣾⡿⠀⠀⠀⢀⣳⣘⢻⣇⣿⣿⣽⣿⣶⣾⠃⣀⡴⣿⠀⠀⠀⠀⠀⠀⠀
13 //⠀⠀⠀⠀⠀⠀⠀⠀⠙⠲⠤⢄⣈⣉⣙⣓⣒⣒⣚⣉⣥⠟⠀⢯⣉⡉⠉⠉⠛⢉⣉⣡⡾⠁⠀⠀⠀⠀⠀⠀⠀
14 //⠀⠀⣠⣤⡤⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢈⡿⠋⠀⠀⠀⠀⠈⠻⣍⠉⠀⠺⠿⠋⠙⣦⠀⠀⠀⠀⠀⠀⠀
15 //⠀⣀⣥⣤⠴⠆⠀⠀⠀⠀⠀⠀⠀⣀⣠⠤⠖⠋⠀⠀⠀⠀⠀⠀⠀⠀⠈⠳⠀⠀⠀⠀⠀⢸⣧⠀⠀⠀⠀⠀⠀
16 //⠸⢫⡟⠙⣛⠲⠤⣄⣀⣀⠀⠈⠋⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⠏⣨⠇⠀⠀⠀⠀⠀
17 //⠀⠀⠻⢦⣈⠓⠶⠤⣄⣉⠉⠉⠛⠒⠲⠦⠤⠤⣤⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣠⠴⢋⡴⠋⠀⠀⠀⠀⠀⠀
18 //⠀⠀⠀⠀⠉⠓⠦⣄⡀⠈⠙⠓⠒⠶⠶⠶⠶⠤⣤⣀⣀⣀⣀⣀⣉⣉⣉⣉⣉⣀⣠⠴⠋⣿⠀⠀⠀⠀⠀⠀⠀
19 //⠀⠀⠀⠀⠀⠀⠀⠀⠉⠓⠦⣄⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡼⠁⠀⠀⠀⠀⠀⠀⠀
20 //⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠙⠛⠒⠒⠒⠒⠒⠤⠤⠤⠒⠒⠒⠒⠒⠒⠚⢉⡇⠀⠀⠀⠀⠀⠀⠀⠀
21 //⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⠴⠚⠛⠳⣤⠞⠁⠀⠀⠀⠀⠀⠀⠀⠀
22 //⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⠚⠁⠀⠀⠀⠀⠘⠲⣄⡀⠀⠀⠀⠀⠀⠀⠀
23 //⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⠋⠙⢷⡋⢙⡇⢀⡴⢒⡿⢶⣄⡴⠀⠙⠳⣄⠀⠀⠀⠀⠀
24 //⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢦⡀⠈⠛⢻⠛⢉⡴⣋⡴⠟⠁⠀⠀⠀⠀⠈⢧⡀⠀⠀⠀
25 //⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⡄⠀⠘⣶⢋⡞⠁⠀⠀⢀⡴⠂⠀⠀⠀⠀⠹⣄⠀⠀
26 //⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⠈⠻⢦⡀⠀⣰⠏⠀⠀⢀⡴⠃⢀⡄⠙⣆⠀
27 //⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡾⢷⡄⠀⠀⠀⠀⠉⠙⠯⠀⠀⡴⠋⠀⢠⠟⠀⠀⢹⡄
28 
29 // File: @openzeppelin/contracts/utils/Counters.sol
30 
31 
32 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
33 
34 pragma solidity ^0.8.0;
35 
36 /**
37  * @title Counters
38  * @author Matt Condon (@shrugs)
39  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
40  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
41  *
42  * Include with `using Counters for Counters.Counter;`
43  */
44 library Counters {
45     struct Counter {
46         // This variable should never be directly accessed by users of the library: interactions must be restricted to
47         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
48         // this feature: see https://github.com/ethereum/solidity/issues/4637
49         uint256 _value; // default: 0
50     }
51 
52     function current(Counter storage counter) internal view returns (uint256) {
53         return counter._value;
54     }
55 
56     function increment(Counter storage counter) internal {
57         unchecked {
58             counter._value += 1;
59         }
60     }
61 
62     function decrement(Counter storage counter) internal {
63         uint256 value = counter._value;
64         require(value > 0, "Counter: decrement overflow");
65         unchecked {
66             counter._value = value - 1;
67         }
68     }
69 
70     function reset(Counter storage counter) internal {
71         counter._value = 0;
72     }
73 }
74 
75 // File: @openzeppelin/contracts/utils/Strings.sol
76 
77 
78 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
79 
80 pragma solidity ^0.8.0;
81 
82 /**
83  * @dev String operations.
84  */
85 library Strings {
86     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
87 
88     /**
89      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
90      */
91     function toString(uint256 value) internal pure returns (string memory) {
92         // Inspired by OraclizeAPI's implementation - MIT licence
93         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
94 
95         if (value == 0) {
96             return "0";
97         }
98         uint256 temp = value;
99         uint256 digits;
100         while (temp != 0) {
101             digits++;
102             temp /= 10;
103         }
104         bytes memory buffer = new bytes(digits);
105         while (value != 0) {
106             digits -= 1;
107             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
108             value /= 10;
109         }
110         return string(buffer);
111     }
112 
113     /**
114      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
115      */
116     function toHexString(uint256 value) internal pure returns (string memory) {
117         if (value == 0) {
118             return "0x00";
119         }
120         uint256 temp = value;
121         uint256 length = 0;
122         while (temp != 0) {
123             length++;
124             temp >>= 8;
125         }
126         return toHexString(value, length);
127     }
128 
129     /**
130      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
131      */
132     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
133         bytes memory buffer = new bytes(2 * length + 2);
134         buffer[0] = "0";
135         buffer[1] = "x";
136         for (uint256 i = 2 * length + 1; i > 1; --i) {
137             buffer[i] = _HEX_SYMBOLS[value & 0xf];
138             value >>= 4;
139         }
140         require(value == 0, "Strings: hex length insufficient");
141         return string(buffer);
142     }
143 }
144 
145 // File: @openzeppelin/contracts/utils/Context.sol
146 
147 
148 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
149 
150 pragma solidity ^0.8.0;
151 
152 /**
153  * @dev Provides information about the current execution context, including the
154  * sender of the transaction and its data. While these are generally available
155  * via msg.sender and msg.data, they should not be accessed in such a direct
156  * manner, since when dealing with meta-transactions the account sending and
157  * paying for execution may not be the actual sender (as far as an application
158  * is concerned).
159  *
160  * This contract is only required for intermediate, library-like contracts.
161  */
162 abstract contract Context {
163     function _msgSender() internal view virtual returns (address) {
164         return msg.sender;
165     }
166 
167     function _msgData() internal view virtual returns (bytes calldata) {
168         return msg.data;
169     }
170 }
171 
172 // File: @openzeppelin/contracts/access/Ownable.sol
173 
174 
175 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
176 
177 pragma solidity ^0.8.0;
178 
179 
180 /**
181  * @dev Contract module which provides a basic access control mechanism, where
182  * there is an account (an owner) that can be granted exclusive access to
183  * specific functions.
184  *
185  * By default, the owner account will be the one that deploys the contract. This
186  * can later be changed with {transferOwnership}.
187  *
188  * This module is used through inheritance. It will make available the modifier
189  * `onlyOwner`, which can be applied to your functions to restrict their use to
190  * the owner.
191  */
192 abstract contract Ownable is Context {
193     address private _owner;
194 
195     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
196 
197     /**
198      * @dev Initializes the contract setting the deployer as the initial owner.
199      */
200     constructor() {
201         _transferOwnership(_msgSender());
202     }
203 
204     /**
205      * @dev Returns the address of the current owner.
206      */
207     function owner() public view virtual returns (address) {
208         return _owner;
209     }
210 
211     /**
212      * @dev Throws if called by any account other than the owner.
213      */
214     modifier onlyOwner() {
215         require(owner() == _msgSender(), "Ownable: caller is not the owner");
216         _;
217     }
218 
219     /**
220      * @dev Leaves the contract without owner. It will not be possible to call
221      * `onlyOwner` functions anymore. Can only be called by the current owner.
222      *
223      * NOTE: Renouncing ownership will leave the contract without an owner,
224      * thereby removing any functionality that is only available to the owner.
225      */
226     function renounceOwnership() public virtual onlyOwner {
227         _transferOwnership(address(0));
228     }
229 
230     /**
231      * @dev Transfers ownership of the contract to a new account (`newOwner`).
232      * Can only be called by the current owner.
233      */
234     function transferOwnership(address newOwner) public virtual onlyOwner {
235         require(newOwner != address(0), "Ownable: new owner is the zero address");
236         _transferOwnership(newOwner);
237     }
238 
239     /**
240      * @dev Transfers ownership of the contract to a new account (`newOwner`).
241      * Internal function without access restriction.
242      */
243     function _transferOwnership(address newOwner) internal virtual {
244         address oldOwner = _owner;
245         _owner = newOwner;
246         emit OwnershipTransferred(oldOwner, newOwner);
247     }
248 }
249 
250 // File: @openzeppelin/contracts/utils/Address.sol
251 
252 
253 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
254 
255 pragma solidity ^0.8.1;
256 
257 /**
258  * @dev Collection of functions related to the address type
259  */
260 library Address {
261     /**
262      * @dev Returns true if `account` is a contract.
263      *
264      * [IMPORTANT]
265      * ====
266      * It is unsafe to assume that an address for which this function returns
267      * false is an externally-owned account (EOA) and not a contract.
268      *
269      * Among others, `isContract` will return false for the following
270      * types of addresses:
271      *
272      *  - an externally-owned account
273      *  - a contract in construction
274      *  - an address where a contract will be created
275      *  - an address where a contract lived, but was destroyed
276      * ====
277      *
278      * [IMPORTANT]
279      * ====
280      * You shouldn't rely on `isContract` to protect against flash loan attacks!
281      *
282      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
283      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
284      * constructor.
285      * ====
286      */
287     function isContract(address account) internal view returns (bool) {
288         // This method relies on extcodesize/address.code.length, which returns 0
289         // for contracts in construction, since the code is only stored at the end
290         // of the constructor execution.
291 
292         return account.code.length > 0;
293     }
294 
295     /**
296      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
297      * `recipient`, forwarding all available gas and reverting on errors.
298      *
299      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
300      * of certain opcodes, possibly making contracts go over the 2300 gas limit
301      * imposed by `transfer`, making them unable to receive funds via
302      * `transfer`. {sendValue} removes this limitation.
303      *
304      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
305      *
306      * IMPORTANT: because control is transferred to `recipient`, care must be
307      * taken to not create reentrancy vulnerabilities. Consider using
308      * {ReentrancyGuard} or the
309      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
310      */
311     function sendValue(address payable recipient, uint256 amount) internal {
312         require(address(this).balance >= amount, "Address: insufficient balance");
313 
314         (bool success, ) = recipient.call{value: amount}("");
315         require(success, "Address: unable to send value, recipient may have reverted");
316     }
317 
318     /**
319      * @dev Performs a Solidity function call using a low level `call`. A
320      * plain `call` is an unsafe replacement for a function call: use this
321      * function instead.
322      *
323      * If `target` reverts with a revert reason, it is bubbled up by this
324      * function (like regular Solidity function calls).
325      *
326      * Returns the raw returned data. To convert to the expected return value,
327      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
328      *
329      * Requirements:
330      *
331      * - `target` must be a contract.
332      * - calling `target` with `data` must not revert.
333      *
334      * _Available since v3.1._
335      */
336     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
337         return functionCall(target, data, "Address: low-level call failed");
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
342      * `errorMessage` as a fallback revert reason when `target` reverts.
343      *
344      * _Available since v3.1._
345      */
346     function functionCall(
347         address target,
348         bytes memory data,
349         string memory errorMessage
350     ) internal returns (bytes memory) {
351         return functionCallWithValue(target, data, 0, errorMessage);
352     }
353 
354     /**
355      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
356      * but also transferring `value` wei to `target`.
357      *
358      * Requirements:
359      *
360      * - the calling contract must have an ETH balance of at least `value`.
361      * - the called Solidity function must be `payable`.
362      *
363      * _Available since v3.1._
364      */
365     function functionCallWithValue(
366         address target,
367         bytes memory data,
368         uint256 value
369     ) internal returns (bytes memory) {
370         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
371     }
372 
373     /**
374      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
375      * with `errorMessage` as a fallback revert reason when `target` reverts.
376      *
377      * _Available since v3.1._
378      */
379     function functionCallWithValue(
380         address target,
381         bytes memory data,
382         uint256 value,
383         string memory errorMessage
384     ) internal returns (bytes memory) {
385         require(address(this).balance >= value, "Address: insufficient balance for call");
386         require(isContract(target), "Address: call to non-contract");
387 
388         (bool success, bytes memory returndata) = target.call{value: value}(data);
389         return verifyCallResult(success, returndata, errorMessage);
390     }
391 
392     /**
393      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
394      * but performing a static call.
395      *
396      * _Available since v3.3._
397      */
398     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
399         return functionStaticCall(target, data, "Address: low-level static call failed");
400     }
401 
402     /**
403      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
404      * but performing a static call.
405      *
406      * _Available since v3.3._
407      */
408     function functionStaticCall(
409         address target,
410         bytes memory data,
411         string memory errorMessage
412     ) internal view returns (bytes memory) {
413         require(isContract(target), "Address: static call to non-contract");
414 
415         (bool success, bytes memory returndata) = target.staticcall(data);
416         return verifyCallResult(success, returndata, errorMessage);
417     }
418 
419     /**
420      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
421      * but performing a delegate call.
422      *
423      * _Available since v3.4._
424      */
425     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
426         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
427     }
428 
429     /**
430      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
431      * but performing a delegate call.
432      *
433      * _Available since v3.4._
434      */
435     function functionDelegateCall(
436         address target,
437         bytes memory data,
438         string memory errorMessage
439     ) internal returns (bytes memory) {
440         require(isContract(target), "Address: delegate call to non-contract");
441 
442         (bool success, bytes memory returndata) = target.delegatecall(data);
443         return verifyCallResult(success, returndata, errorMessage);
444     }
445 
446     /**
447      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
448      * revert reason using the provided one.
449      *
450      * _Available since v4.3._
451      */
452     function verifyCallResult(
453         bool success,
454         bytes memory returndata,
455         string memory errorMessage
456     ) internal pure returns (bytes memory) {
457         if (success) {
458             return returndata;
459         } else {
460             // Look for revert reason and bubble it up if present
461             if (returndata.length > 0) {
462                 // The easiest way to bubble the revert reason is using memory via assembly
463 
464                 assembly {
465                     let returndata_size := mload(returndata)
466                     revert(add(32, returndata), returndata_size)
467                 }
468             } else {
469                 revert(errorMessage);
470             }
471         }
472     }
473 }
474 
475 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
476 
477 
478 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
479 
480 pragma solidity ^0.8.0;
481 
482 /**
483  * @title ERC721 token receiver interface
484  * @dev Interface for any contract that wants to support safeTransfers
485  * from ERC721 asset contracts.
486  */
487 interface IERC721Receiver {
488     /**
489      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
490      * by `operator` from `from`, this function is called.
491      *
492      * It must return its Solidity selector to confirm the token transfer.
493      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
494      *
495      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
496      */
497     function onERC721Received(
498         address operator,
499         address from,
500         uint256 tokenId,
501         bytes calldata data
502     ) external returns (bytes4);
503 }
504 
505 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
506 
507 
508 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
509 
510 pragma solidity ^0.8.0;
511 
512 /**
513  * @dev Interface of the ERC165 standard, as defined in the
514  * https://eips.ethereum.org/EIPS/eip-165[EIP].
515  *
516  * Implementers can declare support of contract interfaces, which can then be
517  * queried by others ({ERC165Checker}).
518  *
519  * For an implementation, see {ERC165}.
520  */
521 interface IERC165 {
522     /**
523      * @dev Returns true if this contract implements the interface defined by
524      * `interfaceId`. See the corresponding
525      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
526      * to learn more about how these ids are created.
527      *
528      * This function call must use less than 30 000 gas.
529      */
530     function supportsInterface(bytes4 interfaceId) external view returns (bool);
531 }
532 
533 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
534 
535 
536 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
537 
538 pragma solidity ^0.8.0;
539 
540 
541 /**
542  * @dev Implementation of the {IERC165} interface.
543  *
544  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
545  * for the additional interface id that will be supported. For example:
546  *
547  * ```solidity
548  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
549  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
550  * }
551  * ```
552  *
553  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
554  */
555 abstract contract ERC165 is IERC165 {
556     /**
557      * @dev See {IERC165-supportsInterface}.
558      */
559     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
560         return interfaceId == type(IERC165).interfaceId;
561     }
562 }
563 
564 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
565 
566 
567 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
568 
569 pragma solidity ^0.8.0;
570 
571 
572 /**
573  * @dev Required interface of an ERC721 compliant contract.
574  */
575 interface IERC721 is IERC165 {
576     /**
577      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
578      */
579     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
580 
581     /**
582      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
583      */
584     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
585 
586     /**
587      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
588      */
589     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
590 
591     /**
592      * @dev Returns the number of tokens in ``owner``'s account.
593      */
594     function balanceOf(address owner) external view returns (uint256 balance);
595 
596     /**
597      * @dev Returns the owner of the `tokenId` token.
598      *
599      * Requirements:
600      *
601      * - `tokenId` must exist.
602      */
603     function ownerOf(uint256 tokenId) external view returns (address owner);
604 
605     /**
606      * @dev Safely transfers `tokenId` token from `from` to `to`.
607      *
608      * Requirements:
609      *
610      * - `from` cannot be the zero address.
611      * - `to` cannot be the zero address.
612      * - `tokenId` token must exist and be owned by `from`.
613      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
614      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
615      *
616      * Emits a {Transfer} event.
617      */
618     function safeTransferFrom(
619         address from,
620         address to,
621         uint256 tokenId,
622         bytes calldata data
623     ) external;
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
681      * @dev Approve or remove `operator` as an operator for the caller.
682      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
683      *
684      * Requirements:
685      *
686      * - The `operator` cannot be the caller.
687      *
688      * Emits an {ApprovalForAll} event.
689      */
690     function setApprovalForAll(address operator, bool _approved) external;
691 
692     /**
693      * @dev Returns the account approved for `tokenId` token.
694      *
695      * Requirements:
696      *
697      * - `tokenId` must exist.
698      */
699     function getApproved(uint256 tokenId) external view returns (address operator);
700 
701     /**
702      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
703      *
704      * See {setApprovalForAll}
705      */
706     function isApprovedForAll(address owner, address operator) external view returns (bool);
707 }
708 
709 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
710 
711 
712 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
713 
714 pragma solidity ^0.8.0;
715 
716 
717 /**
718  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
719  * @dev See https://eips.ethereum.org/EIPS/eip-721
720  */
721 interface IERC721Metadata is IERC721 {
722     /**
723      * @dev Returns the token collection name.
724      */
725     function name() external view returns (string memory);
726 
727     /**
728      * @dev Returns the token collection symbol.
729      */
730     function symbol() external view returns (string memory);
731 
732     /**
733      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
734      */
735     function tokenURI(uint256 tokenId) external view returns (string memory);
736 }
737 
738 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
739 
740 
741 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
742 
743 pragma solidity ^0.8.0;
744 
745 
746 
747 
748 
749 
750 
751 
752 /**
753  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
754  * the Metadata extension, but not including the Enumerable extension, which is available separately as
755  * {ERC721Enumerable}.
756  */
757 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
758     using Address for address;
759     using Strings for uint256;
760 
761     // Token name
762     string private _name;
763 
764     // Token symbol
765     string private _symbol;
766 
767     // Mapping from token ID to owner address
768     mapping(uint256 => address) private _owners;
769 
770     // Mapping owner address to token count
771     mapping(address => uint256) private _balances;
772 
773     // Mapping from token ID to approved address
774     mapping(uint256 => address) private _tokenApprovals;
775 
776     // Mapping from owner to operator approvals
777     mapping(address => mapping(address => bool)) private _operatorApprovals;
778 
779     /**
780      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
781      */
782     constructor(string memory name_, string memory symbol_) {
783         _name = name_;
784         _symbol = symbol_;
785     }
786 
787     /**
788      * @dev See {IERC165-supportsInterface}.
789      */
790     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
791         return
792             interfaceId == type(IERC721).interfaceId ||
793             interfaceId == type(IERC721Metadata).interfaceId ||
794             super.supportsInterface(interfaceId);
795     }
796 
797     /**
798      * @dev See {IERC721-balanceOf}.
799      */
800     function balanceOf(address owner) public view virtual override returns (uint256) {
801         require(owner != address(0), "ERC721: balance query for the zero address");
802         return _balances[owner];
803     }
804 
805     /**
806      * @dev See {IERC721-ownerOf}.
807      */
808     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
809         address owner = _owners[tokenId];
810         require(owner != address(0), "ERC721: owner query for nonexistent token");
811         return owner;
812     }
813 
814     /**
815      * @dev See {IERC721Metadata-name}.
816      */
817     function name() public view virtual override returns (string memory) {
818         return _name;
819     }
820 
821     /**
822      * @dev See {IERC721Metadata-symbol}.
823      */
824     function symbol() public view virtual override returns (string memory) {
825         return _symbol;
826     }
827 
828     /**
829      * @dev See {IERC721Metadata-tokenURI}.
830      */
831     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
832         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
833 
834         string memory baseURI = _baseURI();
835         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
836     }
837 
838     /**
839      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
840      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
841      * by default, can be overridden in child contracts.
842      */
843     function _baseURI() internal view virtual returns (string memory) {
844         return "";
845     }
846 
847     /**
848      * @dev See {IERC721-approve}.
849      */
850     function approve(address to, uint256 tokenId) public virtual override {
851         address owner = ERC721.ownerOf(tokenId);
852         require(to != owner, "ERC721: approval to current owner");
853 
854         require(
855             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
856             "ERC721: approve caller is not owner nor approved for all"
857         );
858 
859         _approve(to, tokenId);
860     }
861 
862     /**
863      * @dev See {IERC721-getApproved}.
864      */
865     function getApproved(uint256 tokenId) public view virtual override returns (address) {
866         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
867 
868         return _tokenApprovals[tokenId];
869     }
870 
871     /**
872      * @dev See {IERC721-setApprovalForAll}.
873      */
874     function setApprovalForAll(address operator, bool approved) public virtual override {
875         _setApprovalForAll(_msgSender(), operator, approved);
876     }
877 
878     /**
879      * @dev See {IERC721-isApprovedForAll}.
880      */
881     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
882         return _operatorApprovals[owner][operator];
883     }
884 
885     /**
886      * @dev See {IERC721-transferFrom}.
887      */
888     function transferFrom(
889         address from,
890         address to,
891         uint256 tokenId
892     ) public virtual override {
893         //solhint-disable-next-line max-line-length
894         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
895 
896         _transfer(from, to, tokenId);
897     }
898 
899     /**
900      * @dev See {IERC721-safeTransferFrom}.
901      */
902     function safeTransferFrom(
903         address from,
904         address to,
905         uint256 tokenId
906     ) public virtual override {
907         safeTransferFrom(from, to, tokenId, "");
908     }
909 
910     /**
911      * @dev See {IERC721-safeTransferFrom}.
912      */
913     function safeTransferFrom(
914         address from,
915         address to,
916         uint256 tokenId,
917         bytes memory _data
918     ) public virtual override {
919         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
920         _safeTransfer(from, to, tokenId, _data);
921     }
922 
923     /**
924      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
925      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
926      *
927      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
928      *
929      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
930      * implement alternative mechanisms to perform token transfer, such as signature-based.
931      *
932      * Requirements:
933      *
934      * - `from` cannot be the zero address.
935      * - `to` cannot be the zero address.
936      * - `tokenId` token must exist and be owned by `from`.
937      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
938      *
939      * Emits a {Transfer} event.
940      */
941     function _safeTransfer(
942         address from,
943         address to,
944         uint256 tokenId,
945         bytes memory _data
946     ) internal virtual {
947         _transfer(from, to, tokenId);
948         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
949     }
950 
951     /**
952      * @dev Returns whether `tokenId` exists.
953      *
954      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
955      *
956      * Tokens start existing when they are minted (`_mint`),
957      * and stop existing when they are burned (`_burn`).
958      */
959     function _exists(uint256 tokenId) internal view virtual returns (bool) {
960         return _owners[tokenId] != address(0);
961     }
962 
963     /**
964      * @dev Returns whether `spender` is allowed to manage `tokenId`.
965      *
966      * Requirements:
967      *
968      * - `tokenId` must exist.
969      */
970     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
971         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
972         address owner = ERC721.ownerOf(tokenId);
973         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
974     }
975 
976     /**
977      * @dev Safely mints `tokenId` and transfers it to `to`.
978      *
979      * Requirements:
980      *
981      * - `tokenId` must not exist.
982      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
983      *
984      * Emits a {Transfer} event.
985      */
986     function _safeMint(address to, uint256 tokenId) internal virtual {
987         _safeMint(to, tokenId, "");
988     }
989 
990     /**
991      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
992      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
993      */
994     function _safeMint(
995         address to,
996         uint256 tokenId,
997         bytes memory _data
998     ) internal virtual {
999         _mint(to, tokenId);
1000         require(
1001             _checkOnERC721Received(address(0), to, tokenId, _data),
1002             "ERC721: transfer to non ERC721Receiver implementer"
1003         );
1004     }
1005 
1006     /**
1007      * @dev Mints `tokenId` and transfers it to `to`.
1008      *
1009      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1010      *
1011      * Requirements:
1012      *
1013      * - `tokenId` must not exist.
1014      * - `to` cannot be the zero address.
1015      *
1016      * Emits a {Transfer} event.
1017      */
1018     function _mint(address to, uint256 tokenId) internal virtual {
1019         require(to != address(0), "ERC721: mint to the zero address");
1020         require(!_exists(tokenId), "ERC721: token already minted");
1021 
1022         _beforeTokenTransfer(address(0), to, tokenId);
1023 
1024         _balances[to] += 1;
1025         _owners[tokenId] = to;
1026 
1027         emit Transfer(address(0), to, tokenId);
1028 
1029         _afterTokenTransfer(address(0), to, tokenId);
1030     }
1031 
1032     /**
1033      * @dev Destroys `tokenId`.
1034      * The approval is cleared when the token is burned.
1035      *
1036      * Requirements:
1037      *
1038      * - `tokenId` must exist.
1039      *
1040      * Emits a {Transfer} event.
1041      */
1042     function _burn(uint256 tokenId) internal virtual {
1043         address owner = ERC721.ownerOf(tokenId);
1044 
1045         _beforeTokenTransfer(owner, address(0), tokenId);
1046 
1047         // Clear approvals
1048         _approve(address(0), tokenId);
1049 
1050         _balances[owner] -= 1;
1051         delete _owners[tokenId];
1052 
1053         emit Transfer(owner, address(0), tokenId);
1054 
1055         _afterTokenTransfer(owner, address(0), tokenId);
1056     }
1057 
1058     /**
1059      * @dev Transfers `tokenId` from `from` to `to`.
1060      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1061      *
1062      * Requirements:
1063      *
1064      * - `to` cannot be the zero address.
1065      * - `tokenId` token must be owned by `from`.
1066      *
1067      * Emits a {Transfer} event.
1068      */
1069     function _transfer(
1070         address from,
1071         address to,
1072         uint256 tokenId
1073     ) internal virtual {
1074         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1075         require(to != address(0), "ERC721: transfer to the zero address");
1076 
1077         _beforeTokenTransfer(from, to, tokenId);
1078 
1079         // Clear approvals from the previous owner
1080         _approve(address(0), tokenId);
1081 
1082         _balances[from] -= 1;
1083         _balances[to] += 1;
1084         _owners[tokenId] = to;
1085 
1086         emit Transfer(from, to, tokenId);
1087 
1088         _afterTokenTransfer(from, to, tokenId);
1089     }
1090 
1091     /**
1092      * @dev Approve `to` to operate on `tokenId`
1093      *
1094      * Emits a {Approval} event.
1095      */
1096     function _approve(address to, uint256 tokenId) internal virtual {
1097         _tokenApprovals[tokenId] = to;
1098         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1099     }
1100 
1101     /**
1102      * @dev Approve `operator` to operate on all of `owner` tokens
1103      *
1104      * Emits a {ApprovalForAll} event.
1105      */
1106     function _setApprovalForAll(
1107         address owner,
1108         address operator,
1109         bool approved
1110     ) internal virtual {
1111         require(owner != operator, "ERC721: approve to caller");
1112         _operatorApprovals[owner][operator] = approved;
1113         emit ApprovalForAll(owner, operator, approved);
1114     }
1115 
1116     /**
1117      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1118      * The call is not executed if the target address is not a contract.
1119      *
1120      * @param from address representing the previous owner of the given token ID
1121      * @param to target address that will receive the tokens
1122      * @param tokenId uint256 ID of the token to be transferred
1123      * @param _data bytes optional data to send along with the call
1124      * @return bool whether the call correctly returned the expected magic value
1125      */
1126     function _checkOnERC721Received(
1127         address from,
1128         address to,
1129         uint256 tokenId,
1130         bytes memory _data
1131     ) private returns (bool) {
1132         if (to.isContract()) {
1133             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1134                 return retval == IERC721Receiver.onERC721Received.selector;
1135             } catch (bytes memory reason) {
1136                 if (reason.length == 0) {
1137                     revert("ERC721: transfer to non ERC721Receiver implementer");
1138                 } else {
1139                     assembly {
1140                         revert(add(32, reason), mload(reason))
1141                     }
1142                 }
1143             }
1144         } else {
1145             return true;
1146         }
1147     }
1148 
1149     /**
1150      * @dev Hook that is called before any token transfer. This includes minting
1151      * and burning.
1152      *
1153      * Calling conditions:
1154      *
1155      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1156      * transferred to `to`.
1157      * - When `from` is zero, `tokenId` will be minted for `to`.
1158      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1159      * - `from` and `to` are never both zero.
1160      *
1161      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1162      */
1163     function _beforeTokenTransfer(
1164         address from,
1165         address to,
1166         uint256 tokenId
1167     ) internal virtual {}
1168 
1169     /**
1170      * @dev Hook that is called after any transfer of tokens. This includes
1171      * minting and burning.
1172      *
1173      * Calling conditions:
1174      *
1175      * - when `from` and `to` are both non-zero.
1176      * - `from` and `to` are never both zero.
1177      *
1178      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1179      */
1180     function _afterTokenTransfer(
1181         address from,
1182         address to,
1183         uint256 tokenId
1184     ) internal virtual {}
1185 }
1186 
1187 // File: contracts/PepeTheGan.sol
1188 
1189 
1190 
1191 pragma solidity >=0.7.0 <0.9.0;
1192 
1193 
1194 
1195 
1196 contract PepeTheGan is ERC721, Ownable {
1197   using Strings for uint256;
1198   using Counters for Counters.Counter;
1199 
1200   Counters.Counter private supply;
1201 
1202   mapping(address => uint256) public walletMints;
1203 
1204   string public uriPrefix = "ipfs://QmNtPH5zShsEh66hxhC23KWkZ8ToQy2mUrF5zR9y1AQZza/";
1205   string public uriSuffix = ".json";
1206   string public hiddenMetadataUri;
1207   
1208   uint256 public cost = 0 ether;
1209   uint256 public maxSupply = 999;
1210   uint256 public maxMintAmountPerTx = 1;
1211   uint256 public maxLimitPerWallet = 1;
1212 
1213   bool public paused = true;
1214   bool public revealed = true;
1215 
1216   constructor() ERC721("Pepe The Gan", "PTG") {}
1217 
1218   modifier mintCompliance(uint256 _mintAmount) {
1219     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1220     require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
1221     require(walletMints[msg.sender] + _mintAmount <= maxLimitPerWallet, "Max mint per wallet exceeded!");
1222 
1223     walletMints[msg.sender]+= _mintAmount;
1224     _;
1225   }
1226 
1227   function totalSupply() public view returns (uint256) {
1228     return supply.current();
1229   }
1230 
1231   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1232     require(!paused, "The contract is paused!");
1233     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1234 
1235     _mintLoop(msg.sender, _mintAmount);
1236   }
1237   
1238   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1239     _mintLoop(_receiver, _mintAmount);
1240   }
1241 
1242   function walletOfOwner(address _owner)
1243     public
1244     view
1245     returns (uint256[] memory)
1246   {
1247     uint256 ownerTokenCount = balanceOf(_owner);
1248     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1249     uint256 currentTokenId = 1;
1250     uint256 ownedTokenIndex = 0;
1251 
1252     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1253       address currentTokenOwner = ownerOf(currentTokenId);
1254 
1255       if (currentTokenOwner == _owner) {
1256         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1257 
1258         ownedTokenIndex++;
1259       }
1260 
1261       currentTokenId++;
1262     }
1263 
1264     return ownedTokenIds;
1265   }
1266 
1267   function tokenURI(uint256 _tokenId)
1268     public
1269     view
1270     virtual
1271     override
1272     returns (string memory)
1273   {
1274     require(
1275       _exists(_tokenId),
1276       "ERC721Metadata: URI query for nonexistent token"
1277     );
1278 
1279     if (revealed == false) {
1280       return hiddenMetadataUri;
1281     }
1282 
1283     string memory currentBaseURI = _baseURI();
1284     return bytes(currentBaseURI).length > 0
1285         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1286         : "";
1287   }
1288 
1289   function setRevealed(bool _state) public onlyOwner {
1290     revealed = _state;
1291   }
1292 
1293   function setCost(uint256 _cost) public onlyOwner {
1294     cost = _cost;
1295   }
1296 
1297   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1298     maxMintAmountPerTx = _maxMintAmountPerTx;
1299   }
1300   
1301   function setMaxLimitPerWallet(uint256 _maxLimitPerWallet) public onlyOwner {
1302     maxLimitPerWallet = _maxLimitPerWallet;
1303   }
1304 
1305   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1306     hiddenMetadataUri = _hiddenMetadataUri;
1307   }
1308 
1309   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1310     uriPrefix = _uriPrefix;
1311   }
1312 
1313   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1314     uriSuffix = _uriSuffix;
1315   }
1316 
1317   function setPaused(bool _state) public onlyOwner {
1318     paused = _state;
1319   }
1320 
1321   function withdraw() public onlyOwner {
1322    
1323     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1324     require(os);
1325     
1326   }
1327 
1328   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1329     for (uint256 i = 0; i < _mintAmount; i++) {
1330       supply.increment();
1331       _safeMint(_receiver, supply.current());
1332     }
1333   }
1334 
1335   function _baseURI() internal view virtual override returns (string memory) {
1336     return uriPrefix;
1337   }
1338 }