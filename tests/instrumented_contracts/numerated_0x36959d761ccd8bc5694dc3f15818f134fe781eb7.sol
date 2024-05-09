1 /**
2 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣀⣀⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
3 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡤⠒⠉⢀⣀⣤⣤⣄⣀⠈⠑⠢⢄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
4 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⠋⢀⣴⣾⠿⠛⠛⠛⢛⠿⢿⣶⣤⣀⠉⠒⠤⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
5 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡰⠁⢠⣾⠟⠁⠀⠀⠀⠀⠀⡄⠀⠈⠙⠿⣷⣦⣤⣀⣈⠉⠀⠒⠢⠤⢀⣀⠀⠀⠀⠀⠀⠀⠀⠀
6 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠜⠁⣰⣿⢏⠖⠐⠢⡀⠀⠀⠀⠈⠒⠒⠒⠊⠀⠉⠙⠛⠿⠿⣷⣶⣦⣤⣄⠈⠙⠢⡀⠀⠀⠀⠀⠀
7 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⠔⠁⣀⣼⡿⢣⠎⠀⠀⠀⣇⠀⠀⠀⠀⠀⠀⠀⢀⠔⠋⠉⠉⠓⢢⡀⠀⢹⠛⣿⢿⣦⡀⠙⡄⠀⠀⠀⠀
8 ⠀⠀⠀⠀⠀⠀⠀⠀⢠⠞⠁⢠⣾⡿⢋⠜⠁⠀⠀⠀⢀⠏⠀⡴⠚⠙⠒⡄⠀⠈⢦⠀⠀⠀⠀⢀⡇⣰⠃⠀⠀⢥⢻⣷⠀⢹⠀⠀⠀⠀
9 ⠀⠀⠀⠀⠀⠀⢀⠔⠁⢀⣼⡿⡏⠀⢸⡀⠀⠀⢀⡠⠞⠀⠘⣄⠀⠀⢀⠟⠀⠀⠀⠙⠂⠤⠤⣮⠜⠁⣀⡤⠔⠯⢿⢿⠀⢸⠀⠀⠀⠀
10 ⠀⠀⠀⠀⠀⡰⠋⢀⣴⣿⣋⠴⠁⠀⠀⠉⠀⠈⠁⠀⠀⠀⠀⠈⠁⠒⠉⠀⠀⠀⠀⣀⣠⡴⠊⠁⢐⡞⠁⠀⠀⢀⣾⡿⠀⡼⠀⠀⠀⠀
11 ⠀⠀⠀⠀⣰⠁⢠⣿⠟⠀⠀⠀⠀⢠⠖⠐⢦⠀⠀⠀⠀⣀⢀⣀⣠⡤⠴⠒⠢⠈⠉⠀⠈⠀⠀⠀⢨⣣⣀⣤⣶⣿⠟⠁⡰⠃⠀⠀⠀⠀
12 ⠀⠀⠀⠀⡏⠀⣿⡏⠉⢢⠀⠀⠀⠸⢤⣠⠞⠀⣀⡤⢺⡁⠀⠈⡿⠃⠀⣀⣰⡷⣿⣟⣗⣲⣭⠭⠿⠟⠛⠋⠉⢀⡤⠚⠁⠀⠀⠀⠀⠀
13 ⠀⠀⠀⠀⣇⠀⣿⣇⢀⡜⠀⠀⠀⠀⠀⠀⣠⠾⠁⠀⢉⡻⣶⣾⣶⣿⠿⠛⠛⠋⠉⣿⡇⠀⡤⠤⠤⠐⠒⠚⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀
14 ⠀⠀⠀⠀⠘⡀⠘⢿⣧⣀⠀⠀⠀⠀⠀⡼⠁⣀⡤⣶⣾⣿⣿⠋⠁⠀⠀⠀⠀⠀⠀⢻⣇⠀⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
15 ⠀⠀⠀⠀⠀⠙⢄⠀⠙⠿⢿⣶⣶⣖⣾⡿⠿⠟⠛⠉⠁⢸⢹⠀⠀⠀⠀⠀⠀⠀⠀⢸⣸⠀⢰⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
16 ⠀⠀⠀⠀⠀⠀⠀⠉⠒⢤⣄⡀⢀⣀⠀⠠⠤⠔⠒⢸⠀⢸⢸⠀⠀⡠⠀⠀⠀⠲⣄⠘⣿⡇⠘⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
17 ⠀⠀⠀⠀⠀⢀⡴⠒⠉⣉⣈⠉⠑⢦⡀⠀⠀⠀⠀⢸⠀⢸⣾⢀⠎⠀⠀⠀⠀⠀⠈⠳⢿⣷⠀⢱⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
18 ⠀⠀⣠⠔⠚⠁⣀⣴⢟⣋⠙⠻⣦⡀⠑⢄⠀⠀⠀⢸⠀⣸⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠘⡿⡇⠈⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
19 ⠀⡞⠀⣠⡶⢛⣋⠠⡁⢈⠗⣠⢼⢷⣄⡀⠑⡄⠀⡇⠀⣿⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⣷⠀⢰⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
20 ⢸⠀⢸⣿⡷⢧⣀⠇⠀⠀⠀⠑⠚⠀⠙⢷⡄⢸⢰⠃⢠⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⡿⡇⠘⡆⠀⠀⣠⠤⠒⠒⠒⠂⠤⣄⠀⠀
21 ⠈⡄⠘⢷⣄⣀⣀⣀⣰⣏⡹⠀⠀⠀⢀⣼⠇⢸⠛⠀⣼⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢳⢧⠀⢃⡴⠊⢀⣠⡶⣶⣶⢶⣤⣀⠉⢲
22 ⠀⠙⠦⣀⣈⠉⠉⢹⡏⣿⠛⠶⠶⠶⠟⠁⣠⠎⡇⢀⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⠀⠈⠀⣰⢿⣗⡄⠑⠊⠀⠉⣻⡇⠀
23 ⠀⠀⠀⠀⢈⠏⠀⣾⠀⣿⠀⠠⠀⠀⠐⠚⠁⢸⠁⢸⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⡇⠀⠘⣿⣄⣈⣐⣭⣦⣴⠾⠋⢀⡼
24 ⠀⠀⠀⠀⡞⠀⣼⠃⢰⡇⠀⡇⠀⠀⠀⠀⠀⢸⠀⢸⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⡇⢰⡤⣀⡈⠉⢉⡟⠹⣧⠀⢰⠋⠀
25 ⠀⠀⠀⢰⠁⢰⠏⠀⢸⡇⠀⡇⠀⠀⠀⠀⠀⢸⡀⢸⣸⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⡇⢸⠃⠀⢸⠁⢸⡇⠀⠹⣇⠀⡇⠀
26 ⠀⠀⠀⡟⠀⣿⠀⠀⢘⡇⠀⡇⠀⠀⠀⠀⠀⠀⡇⠈⢿⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⣻⠀⢸⠀⠀⠸⡆⠘⣧⠀⠀⣿⠀⡇⠀
27 ⠀⠀⠀⢷⠀⢿⣄⣀⣼⠇⢀⡇⠀⠀⠀⠀⠀⠀⠸⡄⠘⢿⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣰⣿⠇⢠⠇⠀⠀⠀⢣⡀⠹⠦⠾⠋⢀⠇⠀
28 ⠀⠀⠀⠈⢦⡀⠉⠉⠁⣀⠞⠀⠀⠀⠀⠀⠀⠀⠀⠙⢆⡀⠙⠿⣷⣶⣤⣤⣤⣤⣴⣶⣿⠟⠁⣠⠎⠀⠀⠀⠀⠀⠑⠤⠤⠤⠴⠋⠀⠀
29 ⠀⠀⠀⠀⠀⠈⠉⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠢⢄⣀⠈⠉⠉⠉⠉⠉⢁⣀⡤⠚⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
30 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠉⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
31 THIS IS NOT VODNIK
32  */
33 // SPDX-License-Identifier: MIT
34 
35 // File: @openzeppelin/contracts/utils/Strings.sol
36 
37 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
38 
39 pragma solidity ^0.8.0;
40 
41 /**
42  * @dev String operations.
43  */
44 library Strings {
45     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
46 
47     /**
48      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
49      */
50     function toString(uint256 value) internal pure returns (string memory) {
51         // Inspired by OraclizeAPI's implementation - MIT licence
52         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
53 
54         if (value == 0) {
55             return "0";
56         }
57         uint256 temp = value;
58         uint256 digits;
59         while (temp != 0) {
60             digits++;
61             temp /= 10;
62         }
63         bytes memory buffer = new bytes(digits);
64         while (value != 0) {
65             digits -= 1;
66             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
67             value /= 10;
68         }
69         return string(buffer);
70     }
71 
72     /**
73      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
74      */
75     function toHexString(uint256 value) internal pure returns (string memory) {
76         if (value == 0) {
77             return "0x00";
78         }
79         uint256 temp = value;
80         uint256 length = 0;
81         while (temp != 0) {
82             length++;
83             temp >>= 8;
84         }
85         return toHexString(value, length);
86     }
87 
88     /**
89      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
90      */
91     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
92         bytes memory buffer = new bytes(2 * length + 2);
93         buffer[0] = "0";
94         buffer[1] = "x";
95         for (uint256 i = 2 * length + 1; i > 1; --i) {
96             buffer[i] = _HEX_SYMBOLS[value & 0xf];
97             value >>= 4;
98         }
99         require(value == 0, "Strings: hex length insufficient");
100         return string(buffer);
101     }
102 }
103 
104 // File: @openzeppelin/contracts/utils/Context.sol
105 
106 
107 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
108 
109 pragma solidity ^0.8.0;
110 
111 /**
112  * @dev Provides information about the current execution context, including the
113  * sender of the transaction and its data. While these are generally available
114  * via msg.sender and msg.data, they should not be accessed in such a direct
115  * manner, since when dealing with meta-transactions the account sending and
116  * paying for execution may not be the actual sender (as far as an application
117  * is concerned).
118  *
119  * This contract is only required for intermediate, library-like contracts.
120  */
121 abstract contract Context {
122     function _msgSender() internal view virtual returns (address) {
123         return msg.sender;
124     }
125 
126     function _msgData() internal view virtual returns (bytes calldata) {
127         return msg.data;
128     }
129 }
130 
131 // File: @openzeppelin/contracts/utils/Address.sol
132 
133 
134 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
135 
136 pragma solidity ^0.8.1;
137 
138 /**
139  * @dev Collection of functions related to the address type
140  */
141 library Address {
142     /**
143      * @dev Returns true if `account` is a contract.
144      *
145      * [IMPORTANT]
146      * ====
147      * It is unsafe to assume that an address for which this function returns
148      * false is an externally-owned account (EOA) and not a contract.
149      *
150      * Among others, `isContract` will return false for the following
151      * types of addresses:
152      *
153      *  - an externally-owned account
154      *  - a contract in construction
155      *  - an address where a contract will be created
156      *  - an address where a contract lived, but was destroyed
157      * ====
158      *
159      * [IMPORTANT]
160      * ====
161      * You shouldn't rely on `isContract` to protect against flash loan attacks!
162      *
163      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
164      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
165      * constructor.
166      * ====
167      */
168     function isContract(address account) internal view returns (bool) {
169         // This method relies on extcodesize/address.code.length, which returns 0
170         // for contracts in construction, since the code is only stored at the end
171         // of the constructor execution.
172 
173         return account.code.length > 0;
174     }
175 
176     /**
177      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
178      * `recipient`, forwarding all available gas and reverting on errors.
179      *
180      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
181      * of certain opcodes, possibly making contracts go over the 2300 gas limit
182      * imposed by `transfer`, making them unable to receive funds via
183      * `transfer`. {sendValue} removes this limitation.
184      *
185      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
186      *
187      * IMPORTANT: because control is transferred to `recipient`, care must be
188      * taken to not create reentrancy vulnerabilities. Consider using
189      * {ReentrancyGuard} or the
190      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
191      */
192     function sendValue(address payable recipient, uint256 amount) internal {
193         require(address(this).balance >= amount, "Address: insufficient balance");
194 
195         (bool success, ) = recipient.call{value: amount}("");
196         require(success, "Address: unable to send value, recipient may have reverted");
197     }
198 
199     /**
200      * @dev Performs a Solidity function call using a low level `call`. A
201      * plain `call` is an unsafe replacement for a function call: use this
202      * function instead.
203      *
204      * If `target` reverts with a revert reason, it is bubbled up by this
205      * function (like regular Solidity function calls).
206      *
207      * Returns the raw returned data. To convert to the expected return value,
208      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
209      *
210      * Requirements:
211      *
212      * - `target` must be a contract.
213      * - calling `target` with `data` must not revert.
214      *
215      * _Available since v3.1._
216      */
217     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
218         return functionCall(target, data, "Address: low-level call failed");
219     }
220 
221     /**
222      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
223      * `errorMessage` as a fallback revert reason when `target` reverts.
224      *
225      * _Available since v3.1._
226      */
227     function functionCall(
228         address target,
229         bytes memory data,
230         string memory errorMessage
231     ) internal returns (bytes memory) {
232         return functionCallWithValue(target, data, 0, errorMessage);
233     }
234 
235     /**
236      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
237      * but also transferring `value` wei to `target`.
238      *
239      * Requirements:
240      *
241      * - the calling contract must have an ETH balance of at least `value`.
242      * - the called Solidity function must be `payable`.
243      *
244      * _Available since v3.1._
245      */
246     function functionCallWithValue(
247         address target,
248         bytes memory data,
249         uint256 value
250     ) internal returns (bytes memory) {
251         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
252     }
253 
254     /**
255      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
256      * with `errorMessage` as a fallback revert reason when `target` reverts.
257      *
258      * _Available since v3.1._
259      */
260     function functionCallWithValue(
261         address target,
262         bytes memory data,
263         uint256 value,
264         string memory errorMessage
265     ) internal returns (bytes memory) {
266         require(address(this).balance >= value, "Address: insufficient balance for call");
267         require(isContract(target), "Address: call to non-contract");
268 
269         (bool success, bytes memory returndata) = target.call{value: value}(data);
270         return verifyCallResult(success, returndata, errorMessage);
271     }
272 
273     /**
274      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
275      * but performing a static call.
276      *
277      * _Available since v3.3._
278      */
279     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
280         return functionStaticCall(target, data, "Address: low-level static call failed");
281     }
282 
283     /**
284      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
285      * but performing a static call.
286      *
287      * _Available since v3.3._
288      */
289     function functionStaticCall(
290         address target,
291         bytes memory data,
292         string memory errorMessage
293     ) internal view returns (bytes memory) {
294         require(isContract(target), "Address: static call to non-contract");
295 
296         (bool success, bytes memory returndata) = target.staticcall(data);
297         return verifyCallResult(success, returndata, errorMessage);
298     }
299 
300     /**
301      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
302      * but performing a delegate call.
303      *
304      * _Available since v3.4._
305      */
306     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
307         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
308     }
309 
310     /**
311      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
312      * but performing a delegate call.
313      *
314      * _Available since v3.4._
315      */
316     function functionDelegateCall(
317         address target,
318         bytes memory data,
319         string memory errorMessage
320     ) internal returns (bytes memory) {
321         require(isContract(target), "Address: delegate call to non-contract");
322 
323         (bool success, bytes memory returndata) = target.delegatecall(data);
324         return verifyCallResult(success, returndata, errorMessage);
325     }
326 
327     /**
328      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
329      * revert reason using the provided one.
330      *
331      * _Available since v4.3._
332      */
333     function verifyCallResult(
334         bool success,
335         bytes memory returndata,
336         string memory errorMessage
337     ) internal pure returns (bytes memory) {
338         if (success) {
339             return returndata;
340         } else {
341             // Look for revert reason and bubble it up if present
342             if (returndata.length > 0) {
343                 // The easiest way to bubble the revert reason is using memory via assembly
344 
345                 assembly {
346                     let returndata_size := mload(returndata)
347                     revert(add(32, returndata), returndata_size)
348                 }
349             } else {
350                 revert(errorMessage);
351             }
352         }
353     }
354 }
355 
356 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
357 
358 
359 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
360 
361 pragma solidity ^0.8.0;
362 
363 /**
364  * @title ERC721 token receiver interface
365  * @dev Interface for any contract that wants to support safeTransfers
366  * from ERC721 asset contracts.
367  */
368 interface IERC721Receiver {
369     /**
370      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
371      * by `operator` from `from`, this function is called.
372      *
373      * It must return its Solidity selector to confirm the token transfer.
374      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
375      *
376      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
377      */
378     function onERC721Received(
379         address operator,
380         address from,
381         uint256 tokenId,
382         bytes calldata data
383     ) external returns (bytes4);
384 }
385 
386 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
387 
388 
389 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
390 
391 pragma solidity ^0.8.0;
392 
393 /**
394  * @dev Interface of the ERC165 standard, as defined in the
395  * https://eips.ethereum.org/EIPS/eip-165[EIP].
396  *
397  * Implementers can declare support of contract interfaces, which can then be
398  * queried by others ({ERC165Checker}).
399  *
400  * For an implementation, see {ERC165}.
401  */
402 interface IERC165 {
403     /**
404      * @dev Returns true if this contract implements the interface defined by
405      * `interfaceId`. See the corresponding
406      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
407      * to learn more about how these ids are created.
408      *
409      * This function call must use less than 30 000 gas.
410      */
411     function supportsInterface(bytes4 interfaceId) external view returns (bool);
412 }
413 
414 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
415 
416 
417 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
418 
419 pragma solidity ^0.8.0;
420 
421 
422 /**
423  * @dev Implementation of the {IERC165} interface.
424  *
425  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
426  * for the additional interface id that will be supported. For example:
427  *
428  * ```solidity
429  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
430  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
431  * }
432  * ```
433  *
434  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
435  */
436 abstract contract ERC165 is IERC165 {
437     /**
438      * @dev See {IERC165-supportsInterface}.
439      */
440     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
441         return interfaceId == type(IERC165).interfaceId;
442     }
443 }
444 
445 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
446 
447 
448 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
449 
450 pragma solidity ^0.8.0;
451 
452 
453 /**
454  * @dev Required interface of an ERC721 compliant contract.
455  */
456 interface IERC721 is IERC165 {
457     /**
458      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
459      */
460     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
461 
462     /**
463      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
464      */
465     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
466 
467     /**
468      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
469      */
470     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
471 
472     /**
473      * @dev Returns the number of tokens in ``owner``'s account.
474      */
475     function balanceOf(address owner) external view returns (uint256 balance);
476 
477     /**
478      * @dev Returns the owner of the `tokenId` token.
479      *
480      * Requirements:
481      *
482      * - `tokenId` must exist.
483      */
484     function ownerOf(uint256 tokenId) external view returns (address owner);
485 
486     /**
487      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
488      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
489      *
490      * Requirements:
491      *
492      * - `from` cannot be the zero address.
493      * - `to` cannot be the zero address.
494      * - `tokenId` token must exist and be owned by `from`.
495      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
496      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
497      *
498      * Emits a {Transfer} event.
499      */
500     function safeTransferFrom(
501         address from,
502         address to,
503         uint256 tokenId
504     ) external;
505 
506     /**
507      * @dev Transfers `tokenId` token from `from` to `to`.
508      *
509      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
510      *
511      * Requirements:
512      *
513      * - `from` cannot be the zero address.
514      * - `to` cannot be the zero address.
515      * - `tokenId` token must be owned by `from`.
516      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
517      *
518      * Emits a {Transfer} event.
519      */
520     function transferFrom(
521         address from,
522         address to,
523         uint256 tokenId
524     ) external;
525 
526     /**
527      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
528      * The approval is cleared when the token is transferred.
529      *
530      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
531      *
532      * Requirements:
533      *
534      * - The caller must own the token or be an approved operator.
535      * - `tokenId` must exist.
536      *
537      * Emits an {Approval} event.
538      */
539     function approve(address to, uint256 tokenId) external;
540 
541     /**
542      * @dev Returns the account approved for `tokenId` token.
543      *
544      * Requirements:
545      *
546      * - `tokenId` must exist.
547      */
548     function getApproved(uint256 tokenId) external view returns (address operator);
549 
550     /**
551      * @dev Approve or remove `operator` as an operator for the caller.
552      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
553      *
554      * Requirements:
555      *
556      * - The `operator` cannot be the caller.
557      *
558      * Emits an {ApprovalForAll} event.
559      */
560     function setApprovalForAll(address operator, bool _approved) external;
561 
562     /**
563      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
564      *
565      * See {setApprovalForAll}
566      */
567     function isApprovedForAll(address owner, address operator) external view returns (bool);
568 
569     /**
570      * @dev Safely transfers `tokenId` token from `from` to `to`.
571      *
572      * Requirements:
573      *
574      * - `from` cannot be the zero address.
575      * - `to` cannot be the zero address.
576      * - `tokenId` token must exist and be owned by `from`.
577      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
578      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
579      *
580      * Emits a {Transfer} event.
581      */
582     function safeTransferFrom(
583         address from,
584         address to,
585         uint256 tokenId,
586         bytes calldata data
587     ) external;
588 }
589 
590 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
591 
592 
593 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
594 
595 pragma solidity ^0.8.0;
596 
597 
598 /**
599  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
600  * @dev See https://eips.ethereum.org/EIPS/eip-721
601  */
602 interface IERC721Metadata is IERC721 {
603     /**
604      * @dev Returns the token collection name.
605      */
606     function name() external view returns (string memory);
607 
608     /**
609      * @dev Returns the token collection symbol.
610      */
611     function symbol() external view returns (string memory);
612 
613     /**
614      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
615      */
616     function tokenURI(uint256 tokenId) external view returns (string memory);
617 }
618 
619 // File: contracts/new.sol
620 
621 
622 
623 
624 pragma solidity ^0.8.4;
625 
626 
627 
628 
629 
630 
631 
632 
633 error ApprovalCallerNotOwnerNorApproved();
634 error ApprovalQueryForNonexistentToken();
635 error ApproveToCaller();
636 error ApprovalToCurrentOwner();
637 error BalanceQueryForZeroAddress();
638 error MintToZeroAddress();
639 error MintZeroQuantity();
640 error OwnerQueryForNonexistentToken();
641 error TransferCallerNotOwnerNorApproved();
642 error TransferFromIncorrectOwner();
643 error TransferToNonERC721ReceiverImplementer();
644 error TransferToZeroAddress();
645 error URIQueryForNonexistentToken();
646 
647 /**
648  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
649  * the Metadata extension. Built to optimize for lower gas during batch mints.
650  *
651  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
652  *
653  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
654  *
655  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
656  */
657 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
658     using Address for address;
659     using Strings for uint256;
660 
661     // Compiler will pack this into a single 256bit word.
662     struct TokenOwnership {
663         // The address of the owner.
664         address addr;
665         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
666         uint64 startTimestamp;
667         // Whether the token has been burned.
668         bool burned;
669     }
670 
671     // Compiler will pack this into a single 256bit word.
672     struct AddressData {
673         // Realistically, 2**64-1 is more than enough.
674         uint64 balance;
675         // Keeps track of mint count with minimal overhead for tokenomics.
676         uint64 numberMinted;
677         // Keeps track of burn count with minimal overhead for tokenomics.
678         uint64 numberBurned;
679         // For miscellaneous variable(s) pertaining to the address
680         // (e.g. number of whitelist mint slots used).
681         // If there are multiple variables, please pack them into a uint64.
682         uint64 aux;
683     }
684 
685     // The tokenId of the next token to be minted.
686     uint256 internal _currentIndex;
687 
688     // The number of tokens burned.
689     uint256 internal _burnCounter;
690 
691     // Token name
692     string private _name;
693 
694     // Token symbol
695     string private _symbol;
696 
697     // Mapping from token ID to ownership details
698     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
699     mapping(uint256 => TokenOwnership) internal _ownerships;
700 
701     // Mapping owner address to address data
702     mapping(address => AddressData) private _addressData;
703 
704     // Mapping from token ID to approved address
705     mapping(uint256 => address) private _tokenApprovals;
706 
707     // Mapping from owner to operator approvals
708     mapping(address => mapping(address => bool)) private _operatorApprovals;
709 
710     constructor(string memory name_, string memory symbol_) {
711         _name = name_;
712         _symbol = symbol_;
713         _currentIndex = _startTokenId();
714     }
715 
716     /**
717      * To change the starting tokenId, please override this function.
718      */
719     function _startTokenId() internal view virtual returns (uint256) {
720         return 0;
721     }
722 
723     /**
724      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
725      */
726     function totalSupply() public view returns (uint256) {
727         // Counter underflow is impossible as _burnCounter cannot be incremented
728         // more than _currentIndex - _startTokenId() times
729         unchecked {
730             return _currentIndex - _burnCounter - _startTokenId();
731         }
732     }
733 
734     /**
735      * Returns the total amount of tokens minted in the contract.
736      */
737     function _totalMinted() internal view returns (uint256) {
738         // Counter underflow is impossible as _currentIndex does not decrement,
739         // and it is initialized to _startTokenId()
740         unchecked {
741             return _currentIndex - _startTokenId();
742         }
743     }
744 
745     /**
746      * @dev See {IERC165-supportsInterface}.
747      */
748     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
749         return
750             interfaceId == type(IERC721).interfaceId ||
751             interfaceId == type(IERC721Metadata).interfaceId ||
752             super.supportsInterface(interfaceId);
753     }
754 
755     /**
756      * @dev See {IERC721-balanceOf}.
757      */
758     function balanceOf(address owner) public view override returns (uint256) {
759         if (owner == address(0)) revert BalanceQueryForZeroAddress();
760         return uint256(_addressData[owner].balance);
761     }
762 
763     /**
764      * Returns the number of tokens minted by `owner`.
765      */
766     function _numberMinted(address owner) internal view returns (uint256) {
767         return uint256(_addressData[owner].numberMinted);
768     }
769 
770     /**
771      * Returns the number of tokens burned by or on behalf of `owner`.
772      */
773     function _numberBurned(address owner) internal view returns (uint256) {
774         return uint256(_addressData[owner].numberBurned);
775     }
776 
777     /**
778      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
779      */
780     function _getAux(address owner) internal view returns (uint64) {
781         return _addressData[owner].aux;
782     }
783 
784     /**
785      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
786      * If there are multiple variables, please pack them into a uint64.
787      */
788     function _setAux(address owner, uint64 aux) internal {
789         _addressData[owner].aux = aux;
790     }
791 
792     /**
793      * Gas spent here starts off proportional to the maximum mint batch size.
794      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
795      */
796     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
797         uint256 curr = tokenId;
798 
799         unchecked {
800             if (_startTokenId() <= curr && curr < _currentIndex) {
801                 TokenOwnership memory ownership = _ownerships[curr];
802                 if (!ownership.burned) {
803                     if (ownership.addr != address(0)) {
804                         return ownership;
805                     }
806                     // Invariant:
807                     // There will always be an ownership that has an address and is not burned
808                     // before an ownership that does not have an address and is not burned.
809                     // Hence, curr will not underflow.
810                     while (true) {
811                         curr--;
812                         ownership = _ownerships[curr];
813                         if (ownership.addr != address(0)) {
814                             return ownership;
815                         }
816                     }
817                 }
818             }
819         }
820         revert OwnerQueryForNonexistentToken();
821     }
822 
823     /**
824      * @dev See {IERC721-ownerOf}.
825      */
826     function ownerOf(uint256 tokenId) public view override returns (address) {
827         return _ownershipOf(tokenId).addr;
828     }
829 
830     /**
831      * @dev See {IERC721Metadata-name}.
832      */
833     function name() public view virtual override returns (string memory) {
834         return _name;
835     }
836 
837     /**
838      * @dev See {IERC721Metadata-symbol}.
839      */
840     function symbol() public view virtual override returns (string memory) {
841         return _symbol;
842     }
843 
844     /**
845      * @dev See {IERC721Metadata-tokenURI}.
846      */
847     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
848         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
849 
850         string memory baseURI = _baseURI();
851         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
852     }
853 
854     /**
855      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
856      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
857      * by default, can be overriden in child contracts.
858      */
859     function _baseURI() internal view virtual returns (string memory) {
860         return '';
861     }
862 
863     /**
864      * @dev See {IERC721-approve}.
865      */
866     function approve(address to, uint256 tokenId) public override {
867         address owner = ERC721A.ownerOf(tokenId);
868         if (to == owner) revert ApprovalToCurrentOwner();
869 
870         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
871             revert ApprovalCallerNotOwnerNorApproved();
872         }
873 
874         _approve(to, tokenId, owner);
875     }
876 
877     /**
878      * @dev See {IERC721-getApproved}.
879      */
880     function getApproved(uint256 tokenId) public view override returns (address) {
881         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
882 
883         return _tokenApprovals[tokenId];
884     }
885 
886     /**
887      * @dev See {IERC721-setApprovalForAll}.
888      */
889     function setApprovalForAll(address operator, bool approved) public virtual override {
890         if (operator == _msgSender()) revert ApproveToCaller();
891 
892         _operatorApprovals[_msgSender()][operator] = approved;
893         emit ApprovalForAll(_msgSender(), operator, approved);
894     }
895 
896     /**
897      * @dev See {IERC721-isApprovedForAll}.
898      */
899     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
900         return _operatorApprovals[owner][operator];
901     }
902 
903     /**
904      * @dev See {IERC721-transferFrom}.
905      */
906     function transferFrom(
907         address from,
908         address to,
909         uint256 tokenId
910     ) public virtual override {
911         _transfer(from, to, tokenId);
912     }
913 
914     /**
915      * @dev See {IERC721-safeTransferFrom}.
916      */
917     function safeTransferFrom(
918         address from,
919         address to,
920         uint256 tokenId
921     ) public virtual override {
922         safeTransferFrom(from, to, tokenId, '');
923     }
924 
925     /**
926      * @dev See {IERC721-safeTransferFrom}.
927      */
928     function safeTransferFrom(
929         address from,
930         address to,
931         uint256 tokenId,
932         bytes memory _data
933     ) public virtual override {
934         _transfer(from, to, tokenId);
935         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
936             revert TransferToNonERC721ReceiverImplementer();
937         }
938     }
939 
940     /**
941      * @dev Returns whether `tokenId` exists.
942      *
943      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
944      *
945      * Tokens start existing when they are minted (`_mint`),
946      */
947     function _exists(uint256 tokenId) internal view returns (bool) {
948         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
949             !_ownerships[tokenId].burned;
950     }
951 
952     function _safeMint(address to, uint256 quantity) internal {
953         _safeMint(to, quantity, '');
954     }
955 
956     /**
957      * @dev Safely mints `quantity` tokens and transfers them to `to`.
958      *
959      * Requirements:
960      *
961      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
962      * - `quantity` must be greater than 0.
963      *
964      * Emits a {Transfer} event.
965      */
966     function _safeMint(
967         address to,
968         uint256 quantity,
969         bytes memory _data
970     ) internal {
971         _mint(to, quantity, _data, true);
972     }
973 
974     /**
975      * @dev Mints `quantity` tokens and transfers them to `to`.
976      *
977      * Requirements:
978      *
979      * - `to` cannot be the zero address.
980      * - `quantity` must be greater than 0.
981      *
982      * Emits a {Transfer} event.
983      */
984     function _mint(
985         address to,
986         uint256 quantity,
987         bytes memory _data,
988         bool safe
989     ) internal {
990         uint256 startTokenId = _currentIndex;
991         if (to == address(0)) revert MintToZeroAddress();
992         if (quantity == 0) revert MintZeroQuantity();
993 
994         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
995 
996         // Overflows are incredibly unrealistic.
997         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
998         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
999         unchecked {
1000             _addressData[to].balance += uint64(quantity);
1001             _addressData[to].numberMinted += uint64(quantity);
1002 
1003             _ownerships[startTokenId].addr = to;
1004             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1005 
1006             uint256 updatedIndex = startTokenId;
1007             uint256 end = updatedIndex + quantity;
1008 
1009             if (safe && to.isContract()) {
1010                 do {
1011                     emit Transfer(address(0), to, updatedIndex);
1012                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1013                         revert TransferToNonERC721ReceiverImplementer();
1014                     }
1015                 } while (updatedIndex != end);
1016                 // Reentrancy protection
1017                 if (_currentIndex != startTokenId) revert();
1018             } else {
1019                 do {
1020                     emit Transfer(address(0), to, updatedIndex++);
1021                 } while (updatedIndex != end);
1022             }
1023             _currentIndex = updatedIndex;
1024         }
1025         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1026     }
1027 
1028     /**
1029      * @dev Transfers `tokenId` from `from` to `to`.
1030      *
1031      * Requirements:
1032      *
1033      * - `to` cannot be the zero address.
1034      * - `tokenId` token must be owned by `from`.
1035      *
1036      * Emits a {Transfer} event.
1037      */
1038     function _transfer(
1039         address from,
1040         address to,
1041         uint256 tokenId
1042     ) private {
1043         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1044 
1045         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1046 
1047         bool isApprovedOrOwner = (_msgSender() == from ||
1048             isApprovedForAll(from, _msgSender()) ||
1049             getApproved(tokenId) == _msgSender());
1050 
1051         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1052         if (to == address(0)) revert TransferToZeroAddress();
1053 
1054         _beforeTokenTransfers(from, to, tokenId, 1);
1055 
1056         // Clear approvals from the previous owner
1057         _approve(address(0), tokenId, from);
1058 
1059         // Underflow of the sender's balance is impossible because we check for
1060         // ownership above and the recipient's balance can't realistically overflow.
1061         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1062         unchecked {
1063             _addressData[from].balance -= 1;
1064             _addressData[to].balance += 1;
1065 
1066             TokenOwnership storage currSlot = _ownerships[tokenId];
1067             currSlot.addr = to;
1068             currSlot.startTimestamp = uint64(block.timestamp);
1069 
1070             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1071             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1072             uint256 nextTokenId = tokenId + 1;
1073             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1074             if (nextSlot.addr == address(0)) {
1075                 // This will suffice for checking _exists(nextTokenId),
1076                 // as a burned slot cannot contain the zero address.
1077                 if (nextTokenId != _currentIndex) {
1078                     nextSlot.addr = from;
1079                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1080                 }
1081             }
1082         }
1083 
1084         emit Transfer(from, to, tokenId);
1085         _afterTokenTransfers(from, to, tokenId, 1);
1086     }
1087 
1088     /**
1089      * @dev This is equivalent to _burn(tokenId, false)
1090      */
1091     function _burn(uint256 tokenId) internal virtual {
1092         _burn(tokenId, false);
1093     }
1094 
1095     /**
1096      * @dev Destroys `tokenId`.
1097      * The approval is cleared when the token is burned.
1098      *
1099      * Requirements:
1100      *
1101      * - `tokenId` must exist.
1102      *
1103      * Emits a {Transfer} event.
1104      */
1105     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1106         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1107 
1108         address from = prevOwnership.addr;
1109 
1110         if (approvalCheck) {
1111             bool isApprovedOrOwner = (_msgSender() == from ||
1112                 isApprovedForAll(from, _msgSender()) ||
1113                 getApproved(tokenId) == _msgSender());
1114 
1115             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1116         }
1117 
1118         _beforeTokenTransfers(from, address(0), tokenId, 1);
1119 
1120         // Clear approvals from the previous owner
1121         _approve(address(0), tokenId, from);
1122 
1123         // Underflow of the sender's balance is impossible because we check for
1124         // ownership above and the recipient's balance can't realistically overflow.
1125         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1126         unchecked {
1127             AddressData storage addressData = _addressData[from];
1128             addressData.balance -= 1;
1129             addressData.numberBurned += 1;
1130 
1131             // Keep track of who burned the token, and the timestamp of burning.
1132             TokenOwnership storage currSlot = _ownerships[tokenId];
1133             currSlot.addr = from;
1134             currSlot.startTimestamp = uint64(block.timestamp);
1135             currSlot.burned = true;
1136 
1137             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1138             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1139             uint256 nextTokenId = tokenId + 1;
1140             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1141             if (nextSlot.addr == address(0)) {
1142                 // This will suffice for checking _exists(nextTokenId),
1143                 // as a burned slot cannot contain the zero address.
1144                 if (nextTokenId != _currentIndex) {
1145                     nextSlot.addr = from;
1146                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1147                 }
1148             }
1149         }
1150 
1151         emit Transfer(from, address(0), tokenId);
1152         _afterTokenTransfers(from, address(0), tokenId, 1);
1153 
1154         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1155         unchecked {
1156             _burnCounter++;
1157         }
1158     }
1159 
1160     /**
1161      * @dev Approve `to` to operate on `tokenId`
1162      *
1163      * Emits a {Approval} event.
1164      */
1165     function _approve(
1166         address to,
1167         uint256 tokenId,
1168         address owner
1169     ) private {
1170         _tokenApprovals[tokenId] = to;
1171         emit Approval(owner, to, tokenId);
1172     }
1173 
1174     /**
1175      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1176      *
1177      * @param from address representing the previous owner of the given token ID
1178      * @param to target address that will receive the tokens
1179      * @param tokenId uint256 ID of the token to be transferred
1180      * @param _data bytes optional data to send along with the call
1181      * @return bool whether the call correctly returned the expected magic value
1182      */
1183     function _checkContractOnERC721Received(
1184         address from,
1185         address to,
1186         uint256 tokenId,
1187         bytes memory _data
1188     ) private returns (bool) {
1189         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1190             return retval == IERC721Receiver(to).onERC721Received.selector;
1191         } catch (bytes memory reason) {
1192             if (reason.length == 0) {
1193                 revert TransferToNonERC721ReceiverImplementer();
1194             } else {
1195                 assembly {
1196                     revert(add(32, reason), mload(reason))
1197                 }
1198             }
1199         }
1200     }
1201 
1202     /**
1203      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1204      * And also called before burning one token.
1205      *
1206      * startTokenId - the first token id to be transferred
1207      * quantity - the amount to be transferred
1208      *
1209      * Calling conditions:
1210      *
1211      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1212      * transferred to `to`.
1213      * - When `from` is zero, `tokenId` will be minted for `to`.
1214      * - When `to` is zero, `tokenId` will be burned by `from`.
1215      * - `from` and `to` are never both zero.
1216      */
1217     function _beforeTokenTransfers(
1218         address from,
1219         address to,
1220         uint256 startTokenId,
1221         uint256 quantity
1222     ) internal virtual {}
1223 
1224     /**
1225      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1226      * minting.
1227      * And also called after one token has been burned.
1228      *
1229      * startTokenId - the first token id to be transferred
1230      * quantity - the amount to be transferred
1231      *
1232      * Calling conditions:
1233      *
1234      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1235      * transferred to `to`.
1236      * - When `from` is zero, `tokenId` has been minted for `to`.
1237      * - When `to` is zero, `tokenId` has been burned by `from`.
1238      * - `from` and `to` are never both zero.
1239      */
1240     function _afterTokenTransfers(
1241         address from,
1242         address to,
1243         uint256 startTokenId,
1244         uint256 quantity
1245     ) internal virtual {}
1246 }
1247 
1248 abstract contract Ownable is Context {
1249     address private _owner;
1250 
1251     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1252 
1253     /**
1254      * @dev Initializes the contract setting the deployer as the initial owner.
1255      */
1256     constructor() {
1257         _transferOwnership(_msgSender());
1258     }
1259 
1260     /**
1261      * @dev Returns the address of the current owner.
1262      */
1263     function owner() public view virtual returns (address) {
1264         return _owner;
1265     }
1266 
1267     /**
1268      * @dev Throws if called by any account other than the owner.
1269      */
1270     modifier onlyOwner() {
1271         require(owner() == _msgSender() , "Ownable: caller is not the owner");
1272         _;
1273     }
1274 
1275     /**
1276      * @dev Leaves the contract without owner. It will not be possible to call
1277      * `onlyOwner` functions anymore. Can only be called by the current owner.
1278      *
1279      * NOTE: Renouncing ownership will leave the contract without an owner,
1280      * thereby removing any functionality that is only available to the owner.
1281      */
1282     function renounceOwnership() public virtual onlyOwner {
1283         _transferOwnership(address(0));
1284     }
1285 
1286     /**
1287      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1288      * Can only be called by the current owner.
1289      */
1290     function transferOwnership(address newOwner) public virtual onlyOwner {
1291         require(newOwner != address(0), "Ownable: new owner is the zero address");
1292         _transferOwnership(newOwner);
1293     }
1294 
1295     /**
1296      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1297      * Internal function without access restriction.
1298      */
1299     function _transferOwnership(address newOwner) internal virtual {
1300         address oldOwner = _owner;
1301         _owner = newOwner;
1302         emit OwnershipTransferred(oldOwner, newOwner);
1303     }
1304 }
1305 pragma solidity ^0.8.13;
1306 
1307 interface IOperatorFilterRegistry {
1308     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1309     function register(address registrant) external;
1310     function registerAndSubscribe(address registrant, address subscription) external;
1311     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1312     function updateOperator(address registrant, address operator, bool filtered) external;
1313     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1314     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1315     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1316     function subscribe(address registrant, address registrantToSubscribe) external;
1317     function unsubscribe(address registrant, bool copyExistingEntries) external;
1318     function subscriptionOf(address addr) external returns (address registrant);
1319     function subscribers(address registrant) external returns (address[] memory);
1320     function subscriberAt(address registrant, uint256 index) external returns (address);
1321     function copyEntriesOf(address registrant, address registrantToCopy) external;
1322     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1323     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1324     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1325     function filteredOperators(address addr) external returns (address[] memory);
1326     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1327     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1328     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1329     function isRegistered(address addr) external returns (bool);
1330     function codeHashOf(address addr) external returns (bytes32);
1331 }
1332 pragma solidity ^0.8.13;
1333 
1334 
1335 
1336 abstract contract OperatorFilterer {
1337     error OperatorNotAllowed(address operator);
1338 
1339     IOperatorFilterRegistry constant operatorFilterRegistry =
1340         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1341 
1342     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1343         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1344         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1345         // order for the modifier to filter addresses.
1346         if (address(operatorFilterRegistry).code.length > 0) {
1347             if (subscribe) {
1348                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1349             } else {
1350                 if (subscriptionOrRegistrantToCopy != address(0)) {
1351                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1352                 } else {
1353                     operatorFilterRegistry.register(address(this));
1354                 }
1355             }
1356         }
1357     }
1358 
1359     modifier onlyAllowedOperator(address from) virtual {
1360         // Check registry code length to facilitate testing in environments without a deployed registry.
1361         if (address(operatorFilterRegistry).code.length > 0) {
1362             // Allow spending tokens from addresses with balance
1363             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1364             // from an EOA.
1365             if (from == msg.sender) {
1366                 _;
1367                 return;
1368             }
1369             if (
1370                 !(
1371                     operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
1372                         && operatorFilterRegistry.isOperatorAllowed(address(this), from)
1373                 )
1374             ) {
1375                 revert OperatorNotAllowed(msg.sender);
1376             }
1377         }
1378         _;
1379     }
1380 }
1381 pragma solidity ^0.8.13;
1382 
1383 
1384 
1385 abstract contract DefaultOperatorFilterer is OperatorFilterer {
1386     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1387 
1388     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1389 }
1390     pragma solidity ^0.8.7;
1391     
1392     contract CryptoShroomz is ERC721A,DefaultOperatorFilterer , Ownable {
1393     using Strings for uint256;
1394 
1395 
1396   string private uriPrefix ;
1397   string private uriSuffix = ".json";
1398   string public hiddenURL;
1399 
1400   
1401   
1402 
1403   uint256 public cost = 0.003 ether;
1404   uint256 public whiteListCost = 0 ;
1405   
1406 
1407   uint16 public maxSupply = 2000;
1408   uint8 public maxMintAmountPerTx = 3;
1409   uint8 public maxMintAmountPerWallet = 3;
1410     uint8 public maxFreeMintAmountPerWallet = 1;
1411                                                              
1412   bool public WLpaused = true;
1413   bool public paused = true;
1414   bool public reveal =false;
1415   mapping (address => uint8) public NFTPerWLAddress;
1416    mapping (address => uint8) public NFTPerPublicAddress;
1417   mapping (address => bool) public isWhitelisted;
1418  
1419   
1420   
1421  
1422   
1423 
1424   constructor() ERC721A("CryptoShroomz", "SHROOMZ") {
1425   }
1426 
1427  
1428   
1429 
1430   
1431  
1432   function Mint(uint8 _mintAmount) external payable  {
1433      uint16 totalSupply = uint16(totalSupply());
1434      uint8 nft = NFTPerPublicAddress[msg.sender];
1435     require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
1436     require(_mintAmount + nft <= maxMintAmountPerWallet, "Exceeds max per Wallet.");
1437     require(_mintAmount  <= maxMintAmountPerTx, "Exceeds max per Wallet.");
1438 
1439     require(!paused, "The contract is paused!");
1440     
1441       if(nft >= maxFreeMintAmountPerWallet)
1442     {
1443     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1444     }
1445     else {
1446          uint8 costAmount = _mintAmount + nft;
1447         if(costAmount > maxFreeMintAmountPerWallet)
1448        {
1449         costAmount = costAmount - maxFreeMintAmountPerWallet;
1450         require(msg.value >= cost * costAmount, "Insufficient funds!");
1451        }
1452        
1453          
1454     }
1455     
1456 
1457 
1458     _safeMint(msg.sender , _mintAmount);
1459 
1460     NFTPerPublicAddress[msg.sender] = _mintAmount + nft;
1461      
1462      delete totalSupply;
1463      delete _mintAmount;
1464   }
1465   
1466   function Reserve(uint16 _mintAmount, address _receiver) external onlyOwner {
1467      uint16 totalSupply = uint16(totalSupply());
1468     require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
1469      _safeMint(_receiver , _mintAmount);
1470      delete _mintAmount;
1471      delete _receiver;
1472      delete totalSupply;
1473   }
1474 
1475   function  Airdrop(uint8 _amountPerAddress, address[] calldata addresses) external onlyOwner {
1476      uint16 totalSupply = uint16(totalSupply());
1477      uint totalAmount =   _amountPerAddress * addresses.length;
1478     require(totalSupply + totalAmount <= maxSupply, "Exceees max supply.");
1479      for (uint256 i = 0; i < addresses.length; i++) {
1480             _safeMint(addresses[i], _amountPerAddress);
1481         }
1482 
1483      delete _amountPerAddress;
1484      delete totalSupply;
1485   }
1486 
1487  
1488 
1489   function setMaxSupply(uint16 _maxSupply) external onlyOwner {
1490       maxSupply = _maxSupply;
1491   }
1492 
1493 
1494 
1495    
1496   function tokenURI(uint256 _tokenId)
1497     public
1498     view
1499     virtual
1500     override
1501     returns (string memory)
1502   {
1503     require(
1504       _exists(_tokenId),
1505       "ERC721Metadata: URI query for nonexistent token"
1506     );
1507     
1508   
1509 if ( reveal == false)
1510 {
1511     return hiddenURL;
1512 }
1513     
1514 
1515     string memory currentBaseURI = _baseURI();
1516     return bytes(currentBaseURI).length > 0
1517         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString() ,uriSuffix))
1518         : "";
1519   }
1520  
1521    function setWLPaused() external onlyOwner {
1522     WLpaused = !WLpaused;
1523   }
1524   function setWLCost(uint256 _cost) external onlyOwner {
1525     whiteListCost = _cost;
1526     delete _cost;
1527   }
1528 
1529 
1530 
1531  function setFreeMaxLimitPerAddress(uint8 _limit) external onlyOwner{
1532     maxFreeMintAmountPerWallet = _limit;
1533    delete _limit;
1534 
1535 }
1536 
1537     
1538   function addToPresaleWhitelist(address[] calldata entries) external onlyOwner {
1539         for(uint8 i = 0; i < entries.length; i++) {
1540             isWhitelisted[entries[i]] = true;
1541         }   
1542     }
1543 
1544     function removeFromPresaleWhitelist(address[] calldata entries) external onlyOwner {
1545         for(uint8 i = 0; i < entries.length; i++) {
1546              isWhitelisted[entries[i]] = false;
1547         }
1548     }
1549 
1550 function whitelistMint(uint8 _mintAmount) external payable {
1551         
1552     
1553         uint8 nft = NFTPerWLAddress[msg.sender];
1554         uint16 totalSupply = uint16(totalSupply());
1555        require(isWhitelisted[msg.sender],  "You are not whitelisted");
1556        require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
1557 
1558        require (nft + _mintAmount <= maxMintAmountPerWallet, "Exceeds max  limit  per address");
1559         require (_mintAmount <= maxMintAmountPerTx, "Exceeds max  limit  per tx");
1560       
1561 
1562 
1563     require(!WLpaused, "Whitelist minting is over!");
1564          if(nft >= maxFreeMintAmountPerWallet)
1565     {
1566     require(msg.value >= whiteListCost * _mintAmount, "Insufficient funds!");
1567     }
1568     else {
1569          uint8 costAmount = _mintAmount + nft;
1570         if(costAmount > maxFreeMintAmountPerWallet)
1571        {
1572         costAmount = costAmount - maxFreeMintAmountPerWallet;
1573         require(msg.value >= whiteListCost * costAmount, "Insufficient funds!");
1574        }
1575        
1576          
1577     }
1578     
1579     
1580 
1581      _safeMint(msg.sender , _mintAmount);
1582       NFTPerWLAddress[msg.sender] =nft + _mintAmount;
1583      
1584       delete _mintAmount;
1585        delete nft;
1586     
1587     }
1588 
1589   function setUriPrefix(string memory _uriPrefix) external onlyOwner {
1590     uriPrefix = _uriPrefix;
1591   }
1592    function setHiddenUri(string memory _uriPrefix) external onlyOwner {
1593     hiddenURL = _uriPrefix;
1594   }
1595 
1596 
1597   function setPaused() external onlyOwner {
1598     paused = !paused;
1599     WLpaused = true;
1600   }
1601 
1602   function setCost(uint _cost) external onlyOwner{
1603       cost = _cost;
1604 
1605   }
1606 
1607  function setRevealed() external onlyOwner{
1608      reveal = !reveal;
1609  }
1610 
1611   function setMaxMintAmountPerTx(uint8 _maxtx) external onlyOwner{
1612       maxMintAmountPerTx = _maxtx;
1613 
1614   }
1615 
1616   
1617   function setMaxMintAmountPerWallet(uint8 _maxtx) external onlyOwner{
1618       maxMintAmountPerWallet = _maxtx;
1619 
1620   }
1621 
1622  
1623 
1624   function withdraw() external onlyOwner {
1625   uint _balance = address(this).balance;
1626      payable(msg.sender).transfer(_balance ); 
1627        
1628   }
1629 
1630 
1631   function _baseURI() internal view  override returns (string memory) {
1632     return uriPrefix;
1633   }
1634    function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1635         super.transferFrom(from, to, tokenId);
1636     }
1637 
1638     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1639         super.safeTransferFrom(from, to, tokenId);
1640     }
1641 
1642     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1643         public
1644         override
1645         onlyAllowedOperator(from)
1646     {
1647         super.safeTransferFrom(from, to, tokenId, data);
1648     }
1649 }