1 /**
2 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⡠⢤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
3 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡴⠟⠃⠀⠀⠙⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀
4 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⠋⠀⠀⠀⠀⠀⠀⠘⣆⠀⠀⠀⠀⠀⠀⠀⠀
5 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠾⢛⠒⠀⠀⠀⠀⠀⠀⠀⢸⡆⠀⠀⠀⠀⠀⠀⠀
6 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣶⣄⡈⠓⢄⠠⡀⠀⠀⠀⣄⣷⠀⠀⠀⠀⠀⠀⠀
7 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⣷⠀⠈⠱⡄⠑⣌⠆⠀⠀⡜⢻⠀⠀⠀⠀⠀⠀⠀
8 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⡿⠳⡆⠐⢿⣆⠈⢿⠀⠀⡇⠘⡆⠀⠀⠀⠀⠀⠀
9 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⣿⣷⡇⠀⠀⠈⢆⠈⠆⢸⠀⠀⢣⠀⠀⠀⠀⠀⠀
10 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⣿⣿⣧⠀⠀⠈⢂⠀⡇⠀⠀⢨⠓⣄⠀⠀⠀⠀
11 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⣿⣿⣿⣦⣤⠖⡏⡸⠀⣀⡴⠋⠀⠈⠢⡀⠀⠀
12 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣾⠁⣹⣿⣿⣿⣷⣾⠽⠖⠊⢹⣀⠄⠀⠀⠀⠈⢣⡀
13 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡟⣇⣰⢫⢻⢉⠉⠀⣿⡆⠀⠀⡸⡏⠀⠀⠀⠀⠀⠀⢇
14 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢨⡇⡇⠈⢸⢸⢸⠀⠀⡇⡇⠀⠀⠁⠻⡄⡠⠂⠀⠀⠀⠘
15 ⢤⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠛⠓⡇⠀⠸⡆⢸⠀⢠⣿⠀⠀⠀⠀⣰⣿⣵⡆⠀⠀⠀⠀
16 ⠈⢻⣷⣦⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⡿⣦⣀⡇⠀⢧⡇⠀⠀⢺⡟⠀⠀⠀⢰⠉⣰⠟⠊⣠⠂⠀⡸
17 ⠀⠀⢻⣿⣿⣷⣦⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⢧⡙⠺⠿⡇⠀⠘⠇⠀⠀⢸⣧⠀⠀⢠⠃⣾⣌⠉⠩⠭⠍⣉⡇
18 ⠀⠀⠀⠻⣿⣿⣿⣿⣿⣦⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣞⣋⠀⠈⠀⡳⣧⠀⠀⠀⠀⠀⢸⡏⠀⠀⡞⢰⠉⠉⠉⠉⠉⠓⢻⠃
19 ⠀⠀⠀⠀⠹⣿⣿⣿⣿⣿⣿⣷⡄⠀⠀⢀⣀⠠⠤⣤⣤⠤⠞⠓⢠⠈⡆⠀⢣⣸⣾⠆⠀⠀⠀⠀⠀⢀⣀⡼⠁⡿⠈⣉⣉⣒⡒⠢⡼⠀
20 ⠀⠀⠀⠀⠀⠘⣿⣿⣿⣿⣿⣿⣿⣎⣽⣶⣤⡶⢋⣤⠃⣠⡦⢀⡼⢦⣾⡤⠚⣟⣁⣀⣀⣀⣀⠀⣀⣈⣀⣠⣾⣅⠀⠑⠂⠤⠌⣩⡇⠀
21 ⠀⠀⠀⠀⠀⠀⠘⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡁⣺⢁⣞⣉⡴⠟⡀⠀⠀⠀⠁⠸⡅⠀⠈⢷⠈⠏⠙⠀⢹⡛⠀⢉⠀⠀⠀⣀⣀⣼⡇⠀
22 ⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣿⣿⣿⣿⣿⣿⣿⣿⣽⣿⡟⢡⠖⣡⡴⠂⣀⣀⣀⣰⣁⣀⣀⣸⠀⠀⠀⠀⠈⠁⠀⠀⠈⠀⣠⠜⠋⣠⠁⠀
23 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢿⣿⣿⣿⡟⢿⣿⣿⣷⡟⢋⣥⣖⣉⠀⠈⢁⡀⠤⠚⠿⣷⡦⢀⣠⣀⠢⣄⣀⡠⠔⠋⠁⠀⣼⠃⠀⠀
24 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣿⣿⡄⠈⠻⣿⣿⢿⣛⣩⠤⠒⠉⠁⠀⠀⠀⠀⠀⠉⠒⢤⡀⠉⠁⠀⠀⠀⠀⠀⢀⡿⠀⠀⠀
25 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⢿⣤⣤⠴⠟⠋⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠑⠤⠀⠀⠀⠀⠀⢩⠇⠀⠀⠀
26 
27 ░░███╗░░██████╗░██████╗░███████╗  ██╗░░██╗░░██╗██╗░█████╗░██╗░░██╗██████╗░██████╗░░██████╗
28 ░████║░░╚════██╗╚════██╗╚════██║  ██║░░██║░██╔╝██║██╔══██╗██║░██╔╝╚════██╗██╔══██╗██╔════╝
29 ██╔██║░░░█████╔╝░█████╔╝░░░░██╔╝  ███████║██╔╝░██║██║░░╚═╝█████═╝░░█████╔╝██████╔╝╚█████╗░
30 ╚═╝██║░░░╚═══██╗░╚═══██╗░░░██╔╝░  ██╔══██║███████║██║░░██╗██╔═██╗░░╚═══██╗██╔══██╗░╚═══██╗
31 ███████╗██████╔╝██████╔╝░░██╔╝░░  ██║░░██║╚════██║╚█████╔╝██║░╚██╗██████╔╝██║░░██║██████╔╝
32 ╚══════╝╚═════╝░╚═════╝░░░╚═╝░░░  ╚═╝░░╚═╝░░░░░╚═╝░╚════╝░╚═╝░░╚═╝╚═════╝░╚═╝░░╚═╝╚═════╝░⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀                                                                   
33  */
34 // SPDX-License-Identifier: MIT
35 //Developer Info: carlogiovanni.eth
36 
37 
38 
39 // File: @openzeppelin/contracts/utils/Strings.sol
40 
41 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
42 
43 pragma solidity ^0.8.0;
44 
45 /**
46  * @dev String operations.
47  */
48 library Strings {
49     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
50 
51     /**
52      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
53      */
54     function toString(uint256 value) internal pure returns (string memory) {
55         // Inspired by OraclizeAPI's implementation - MIT licence
56         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
57 
58         if (value == 0) {
59             return "0";
60         }
61         uint256 temp = value;
62         uint256 digits;
63         while (temp != 0) {
64             digits++;
65             temp /= 10;
66         }
67         bytes memory buffer = new bytes(digits);
68         while (value != 0) {
69             digits -= 1;
70             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
71             value /= 10;
72         }
73         return string(buffer);
74     }
75 
76     /**
77      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
78      */
79     function toHexString(uint256 value) internal pure returns (string memory) {
80         if (value == 0) {
81             return "0x00";
82         }
83         uint256 temp = value;
84         uint256 length = 0;
85         while (temp != 0) {
86             length++;
87             temp >>= 8;
88         }
89         return toHexString(value, length);
90     }
91 
92     /**
93      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
94      */
95     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
96         bytes memory buffer = new bytes(2 * length + 2);
97         buffer[0] = "0";
98         buffer[1] = "x";
99         for (uint256 i = 2 * length + 1; i > 1; --i) {
100             buffer[i] = _HEX_SYMBOLS[value & 0xf];
101             value >>= 4;
102         }
103         require(value == 0, "Strings: hex length insufficient");
104         return string(buffer);
105     }
106 }
107 
108 // File: @openzeppelin/contracts/utils/Context.sol
109 
110 
111 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
112 
113 pragma solidity ^0.8.0;
114 
115 /**
116  * @dev Provides information about the current execution context, including the
117  * sender of the transaction and its data. While these are generally available
118  * via msg.sender and msg.data, they should not be accessed in such a direct
119  * manner, since when dealing with meta-transactions the account sending and
120  * paying for execution may not be the actual sender (as far as an application
121  * is concerned).
122  *
123  * This contract is only required for intermediate, library-like contracts.
124  */
125 abstract contract Context {
126     function _msgSender() internal view virtual returns (address) {
127         return msg.sender;
128     }
129 
130     function _msgData() internal view virtual returns (bytes calldata) {
131         return msg.data;
132     }
133 }
134 
135 // File: @openzeppelin/contracts/utils/Address.sol
136 
137 
138 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
139 
140 pragma solidity ^0.8.1;
141 
142 /**
143  * @dev Collection of functions related to the address type
144  */
145 library Address {
146     /**
147      * @dev Returns true if `account` is a contract.
148      *
149      * [IMPORTANT]
150      * ====
151      * It is unsafe to assume that an address for which this function returns
152      * false is an externally-owned account (EOA) and not a contract.
153      *
154      * Among others, `isContract` will return false for the following
155      * types of addresses:
156      *
157      *  - an externally-owned account
158      *  - a contract in construction
159      *  - an address where a contract will be created
160      *  - an address where a contract lived, but was destroyed
161      * ====
162      *
163      * [IMPORTANT]
164      * ====
165      * You shouldn't rely on `isContract` to protect against flash loan attacks!
166      *
167      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
168      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
169      * constructor.
170      * ====
171      */
172     function isContract(address account) internal view returns (bool) {
173         // This method relies on extcodesize/address.code.length, which returns 0
174         // for contracts in construction, since the code is only stored at the end
175         // of the constructor execution.
176 
177         return account.code.length > 0;
178     }
179 
180     /**
181      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
182      * `recipient`, forwarding all available gas and reverting on errors.
183      *
184      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
185      * of certain opcodes, possibly making contracts go over the 2300 gas limit
186      * imposed by `transfer`, making them unable to receive funds via
187      * `transfer`. {sendValue} removes this limitation.
188      *
189      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
190      *
191      * IMPORTANT: because control is transferred to `recipient`, care must be
192      * taken to not create reentrancy vulnerabilities. Consider using
193      * {ReentrancyGuard} or the
194      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
195      */
196     function sendValue(address payable recipient, uint256 amount) internal {
197         require(address(this).balance >= amount, "Address: insufficient balance");
198 
199         (bool success, ) = recipient.call{value: amount}("");
200         require(success, "Address: unable to send value, recipient may have reverted");
201     }
202 
203     /**
204      * @dev Performs a Solidity function call using a low level `call`. A
205      * plain `call` is an unsafe replacement for a function call: use this
206      * function instead.
207      *
208      * If `target` reverts with a revert reason, it is bubbled up by this
209      * function (like regular Solidity function calls).
210      *
211      * Returns the raw returned data. To convert to the expected return value,
212      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
213      *
214      * Requirements:
215      *
216      * - `target` must be a contract.
217      * - calling `target` with `data` must not revert.
218      *
219      * _Available since v3.1._
220      */
221     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
222         return functionCall(target, data, "Address: low-level call failed");
223     }
224 
225     /**
226      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
227      * `errorMessage` as a fallback revert reason when `target` reverts.
228      *
229      * _Available since v3.1._
230      */
231     function functionCall(
232         address target,
233         bytes memory data,
234         string memory errorMessage
235     ) internal returns (bytes memory) {
236         return functionCallWithValue(target, data, 0, errorMessage);
237     }
238 
239     /**
240      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
241      * but also transferring `value` wei to `target`.
242      *
243      * Requirements:
244      *
245      * - the calling contract must have an ETH balance of at least `value`.
246      * - the called Solidity function must be `payable`.
247      *
248      * _Available since v3.1._
249      */
250     function functionCallWithValue(
251         address target,
252         bytes memory data,
253         uint256 value
254     ) internal returns (bytes memory) {
255         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
256     }
257 
258     /**
259      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
260      * with `errorMessage` as a fallback revert reason when `target` reverts.
261      *
262      * _Available since v3.1._
263      */
264     function functionCallWithValue(
265         address target,
266         bytes memory data,
267         uint256 value,
268         string memory errorMessage
269     ) internal returns (bytes memory) {
270         require(address(this).balance >= value, "Address: insufficient balance for call");
271         require(isContract(target), "Address: call to non-contract");
272 
273         (bool success, bytes memory returndata) = target.call{value: value}(data);
274         return verifyCallResult(success, returndata, errorMessage);
275     }
276 
277     /**
278      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
279      * but performing a static call.
280      *
281      * _Available since v3.3._
282      */
283     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
284         return functionStaticCall(target, data, "Address: low-level static call failed");
285     }
286 
287     /**
288      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
289      * but performing a static call.
290      *
291      * _Available since v3.3._
292      */
293     function functionStaticCall(
294         address target,
295         bytes memory data,
296         string memory errorMessage
297     ) internal view returns (bytes memory) {
298         require(isContract(target), "Address: static call to non-contract");
299 
300         (bool success, bytes memory returndata) = target.staticcall(data);
301         return verifyCallResult(success, returndata, errorMessage);
302     }
303 
304     /**
305      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
306      * but performing a delegate call.
307      *
308      * _Available since v3.4._
309      */
310     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
311         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
312     }
313 
314     /**
315      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
316      * but performing a delegate call.
317      *
318      * _Available since v3.4._
319      */
320     function functionDelegateCall(
321         address target,
322         bytes memory data,
323         string memory errorMessage
324     ) internal returns (bytes memory) {
325         require(isContract(target), "Address: delegate call to non-contract");
326 
327         (bool success, bytes memory returndata) = target.delegatecall(data);
328         return verifyCallResult(success, returndata, errorMessage);
329     }
330 
331     /**
332      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
333      * revert reason using the provided one.
334      *
335      * _Available since v4.3._
336      */
337     function verifyCallResult(
338         bool success,
339         bytes memory returndata,
340         string memory errorMessage
341     ) internal pure returns (bytes memory) {
342         if (success) {
343             return returndata;
344         } else {
345             // Look for revert reason and bubble it up if present
346             if (returndata.length > 0) {
347                 // The easiest way to bubble the revert reason is using memory via assembly
348 
349                 assembly {
350                     let returndata_size := mload(returndata)
351                     revert(add(32, returndata), returndata_size)
352                 }
353             } else {
354                 revert(errorMessage);
355             }
356         }
357     }
358 }
359 
360 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
361 
362 
363 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
364 
365 pragma solidity ^0.8.0;
366 
367 /**
368  * @title ERC721 token receiver interface
369  * @dev Interface for any contract that wants to support safeTransfers
370  * from ERC721 asset contracts.
371  */
372 interface IERC721Receiver {
373     /**
374      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
375      * by `operator` from `from`, this function is called.
376      *
377      * It must return its Solidity selector to confirm the token transfer.
378      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
379      *
380      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
381      */
382     function onERC721Received(
383         address operator,
384         address from,
385         uint256 tokenId,
386         bytes calldata data
387     ) external returns (bytes4);
388 }
389 
390 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
391 
392 
393 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
394 
395 pragma solidity ^0.8.0;
396 
397 /**
398  * @dev Interface of the ERC165 standard, as defined in the
399  * https://eips.ethereum.org/EIPS/eip-165[EIP].
400  *
401  * Implementers can declare support of contract interfaces, which can then be
402  * queried by others ({ERC165Checker}).
403  *
404  * For an implementation, see {ERC165}.
405  */
406 interface IERC165 {
407     /**
408      * @dev Returns true if this contract implements the interface defined by
409      * `interfaceId`. See the corresponding
410      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
411      * to learn more about how these ids are created.
412      *
413      * This function call must use less than 30 000 gas.
414      */
415     function supportsInterface(bytes4 interfaceId) external view returns (bool);
416 }
417 
418 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
419 
420 
421 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
422 
423 pragma solidity ^0.8.0;
424 
425 
426 /**
427  * @dev Implementation of the {IERC165} interface.
428  *
429  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
430  * for the additional interface id that will be supported. For example:
431  *
432  * ```solidity
433  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
434  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
435  * }
436  * ```
437  *
438  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
439  */
440 abstract contract ERC165 is IERC165 {
441     /**
442      * @dev See {IERC165-supportsInterface}.
443      */
444     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
445         return interfaceId == type(IERC165).interfaceId;
446     }
447 }
448 
449 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
450 
451 
452 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
453 
454 pragma solidity ^0.8.0;
455 
456 
457 /**
458  * @dev Required interface of an ERC721 compliant contract.
459  */
460 interface IERC721 is IERC165 {
461     /**
462      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
463      */
464     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
465 
466     /**
467      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
468      */
469     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
470 
471     /**
472      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
473      */
474     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
475 
476     /**
477      * @dev Returns the number of tokens in ``owner``'s account.
478      */
479     function balanceOf(address owner) external view returns (uint256 balance);
480 
481     /**
482      * @dev Returns the owner of the `tokenId` token.
483      *
484      * Requirements:
485      *
486      * - `tokenId` must exist.
487      */
488     function ownerOf(uint256 tokenId) external view returns (address owner);
489 
490     /**
491      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
492      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
493      *
494      * Requirements:
495      *
496      * - `from` cannot be the zero address.
497      * - `to` cannot be the zero address.
498      * - `tokenId` token must exist and be owned by `from`.
499      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
500      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
501      *
502      * Emits a {Transfer} event.
503      */
504     function safeTransferFrom(
505         address from,
506         address to,
507         uint256 tokenId
508     ) external;
509 
510     /**
511      * @dev Transfers `tokenId` token from `from` to `to`.
512      *
513      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
514      *
515      * Requirements:
516      *
517      * - `from` cannot be the zero address.
518      * - `to` cannot be the zero address.
519      * - `tokenId` token must be owned by `from`.
520      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
521      *
522      * Emits a {Transfer} event.
523      */
524     function transferFrom(
525         address from,
526         address to,
527         uint256 tokenId
528     ) external;
529 
530     /**
531      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
532      * The approval is cleared when the token is transferred.
533      *
534      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
535      *
536      * Requirements:
537      *
538      * - The caller must own the token or be an approved operator.
539      * - `tokenId` must exist.
540      *
541      * Emits an {Approval} event.
542      */
543     function approve(address to, uint256 tokenId) external;
544 
545     /**
546      * @dev Returns the account approved for `tokenId` token.
547      *
548      * Requirements:
549      *
550      * - `tokenId` must exist.
551      */
552     function getApproved(uint256 tokenId) external view returns (address operator);
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
567      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
568      *
569      * See {setApprovalForAll}
570      */
571     function isApprovedForAll(address owner, address operator) external view returns (bool);
572 
573     /**
574      * @dev Safely transfers `tokenId` token from `from` to `to`.
575      *
576      * Requirements:
577      *
578      * - `from` cannot be the zero address.
579      * - `to` cannot be the zero address.
580      * - `tokenId` token must exist and be owned by `from`.
581      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
582      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
583      *
584      * Emits a {Transfer} event.
585      */
586     function safeTransferFrom(
587         address from,
588         address to,
589         uint256 tokenId,
590         bytes calldata data
591     ) external;
592 }
593 
594 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
595 
596 
597 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
598 
599 pragma solidity ^0.8.0;
600 
601 
602 /**
603  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
604  * @dev See https://eips.ethereum.org/EIPS/eip-721
605  */
606 interface IERC721Metadata is IERC721 {
607     /**
608      * @dev Returns the token collection name.
609      */
610     function name() external view returns (string memory);
611 
612     /**
613      * @dev Returns the token collection symbol.
614      */
615     function symbol() external view returns (string memory);
616 
617     /**
618      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
619      */
620     function tokenURI(uint256 tokenId) external view returns (string memory);
621 }
622 
623 // File: contracts/new.sol
624 
625 
626 
627 
628 pragma solidity ^0.8.4;
629 
630 
631 
632 
633 
634 
635 
636 
637 error ApprovalCallerNotOwnerNorApproved();
638 error ApprovalQueryForNonexistentToken();
639 error ApproveToCaller();
640 error ApprovalToCurrentOwner();
641 error BalanceQueryForZeroAddress();
642 error MintToZeroAddress();
643 error MintZeroQuantity();
644 error OwnerQueryForNonexistentToken();
645 error TransferCallerNotOwnerNorApproved();
646 error TransferFromIncorrectOwner();
647 error TransferToNonERC721ReceiverImplementer();
648 error TransferToZeroAddress();
649 error URIQueryForNonexistentToken();
650 
651 /**
652  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
653  * the Metadata extension. Built to optimize for lower gas during batch mints.
654  *
655  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
656  *
657  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
658  *
659  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
660  */
661 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
662     using Address for address;
663     using Strings for uint256;
664 
665     // Compiler will pack this into a single 256bit word.
666     struct TokenOwnership {
667         // The address of the owner.
668         address addr;
669         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
670         uint64 startTimestamp;
671         // Whether the token has been burned.
672         bool burned;
673     }
674 
675     // Compiler will pack this into a single 256bit word.
676     struct AddressData {
677         // Realistically, 2**64-1 is more than enough.
678         uint64 balance;
679         // Keeps track of mint count with minimal overhead for tokenomics.
680         uint64 numberMinted;
681         // Keeps track of burn count with minimal overhead for tokenomics.
682         uint64 numberBurned;
683         // For miscellaneous variable(s) pertaining to the address
684         // (e.g. number of whitelist mint slots used).
685         // If there are multiple variables, please pack them into a uint64.
686         uint64 aux;
687     }
688 
689     // The tokenId of the next token to be minted.
690     uint256 internal _currentIndex;
691 
692     // The number of tokens burned.
693     uint256 internal _burnCounter;
694 
695     // Token name
696     string private _name;
697 
698     // Token symbol
699     string private _symbol;
700 
701     // Mapping from token ID to ownership details
702     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
703     mapping(uint256 => TokenOwnership) internal _ownerships;
704 
705     // Mapping owner address to address data
706     mapping(address => AddressData) private _addressData;
707 
708     // Mapping from token ID to approved address
709     mapping(uint256 => address) private _tokenApprovals;
710 
711     // Mapping from owner to operator approvals
712     mapping(address => mapping(address => bool)) private _operatorApprovals;
713 
714     constructor(string memory name_, string memory symbol_) {
715         _name = name_;
716         _symbol = symbol_;
717         _currentIndex = _startTokenId();
718     }
719 
720     /**
721      * To change the starting tokenId, please override this function.
722      */
723     function _startTokenId() internal view virtual returns (uint256) {
724         return 0;
725     }
726 
727     /**
728      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
729      */
730     function totalSupply() public view returns (uint256) {
731         // Counter underflow is impossible as _burnCounter cannot be incremented
732         // more than _currentIndex - _startTokenId() times
733         unchecked {
734             return _currentIndex - _burnCounter - _startTokenId();
735         }
736     }
737 
738     /**
739      * Returns the total amount of tokens minted in the contract.
740      */
741     function _totalMinted() internal view returns (uint256) {
742         // Counter underflow is impossible as _currentIndex does not decrement,
743         // and it is initialized to _startTokenId()
744         unchecked {
745             return _currentIndex - _startTokenId();
746         }
747     }
748 
749     /**
750      * @dev See {IERC165-supportsInterface}.
751      */
752     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
753         return
754             interfaceId == type(IERC721).interfaceId ||
755             interfaceId == type(IERC721Metadata).interfaceId ||
756             super.supportsInterface(interfaceId);
757     }
758 
759     /**
760      * @dev See {IERC721-balanceOf}.
761      */
762     function balanceOf(address owner) public view override returns (uint256) {
763         if (owner == address(0)) revert BalanceQueryForZeroAddress();
764         return uint256(_addressData[owner].balance);
765     }
766 
767     /**
768      * Returns the number of tokens minted by `owner`.
769      */
770     function _numberMinted(address owner) internal view returns (uint256) {
771         return uint256(_addressData[owner].numberMinted);
772     }
773 
774     /**
775      * Returns the number of tokens burned by or on behalf of `owner`.
776      */
777     function _numberBurned(address owner) internal view returns (uint256) {
778         return uint256(_addressData[owner].numberBurned);
779     }
780 
781     /**
782      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
783      */
784     function _getAux(address owner) internal view returns (uint64) {
785         return _addressData[owner].aux;
786     }
787 
788     /**
789      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
790      * If there are multiple variables, please pack them into a uint64.
791      */
792     function _setAux(address owner, uint64 aux) internal {
793         _addressData[owner].aux = aux;
794     }
795 
796     /**
797      * Gas spent here starts off proportional to the maximum mint batch size.
798      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
799      */
800     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
801         uint256 curr = tokenId;
802 
803         unchecked {
804             if (_startTokenId() <= curr && curr < _currentIndex) {
805                 TokenOwnership memory ownership = _ownerships[curr];
806                 if (!ownership.burned) {
807                     if (ownership.addr != address(0)) {
808                         return ownership;
809                     }
810                     // Invariant:
811                     // There will always be an ownership that has an address and is not burned
812                     // before an ownership that does not have an address and is not burned.
813                     // Hence, curr will not underflow.
814                     while (true) {
815                         curr--;
816                         ownership = _ownerships[curr];
817                         if (ownership.addr != address(0)) {
818                             return ownership;
819                         }
820                     }
821                 }
822             }
823         }
824         revert OwnerQueryForNonexistentToken();
825     }
826 
827     /**
828      * @dev See {IERC721-ownerOf}.
829      */
830     function ownerOf(uint256 tokenId) public view override returns (address) {
831         return _ownershipOf(tokenId).addr;
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
852         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
853 
854         string memory baseURI = _baseURI();
855         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
856     }
857 
858     /**
859      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
860      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
861      * by default, can be overriden in child contracts.
862      */
863     function _baseURI() internal view virtual returns (string memory) {
864         return '';
865     }
866 
867     /**
868      * @dev See {IERC721-approve}.
869      */
870     function approve(address to, uint256 tokenId) public override {
871         address owner = ERC721A.ownerOf(tokenId);
872         if (to == owner) revert ApprovalToCurrentOwner();
873 
874         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
875             revert ApprovalCallerNotOwnerNorApproved();
876         }
877 
878         _approve(to, tokenId, owner);
879     }
880 
881     /**
882      * @dev See {IERC721-getApproved}.
883      */
884     function getApproved(uint256 tokenId) public view override returns (address) {
885         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
886 
887         return _tokenApprovals[tokenId];
888     }
889 
890     /**
891      * @dev See {IERC721-setApprovalForAll}.
892      */
893     function setApprovalForAll(address operator, bool approved) public virtual override {
894         if (operator == _msgSender()) revert ApproveToCaller();
895 
896         _operatorApprovals[_msgSender()][operator] = approved;
897         emit ApprovalForAll(_msgSender(), operator, approved);
898     }
899 
900     /**
901      * @dev See {IERC721-isApprovedForAll}.
902      */
903     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
904         return _operatorApprovals[owner][operator];
905     }
906 
907     /**
908      * @dev See {IERC721-transferFrom}.
909      */
910     function transferFrom(
911         address from,
912         address to,
913         uint256 tokenId
914     ) public virtual override {
915         _transfer(from, to, tokenId);
916     }
917 
918     /**
919      * @dev See {IERC721-safeTransferFrom}.
920      */
921     function safeTransferFrom(
922         address from,
923         address to,
924         uint256 tokenId
925     ) public virtual override {
926         safeTransferFrom(from, to, tokenId, '');
927     }
928 
929     /**
930      * @dev See {IERC721-safeTransferFrom}.
931      */
932     function safeTransferFrom(
933         address from,
934         address to,
935         uint256 tokenId,
936         bytes memory _data
937     ) public virtual override {
938         _transfer(from, to, tokenId);
939         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
940             revert TransferToNonERC721ReceiverImplementer();
941         }
942     }
943 
944     /**
945      * @dev Returns whether `tokenId` exists.
946      *
947      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
948      *
949      * Tokens start existing when they are minted (`_mint`),
950      */
951     function _exists(uint256 tokenId) internal view returns (bool) {
952         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
953             !_ownerships[tokenId].burned;
954     }
955 
956     function _safeMint(address to, uint256 quantity) internal {
957         _safeMint(to, quantity, '');
958     }
959 
960     /**
961      * @dev Safely mints `quantity` tokens and transfers them to `to`.
962      *
963      * Requirements:
964      *
965      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
966      * - `quantity` must be greater than 0.
967      *
968      * Emits a {Transfer} event.
969      */
970     function _safeMint(
971         address to,
972         uint256 quantity,
973         bytes memory _data
974     ) internal {
975         _mint(to, quantity, _data, true);
976     }
977 
978     /**
979      * @dev Mints `quantity` tokens and transfers them to `to`.
980      *
981      * Requirements:
982      *
983      * - `to` cannot be the zero address.
984      * - `quantity` must be greater than 0.
985      *
986      * Emits a {Transfer} event.
987      */
988     function _mint(
989         address to,
990         uint256 quantity,
991         bytes memory _data,
992         bool safe
993     ) internal {
994         uint256 startTokenId = _currentIndex;
995         if (to == address(0)) revert MintToZeroAddress();
996         if (quantity == 0) revert MintZeroQuantity();
997 
998         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
999 
1000         // Overflows are incredibly unrealistic.
1001         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1002         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1003         unchecked {
1004             _addressData[to].balance += uint64(quantity);
1005             _addressData[to].numberMinted += uint64(quantity);
1006 
1007             _ownerships[startTokenId].addr = to;
1008             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1009 
1010             uint256 updatedIndex = startTokenId;
1011             uint256 end = updatedIndex + quantity;
1012 
1013             if (safe && to.isContract()) {
1014                 do {
1015                     emit Transfer(address(0), to, updatedIndex);
1016                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1017                         revert TransferToNonERC721ReceiverImplementer();
1018                     }
1019                 } while (updatedIndex != end);
1020                 // Reentrancy protection
1021                 if (_currentIndex != startTokenId) revert();
1022             } else {
1023                 do {
1024                     emit Transfer(address(0), to, updatedIndex++);
1025                 } while (updatedIndex != end);
1026             }
1027             _currentIndex = updatedIndex;
1028         }
1029         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1030     }
1031 
1032     /**
1033      * @dev Transfers `tokenId` from `from` to `to`.
1034      *
1035      * Requirements:
1036      *
1037      * - `to` cannot be the zero address.
1038      * - `tokenId` token must be owned by `from`.
1039      *
1040      * Emits a {Transfer} event.
1041      */
1042     function _transfer(
1043         address from,
1044         address to,
1045         uint256 tokenId
1046     ) private {
1047         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1048 
1049         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1050 
1051         bool isApprovedOrOwner = (_msgSender() == from ||
1052             isApprovedForAll(from, _msgSender()) ||
1053             getApproved(tokenId) == _msgSender());
1054 
1055         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1056         if (to == address(0)) revert TransferToZeroAddress();
1057 
1058         _beforeTokenTransfers(from, to, tokenId, 1);
1059 
1060         // Clear approvals from the previous owner
1061         _approve(address(0), tokenId, from);
1062 
1063         // Underflow of the sender's balance is impossible because we check for
1064         // ownership above and the recipient's balance can't realistically overflow.
1065         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1066         unchecked {
1067             _addressData[from].balance -= 1;
1068             _addressData[to].balance += 1;
1069 
1070             TokenOwnership storage currSlot = _ownerships[tokenId];
1071             currSlot.addr = to;
1072             currSlot.startTimestamp = uint64(block.timestamp);
1073 
1074             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1075             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1076             uint256 nextTokenId = tokenId + 1;
1077             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1078             if (nextSlot.addr == address(0)) {
1079                 // This will suffice for checking _exists(nextTokenId),
1080                 // as a burned slot cannot contain the zero address.
1081                 if (nextTokenId != _currentIndex) {
1082                     nextSlot.addr = from;
1083                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1084                 }
1085             }
1086         }
1087 
1088         emit Transfer(from, to, tokenId);
1089         _afterTokenTransfers(from, to, tokenId, 1);
1090     }
1091 
1092     /**
1093      * @dev This is equivalent to _burn(tokenId, false)
1094      */
1095     function _burn(uint256 tokenId) internal virtual {
1096         _burn(tokenId, false);
1097     }
1098 
1099     /**
1100      * @dev Destroys `tokenId`.
1101      * The approval is cleared when the token is burned.
1102      *
1103      * Requirements:
1104      *
1105      * - `tokenId` must exist.
1106      *
1107      * Emits a {Transfer} event.
1108      */
1109     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1110         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1111 
1112         address from = prevOwnership.addr;
1113 
1114         if (approvalCheck) {
1115             bool isApprovedOrOwner = (_msgSender() == from ||
1116                 isApprovedForAll(from, _msgSender()) ||
1117                 getApproved(tokenId) == _msgSender());
1118 
1119             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1120         }
1121 
1122         _beforeTokenTransfers(from, address(0), tokenId, 1);
1123 
1124         // Clear approvals from the previous owner
1125         _approve(address(0), tokenId, from);
1126 
1127         // Underflow of the sender's balance is impossible because we check for
1128         // ownership above and the recipient's balance can't realistically overflow.
1129         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1130         unchecked {
1131             AddressData storage addressData = _addressData[from];
1132             addressData.balance -= 1;
1133             addressData.numberBurned += 1;
1134 
1135             // Keep track of who burned the token, and the timestamp of burning.
1136             TokenOwnership storage currSlot = _ownerships[tokenId];
1137             currSlot.addr = from;
1138             currSlot.startTimestamp = uint64(block.timestamp);
1139             currSlot.burned = true;
1140 
1141             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1142             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1143             uint256 nextTokenId = tokenId + 1;
1144             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1145             if (nextSlot.addr == address(0)) {
1146                 // This will suffice for checking _exists(nextTokenId),
1147                 // as a burned slot cannot contain the zero address.
1148                 if (nextTokenId != _currentIndex) {
1149                     nextSlot.addr = from;
1150                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1151                 }
1152             }
1153         }
1154 
1155         emit Transfer(from, address(0), tokenId);
1156         _afterTokenTransfers(from, address(0), tokenId, 1);
1157 
1158         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1159         unchecked {
1160             _burnCounter++;
1161         }
1162     }
1163 
1164     /**
1165      * @dev Approve `to` to operate on `tokenId`
1166      *
1167      * Emits a {Approval} event.
1168      */
1169     function _approve(
1170         address to,
1171         uint256 tokenId,
1172         address owner
1173     ) private {
1174         _tokenApprovals[tokenId] = to;
1175         emit Approval(owner, to, tokenId);
1176     }
1177 
1178     /**
1179      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1180      *
1181      * @param from address representing the previous owner of the given token ID
1182      * @param to target address that will receive the tokens
1183      * @param tokenId uint256 ID of the token to be transferred
1184      * @param _data bytes optional data to send along with the call
1185      * @return bool whether the call correctly returned the expected magic value
1186      */
1187     function _checkContractOnERC721Received(
1188         address from,
1189         address to,
1190         uint256 tokenId,
1191         bytes memory _data
1192     ) private returns (bool) {
1193         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1194             return retval == IERC721Receiver(to).onERC721Received.selector;
1195         } catch (bytes memory reason) {
1196             if (reason.length == 0) {
1197                 revert TransferToNonERC721ReceiverImplementer();
1198             } else {
1199                 assembly {
1200                     revert(add(32, reason), mload(reason))
1201                 }
1202             }
1203         }
1204     }
1205 
1206     /**
1207      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1208      * And also called before burning one token.
1209      *
1210      * startTokenId - the first token id to be transferred
1211      * quantity - the amount to be transferred
1212      *
1213      * Calling conditions:
1214      *
1215      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1216      * transferred to `to`.
1217      * - When `from` is zero, `tokenId` will be minted for `to`.
1218      * - When `to` is zero, `tokenId` will be burned by `from`.
1219      * - `from` and `to` are never both zero.
1220      */
1221     function _beforeTokenTransfers(
1222         address from,
1223         address to,
1224         uint256 startTokenId,
1225         uint256 quantity
1226     ) internal virtual {}
1227 
1228     /**
1229      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1230      * minting.
1231      * And also called after one token has been burned.
1232      *
1233      * startTokenId - the first token id to be transferred
1234      * quantity - the amount to be transferred
1235      *
1236      * Calling conditions:
1237      *
1238      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1239      * transferred to `to`.
1240      * - When `from` is zero, `tokenId` has been minted for `to`.
1241      * - When `to` is zero, `tokenId` has been burned by `from`.
1242      * - `from` and `to` are never both zero.
1243      */
1244     function _afterTokenTransfers(
1245         address from,
1246         address to,
1247         uint256 startTokenId,
1248         uint256 quantity
1249     ) internal virtual {}
1250 }
1251 
1252 abstract contract Ownable is Context {
1253     address private _owner;
1254 
1255     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1256 
1257     /**
1258      * @dev Initializes the contract setting the deployer as the initial owner.
1259      */
1260     constructor() {
1261         _transferOwnership(_msgSender());
1262     }
1263 
1264     /**
1265      * @dev Returns the address of the current owner.
1266      */
1267     function owner() public view virtual returns (address) {
1268         return _owner;
1269     }
1270 
1271     /**
1272      * @dev Throws if called by any account other than the owner.
1273      */
1274     modifier onlyOwner() {
1275         require(owner() == _msgSender() , "Ownable: caller is not the owner");
1276         _;
1277     }
1278 
1279     /**
1280      * @dev Leaves the contract without owner. It will not be possible to call
1281      * `onlyOwner` functions anymore. Can only be called by the current owner.
1282      *
1283      * NOTE: Renouncing ownership will leave the contract without an owner,
1284      * thereby removing any functionality that is only available to the owner.
1285      */
1286     function renounceOwnership() public virtual onlyOwner {
1287         _transferOwnership(address(0));
1288     }
1289 
1290     /**
1291      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1292      * Can only be called by the current owner.
1293      */
1294     function transferOwnership(address newOwner) public virtual onlyOwner {
1295         require(newOwner != address(0), "Ownable: new owner is the zero address");
1296         _transferOwnership(newOwner);
1297     }
1298 
1299     /**
1300      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1301      * Internal function without access restriction.
1302      */
1303     function _transferOwnership(address newOwner) internal virtual {
1304         address oldOwner = _owner;
1305         _owner = newOwner;
1306         emit OwnershipTransferred(oldOwner, newOwner);
1307     }
1308 }
1309 pragma solidity ^0.8.13;
1310 
1311 interface IOperatorFilterRegistry {
1312     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1313     function register(address registrant) external;
1314     function registerAndSubscribe(address registrant, address subscription) external;
1315     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1316     function updateOperator(address registrant, address operator, bool filtered) external;
1317     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1318     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1319     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1320     function subscribe(address registrant, address registrantToSubscribe) external;
1321     function unsubscribe(address registrant, bool copyExistingEntries) external;
1322     function subscriptionOf(address addr) external returns (address registrant);
1323     function subscribers(address registrant) external returns (address[] memory);
1324     function subscriberAt(address registrant, uint256 index) external returns (address);
1325     function copyEntriesOf(address registrant, address registrantToCopy) external;
1326     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1327     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1328     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1329     function filteredOperators(address addr) external returns (address[] memory);
1330     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1331     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1332     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1333     function isRegistered(address addr) external returns (bool);
1334     function codeHashOf(address addr) external returns (bytes32);
1335 }
1336 pragma solidity ^0.8.13;
1337 
1338 
1339 
1340 abstract contract OperatorFilterer {
1341     error OperatorNotAllowed(address operator);
1342 
1343     IOperatorFilterRegistry constant operatorFilterRegistry =
1344         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1345 
1346     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1347         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1348         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1349         // order for the modifier to filter addresses.
1350         if (address(operatorFilterRegistry).code.length > 0) {
1351             if (subscribe) {
1352                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1353             } else {
1354                 if (subscriptionOrRegistrantToCopy != address(0)) {
1355                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1356                 } else {
1357                     operatorFilterRegistry.register(address(this));
1358                 }
1359             }
1360         }
1361     }
1362 
1363     modifier onlyAllowedOperator(address from) virtual {
1364         // Check registry code length to facilitate testing in environments without a deployed registry.
1365         if (address(operatorFilterRegistry).code.length > 0) {
1366             // Allow spending tokens from addresses with balance
1367             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1368             // from an EOA.
1369             if (from == msg.sender) {
1370                 _;
1371                 return;
1372             }
1373             if (
1374                 !(
1375                     operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
1376                         && operatorFilterRegistry.isOperatorAllowed(address(this), from)
1377                 )
1378             ) {
1379                 revert OperatorNotAllowed(msg.sender);
1380             }
1381         }
1382         _;
1383     }
1384 }
1385 pragma solidity ^0.8.13;
1386 
1387 
1388 
1389 abstract contract DefaultOperatorFilterer is OperatorFilterer {
1390     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1391 
1392     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1393 }
1394     pragma solidity ^0.8.7;
1395     
1396     contract l337h4ck3rs is ERC721A, DefaultOperatorFilterer , Ownable {
1397     using Strings for uint256;
1398 
1399 
1400   string private uriPrefix ;
1401   string private uriSuffix = ".json";
1402   string public hiddenURL;
1403 
1404   
1405   
1406 
1407   uint256 public cost = 0.003 ether;
1408  
1409   
1410 
1411   uint16 public maxSupply = 3333;
1412   uint8 public maxMintAmountPerTx = 16;
1413     uint8 public maxFreeMintAmountPerWallet = 1;
1414                                                              
1415  
1416   bool public paused = true;
1417   bool public reveal =false;
1418 
1419    mapping (address => uint8) public NFTPerPublicAddress;
1420 
1421  
1422   
1423   
1424  
1425   
1426 
1427   constructor() ERC721A("1337 h4ck3rs", "1337h4ck3rs") {
1428   }
1429 
1430 
1431   
1432  
1433   function mint(uint8 _mintAmount) external payable  {
1434      uint16 totalSupply = uint16(totalSupply());
1435      uint8 nft = NFTPerPublicAddress[msg.sender];
1436     require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
1437     require(_mintAmount + nft <= maxMintAmountPerTx, "Exceeds max per transaction.");
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
1478     require(totalSupply + totalAmount <= maxSupply, "Exceeds max supply.");
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
1521  
1522 
1523 
1524  function setFreeMaxLimitPerAddress(uint8 _limit) external onlyOwner{
1525     maxFreeMintAmountPerWallet = _limit;
1526    delete _limit;
1527 
1528 }
1529 
1530     
1531   
1532 
1533   function setUriPrefix(string memory _uriPrefix) external onlyOwner {
1534     uriPrefix = _uriPrefix;
1535   }
1536    function setHiddenUri(string memory _uriPrefix) external onlyOwner {
1537     hiddenURL = _uriPrefix;
1538   }
1539 
1540 
1541   function setPaused() external onlyOwner {
1542     paused = !paused;
1543    
1544   }
1545 
1546   function setCost(uint _cost) external onlyOwner{
1547       cost = _cost;
1548 
1549   }
1550 
1551  function setRevealed() external onlyOwner{
1552      reveal = !reveal;
1553  }
1554 
1555   function setMaxMintAmountPerTx(uint8 _maxtx) external onlyOwner{
1556       maxMintAmountPerTx = _maxtx;
1557 
1558   }
1559 
1560  
1561 
1562   function withdraw() external onlyOwner {
1563   uint _balance = address(this).balance;
1564      payable(msg.sender).transfer(_balance ); 
1565        
1566   }
1567 
1568 
1569   function _baseURI() internal view  override returns (string memory) {
1570     return uriPrefix;
1571   }
1572 
1573     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1574         super.transferFrom(from, to, tokenId);
1575     }
1576 
1577     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1578         super.safeTransferFrom(from, to, tokenId);
1579     }
1580 
1581     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1582         public
1583         override
1584         onlyAllowedOperator(from)
1585     {
1586         super.safeTransferFrom(from, to, tokenId, data);
1587     }
1588 }