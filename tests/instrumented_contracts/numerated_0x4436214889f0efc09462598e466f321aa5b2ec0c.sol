1 /**
2 ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██████▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
3 ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██      ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
4 ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██          ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
5 ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██            ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
6 ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██              ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
7 ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██    ▒▒▒▒        ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
8 ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██░░  ░░▒▒▒▒░░      ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
9 ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██    ░░░░░░░░░░    ░░▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
10 ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██    ░░░░░░░░░░      ░░▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
11 ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██                        ██████▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
12 ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██                        ░░██    ▓▓▒▒████▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
13 ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██                                  ██    ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
14 ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓░░                                  ██    ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
15 ▒▒▒▒████▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓░░                                    ▒▒    ██▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
16 ▒▒██░░  ██▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██░░                                            ██▒▒▓▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒
17 ▒▒██      ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██                                              ░░  ░░░░▒▒░░  ░░▓▓▓▓▒▒
18 ▒▒██        ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒██                                                              ░░░░▓▓
19 ▒▒██        ██▒▒▒▒▒▒▒▒▒▒▒▒██                                                          ░░░░      ██
20 ▒▒██        ██▒▒▒▒▒▒▒▒▒▒▒▒██              ██████                                  ▒▒▒▒▒▒▒▒      ██
21 ▒▒██        ██▒▒▒▒▒▒▒▒▒▒▒▒██            ▓▓▒▒▒▒██▓▓                                ▒▒▒▒▒▒▒▒      ██
22 ▒▒██        ██▒▒▒▒▒▒▒▒▒▒▒▒██          ██░░████    ██                              ▒▒▒▒▒▒▒▒    ██▒▒
23 ▒▒██        ██▒▒▒▒▒▒▒▒▒▒▒▒██          ██▓▓████    ██                              ▒▒▒▒▒▒░░    ██▒▒
24 ▒▒▒▒██      ██▒▒▒▒▒▒▒▒▒▒▒▒██          ████▒▒██▓▓▓▓██                              ▒▒▒▒░░    ▒▒▓▓▒▒
25 ▒▒▒▒██        ██▒▒▒▒▒▒▒▒▒▒██        ░░████████░░██                                ░░░░      ██▒▒▒▒
26 ▒▒▒▒▒▒██      ██▒▒▒▒████████      ░░▒▒▒▒████████░░                ██▓▓▓▓                  ▓▓▓▓▒▒▒▒
27 ▒▒▒▒▒▒██      ██▒▒██        ██    ░░▒▒▒▒░░                      ██  ░░████              ▓▓▒▒▒▒▒▒▒▒
28 ▒▒▒▒▒▒██      ████          ██      ░░░░              ▒▒      ████    ██░░██          ▓▓▒▒▒▒▒▒▒▒▒▒
29 ▒▒▒▒▒▒██                      ██                  ██          ██░░██████░░██          ██▒▒▒▒▒▒▒▒▒▒
30 ▒▒▒▒▒▒▒▒██                                          ████      ████░░████░░██          ██▒▒▒▒▒▒▒▒▒▒
31 ▒▒▒▒▒▒▒▒██                                          ░░░░      ████▓▓████▓▓▒▒          ██▒▒▒▒▒▒▒▒▒▒
32 ▒▒▒▒▒▒▒▒▒▒██                                                    ████████▒▒░░░░      ▒▒▓▓▒▒▒▒▒▒▒▒▒▒
33 ▒▒▒▒▒▒▒▒▒▒▒▒████                                                      ░░▒▒▒▒░░      ██▒▒▒▒▒▒▒▒▒▒▒▒
34 ▒▒▒▒▒▒▒▒▒▒▒▒▒▒██                                                        ░░░░      ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒
35 ▒▒▒▒▒▒▒▒▒▒▒▒▒▒██                                                                ▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒
36 ▒▒▒▒▒▒▒▒▒▒▒▒▒▒██                                  ██                        ▓▓██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
37 ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██                                ██████████████████████████▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
38 ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██                            ████        ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
39 ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓██              ▓▓██          ░░░░▓▓      ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
40 ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██                  ██            ██      ░░██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
41 ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒████      ██  ██  ██    ██  ██  ██  ██  ████▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
42 ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒████████████████▒▒████████████▒▒████████▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
43        
44  */
45 // SPDX-License-Identifier: MIT
46 //Developer Info:
47 
48 
49 
50 // File: @openzeppelin/contracts/utils/Strings.sol
51 
52 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
53 
54 pragma solidity ^0.8.0;
55 
56 /**
57  * @dev String operations.
58  */
59 library Strings {
60     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
61 
62     /**
63      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
64      */
65     function toString(uint256 value) internal pure returns (string memory) {
66         // Inspired by OraclizeAPI's implementation - MIT licence
67         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
68 
69         if (value == 0) {
70             return "0";
71         }
72         uint256 temp = value;
73         uint256 digits;
74         while (temp != 0) {
75             digits++;
76             temp /= 10;
77         }
78         bytes memory buffer = new bytes(digits);
79         while (value != 0) {
80             digits -= 1;
81             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
82             value /= 10;
83         }
84         return string(buffer);
85     }
86 
87     /**
88      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
89      */
90     function toHexString(uint256 value) internal pure returns (string memory) {
91         if (value == 0) {
92             return "0x00";
93         }
94         uint256 temp = value;
95         uint256 length = 0;
96         while (temp != 0) {
97             length++;
98             temp >>= 8;
99         }
100         return toHexString(value, length);
101     }
102 
103     /**
104      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
105      */
106     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
107         bytes memory buffer = new bytes(2 * length + 2);
108         buffer[0] = "0";
109         buffer[1] = "x";
110         for (uint256 i = 2 * length + 1; i > 1; --i) {
111             buffer[i] = _HEX_SYMBOLS[value & 0xf];
112             value >>= 4;
113         }
114         require(value == 0, "Strings: hex length insufficient");
115         return string(buffer);
116     }
117 }
118 
119 // File: @openzeppelin/contracts/utils/Context.sol
120 
121 
122 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
123 
124 pragma solidity ^0.8.0;
125 
126 /**
127  * @dev Provides information about the current execution context, including the
128  * sender of the transaction and its data. While these are generally available
129  * via msg.sender and msg.data, they should not be accessed in such a direct
130  * manner, since when dealing with meta-transactions the account sending and
131  * paying for execution may not be the actual sender (as far as an application
132  * is concerned).
133  *
134  * This contract is only required for intermediate, library-like contracts.
135  */
136 abstract contract Context {
137     function _msgSender() internal view virtual returns (address) {
138         return msg.sender;
139     }
140 
141     function _msgData() internal view virtual returns (bytes calldata) {
142         return msg.data;
143     }
144 }
145 
146 // File: @openzeppelin/contracts/utils/Address.sol
147 
148 
149 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
150 
151 pragma solidity ^0.8.1;
152 
153 /**
154  * @dev Collection of functions related to the address type
155  */
156 library Address {
157     /**
158      * @dev Returns true if `account` is a contract.
159      *
160      * [IMPORTANT]
161      * ====
162      * It is unsafe to assume that an address for which this function returns
163      * false is an externally-owned account (EOA) and not a contract.
164      *
165      * Among others, `isContract` will return false for the following
166      * types of addresses:
167      *
168      *  - an externally-owned account
169      *  - a contract in construction
170      *  - an address where a contract will be created
171      *  - an address where a contract lived, but was destroyed
172      * ====
173      *
174      * [IMPORTANT]
175      * ====
176      * You shouldn't rely on `isContract` to protect against flash loan attacks!
177      *
178      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
179      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
180      * constructor.
181      * ====
182      */
183     function isContract(address account) internal view returns (bool) {
184         // This method relies on extcodesize/address.code.length, which returns 0
185         // for contracts in construction, since the code is only stored at the end
186         // of the constructor execution.
187 
188         return account.code.length > 0;
189     }
190 
191     /**
192      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
193      * `recipient`, forwarding all available gas and reverting on errors.
194      *
195      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
196      * of certain opcodes, possibly making contracts go over the 2300 gas limit
197      * imposed by `transfer`, making them unable to receive funds via
198      * `transfer`. {sendValue} removes this limitation.
199      *
200      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
201      *
202      * IMPORTANT: because control is transferred to `recipient`, care must be
203      * taken to not create reentrancy vulnerabilities. Consider using
204      * {ReentrancyGuard} or the
205      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
206      */
207     function sendValue(address payable recipient, uint256 amount) internal {
208         require(address(this).balance >= amount, "Address: insufficient balance");
209 
210         (bool success, ) = recipient.call{value: amount}("");
211         require(success, "Address: unable to send value, recipient may have reverted");
212     }
213 
214     /**
215      * @dev Performs a Solidity function call using a low level `call`. A
216      * plain `call` is an unsafe replacement for a function call: use this
217      * function instead.
218      *
219      * If `target` reverts with a revert reason, it is bubbled up by this
220      * function (like regular Solidity function calls).
221      *
222      * Returns the raw returned data. To convert to the expected return value,
223      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
224      *
225      * Requirements:
226      *
227      * - `target` must be a contract.
228      * - calling `target` with `data` must not revert.
229      *
230      * _Available since v3.1._
231      */
232     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
233         return functionCall(target, data, "Address: low-level call failed");
234     }
235 
236     /**
237      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
238      * `errorMessage` as a fallback revert reason when `target` reverts.
239      *
240      * _Available since v3.1._
241      */
242     function functionCall(
243         address target,
244         bytes memory data,
245         string memory errorMessage
246     ) internal returns (bytes memory) {
247         return functionCallWithValue(target, data, 0, errorMessage);
248     }
249 
250     /**
251      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
252      * but also transferring `value` wei to `target`.
253      *
254      * Requirements:
255      *
256      * - the calling contract must have an ETH balance of at least `value`.
257      * - the called Solidity function must be `payable`.
258      *
259      * _Available since v3.1._
260      */
261     function functionCallWithValue(
262         address target,
263         bytes memory data,
264         uint256 value
265     ) internal returns (bytes memory) {
266         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
267     }
268 
269     /**
270      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
271      * with `errorMessage` as a fallback revert reason when `target` reverts.
272      *
273      * _Available since v3.1._
274      */
275     function functionCallWithValue(
276         address target,
277         bytes memory data,
278         uint256 value,
279         string memory errorMessage
280     ) internal returns (bytes memory) {
281         require(address(this).balance >= value, "Address: insufficient balance for call");
282         require(isContract(target), "Address: call to non-contract");
283 
284         (bool success, bytes memory returndata) = target.call{value: value}(data);
285         return verifyCallResult(success, returndata, errorMessage);
286     }
287 
288     /**
289      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
290      * but performing a static call.
291      *
292      * _Available since v3.3._
293      */
294     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
295         return functionStaticCall(target, data, "Address: low-level static call failed");
296     }
297 
298     /**
299      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
300      * but performing a static call.
301      *
302      * _Available since v3.3._
303      */
304     function functionStaticCall(
305         address target,
306         bytes memory data,
307         string memory errorMessage
308     ) internal view returns (bytes memory) {
309         require(isContract(target), "Address: static call to non-contract");
310 
311         (bool success, bytes memory returndata) = target.staticcall(data);
312         return verifyCallResult(success, returndata, errorMessage);
313     }
314 
315     /**
316      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
317      * but performing a delegate call.
318      *
319      * _Available since v3.4._
320      */
321     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
322         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
323     }
324 
325     /**
326      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
327      * but performing a delegate call.
328      *
329      * _Available since v3.4._
330      */
331     function functionDelegateCall(
332         address target,
333         bytes memory data,
334         string memory errorMessage
335     ) internal returns (bytes memory) {
336         require(isContract(target), "Address: delegate call to non-contract");
337 
338         (bool success, bytes memory returndata) = target.delegatecall(data);
339         return verifyCallResult(success, returndata, errorMessage);
340     }
341 
342     /**
343      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
344      * revert reason using the provided one.
345      *
346      * _Available since v4.3._
347      */
348     function verifyCallResult(
349         bool success,
350         bytes memory returndata,
351         string memory errorMessage
352     ) internal pure returns (bytes memory) {
353         if (success) {
354             return returndata;
355         } else {
356             // Look for revert reason and bubble it up if present
357             if (returndata.length > 0) {
358                 // The easiest way to bubble the revert reason is using memory via assembly
359 
360                 assembly {
361                     let returndata_size := mload(returndata)
362                     revert(add(32, returndata), returndata_size)
363                 }
364             } else {
365                 revert(errorMessage);
366             }
367         }
368     }
369 }
370 
371 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
372 
373 
374 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
375 
376 pragma solidity ^0.8.0;
377 
378 /**
379  * @title ERC721 token receiver interface
380  * @dev Interface for any contract that wants to support safeTransfers
381  * from ERC721 asset contracts.
382  */
383 interface IERC721Receiver {
384     /**
385      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
386      * by `operator` from `from`, this function is called.
387      *
388      * It must return its Solidity selector to confirm the token transfer.
389      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
390      *
391      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
392      */
393     function onERC721Received(
394         address operator,
395         address from,
396         uint256 tokenId,
397         bytes calldata data
398     ) external returns (bytes4);
399 }
400 
401 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
402 
403 
404 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
405 
406 pragma solidity ^0.8.0;
407 
408 /**
409  * @dev Interface of the ERC165 standard, as defined in the
410  * https://eips.ethereum.org/EIPS/eip-165[EIP].
411  *
412  * Implementers can declare support of contract interfaces, which can then be
413  * queried by others ({ERC165Checker}).
414  *
415  * For an implementation, see {ERC165}.
416  */
417 interface IERC165 {
418     /**
419      * @dev Returns true if this contract implements the interface defined by
420      * `interfaceId`. See the corresponding
421      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
422      * to learn more about how these ids are created.
423      *
424      * This function call must use less than 30 000 gas.
425      */
426     function supportsInterface(bytes4 interfaceId) external view returns (bool);
427 }
428 
429 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
430 
431 
432 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
433 
434 pragma solidity ^0.8.0;
435 
436 
437 /**
438  * @dev Implementation of the {IERC165} interface.
439  *
440  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
441  * for the additional interface id that will be supported. For example:
442  *
443  * ```solidity
444  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
445  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
446  * }
447  * ```
448  *
449  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
450  */
451 abstract contract ERC165 is IERC165 {
452     /**
453      * @dev See {IERC165-supportsInterface}.
454      */
455     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
456         return interfaceId == type(IERC165).interfaceId;
457     }
458 }
459 
460 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
461 
462 
463 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
464 
465 pragma solidity ^0.8.0;
466 
467 
468 /**
469  * @dev Required interface of an ERC721 compliant contract.
470  */
471 interface IERC721 is IERC165 {
472     /**
473      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
474      */
475     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
476 
477     /**
478      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
479      */
480     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
481 
482     /**
483      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
484      */
485     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
486 
487     /**
488      * @dev Returns the number of tokens in ``owner``'s account.
489      */
490     function balanceOf(address owner) external view returns (uint256 balance);
491 
492     /**
493      * @dev Returns the owner of the `tokenId` token.
494      *
495      * Requirements:
496      *
497      * - `tokenId` must exist.
498      */
499     function ownerOf(uint256 tokenId) external view returns (address owner);
500 
501     /**
502      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
503      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
504      *
505      * Requirements:
506      *
507      * - `from` cannot be the zero address.
508      * - `to` cannot be the zero address.
509      * - `tokenId` token must exist and be owned by `from`.
510      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
511      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
512      *
513      * Emits a {Transfer} event.
514      */
515     function safeTransferFrom(
516         address from,
517         address to,
518         uint256 tokenId
519     ) external;
520 
521     /**
522      * @dev Transfers `tokenId` token from `from` to `to`.
523      *
524      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
525      *
526      * Requirements:
527      *
528      * - `from` cannot be the zero address.
529      * - `to` cannot be the zero address.
530      * - `tokenId` token must be owned by `from`.
531      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
532      *
533      * Emits a {Transfer} event.
534      */
535     function transferFrom(
536         address from,
537         address to,
538         uint256 tokenId
539     ) external;
540 
541     /**
542      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
543      * The approval is cleared when the token is transferred.
544      *
545      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
546      *
547      * Requirements:
548      *
549      * - The caller must own the token or be an approved operator.
550      * - `tokenId` must exist.
551      *
552      * Emits an {Approval} event.
553      */
554     function approve(address to, uint256 tokenId) external;
555 
556     /**
557      * @dev Returns the account approved for `tokenId` token.
558      *
559      * Requirements:
560      *
561      * - `tokenId` must exist.
562      */
563     function getApproved(uint256 tokenId) external view returns (address operator);
564 
565     /**
566      * @dev Approve or remove `operator` as an operator for the caller.
567      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
568      *
569      * Requirements:
570      *
571      * - The `operator` cannot be the caller.
572      *
573      * Emits an {ApprovalForAll} event.
574      */
575     function setApprovalForAll(address operator, bool _approved) external;
576 
577     /**
578      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
579      *
580      * See {setApprovalForAll}
581      */
582     function isApprovedForAll(address owner, address operator) external view returns (bool);
583 
584     /**
585      * @dev Safely transfers `tokenId` token from `from` to `to`.
586      *
587      * Requirements:
588      *
589      * - `from` cannot be the zero address.
590      * - `to` cannot be the zero address.
591      * - `tokenId` token must exist and be owned by `from`.
592      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
593      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
594      *
595      * Emits a {Transfer} event.
596      */
597     function safeTransferFrom(
598         address from,
599         address to,
600         uint256 tokenId,
601         bytes calldata data
602     ) external;
603 }
604 
605 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
606 
607 
608 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
609 
610 pragma solidity ^0.8.0;
611 
612 
613 /**
614  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
615  * @dev See https://eips.ethereum.org/EIPS/eip-721
616  */
617 interface IERC721Metadata is IERC721 {
618     /**
619      * @dev Returns the token collection name.
620      */
621     function name() external view returns (string memory);
622 
623     /**
624      * @dev Returns the token collection symbol.
625      */
626     function symbol() external view returns (string memory);
627 
628     /**
629      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
630      */
631     function tokenURI(uint256 tokenId) external view returns (string memory);
632 }
633 
634 // File: contracts/new.sol
635 
636 
637 
638 
639 pragma solidity ^0.8.4;
640 
641 
642 
643 
644 
645 
646 
647 
648 error ApprovalCallerNotOwnerNorApproved();
649 error ApprovalQueryForNonexistentToken();
650 error ApproveToCaller();
651 error ApprovalToCurrentOwner();
652 error BalanceQueryForZeroAddress();
653 error MintToZeroAddress();
654 error MintZeroQuantity();
655 error OwnerQueryForNonexistentToken();
656 error TransferCallerNotOwnerNorApproved();
657 error TransferFromIncorrectOwner();
658 error TransferToNonERC721ReceiverImplementer();
659 error TransferToZeroAddress();
660 error URIQueryForNonexistentToken();
661 
662 /**
663  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
664  * the Metadata extension. Built to optimize for lower gas during batch mints.
665  *
666  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
667  *
668  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
669  *
670  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
671  */
672 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
673     using Address for address;
674     using Strings for uint256;
675 
676     // Compiler will pack this into a single 256bit word.
677     struct TokenOwnership {
678         // The address of the owner.
679         address addr;
680         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
681         uint64 startTimestamp;
682         // Whether the token has been burned.
683         bool burned;
684     }
685 
686     // Compiler will pack this into a single 256bit word.
687     struct AddressData {
688         // Realistically, 2**64-1 is more than enough.
689         uint64 balance;
690         // Keeps track of mint count with minimal overhead for tokenomics.
691         uint64 numberMinted;
692         // Keeps track of burn count with minimal overhead for tokenomics.
693         uint64 numberBurned;
694         // For miscellaneous variable(s) pertaining to the address
695         // (e.g. number of whitelist mint slots used).
696         // If there are multiple variables, please pack them into a uint64.
697         uint64 aux;
698     }
699 
700     // The tokenId of the next token to be minted.
701     uint256 internal _currentIndex;
702 
703     // The number of tokens burned.
704     uint256 internal _burnCounter;
705 
706     // Token name
707     string private _name;
708 
709     // Token symbol
710     string private _symbol;
711 
712     // Mapping from token ID to ownership details
713     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
714     mapping(uint256 => TokenOwnership) internal _ownerships;
715 
716     // Mapping owner address to address data
717     mapping(address => AddressData) private _addressData;
718 
719     // Mapping from token ID to approved address
720     mapping(uint256 => address) private _tokenApprovals;
721 
722     // Mapping from owner to operator approvals
723     mapping(address => mapping(address => bool)) private _operatorApprovals;
724 
725     constructor(string memory name_, string memory symbol_) {
726         _name = name_;
727         _symbol = symbol_;
728         _currentIndex = _startTokenId();
729     }
730 
731     /**
732      * To change the starting tokenId, please override this function.
733      */
734     function _startTokenId() internal view virtual returns (uint256) {
735         return 0;
736     }
737 
738     /**
739      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
740      */
741     function totalSupply() public view returns (uint256) {
742         // Counter underflow is impossible as _burnCounter cannot be incremented
743         // more than _currentIndex - _startTokenId() times
744         unchecked {
745             return _currentIndex - _burnCounter - _startTokenId();
746         }
747     }
748 
749     /**
750      * Returns the total amount of tokens minted in the contract.
751      */
752     function _totalMinted() internal view returns (uint256) {
753         // Counter underflow is impossible as _currentIndex does not decrement,
754         // and it is initialized to _startTokenId()
755         unchecked {
756             return _currentIndex - _startTokenId();
757         }
758     }
759 
760     /**
761      * @dev See {IERC165-supportsInterface}.
762      */
763     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
764         return
765             interfaceId == type(IERC721).interfaceId ||
766             interfaceId == type(IERC721Metadata).interfaceId ||
767             super.supportsInterface(interfaceId);
768     }
769 
770     /**
771      * @dev See {IERC721-balanceOf}.
772      */
773     function balanceOf(address owner) public view override returns (uint256) {
774         if (owner == address(0)) revert BalanceQueryForZeroAddress();
775         return uint256(_addressData[owner].balance);
776     }
777 
778     /**
779      * Returns the number of tokens minted by `owner`.
780      */
781     function _numberMinted(address owner) internal view returns (uint256) {
782         return uint256(_addressData[owner].numberMinted);
783     }
784 
785     /**
786      * Returns the number of tokens burned by or on behalf of `owner`.
787      */
788     function _numberBurned(address owner) internal view returns (uint256) {
789         return uint256(_addressData[owner].numberBurned);
790     }
791 
792     /**
793      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
794      */
795     function _getAux(address owner) internal view returns (uint64) {
796         return _addressData[owner].aux;
797     }
798 
799     /**
800      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
801      * If there are multiple variables, please pack them into a uint64.
802      */
803     function _setAux(address owner, uint64 aux) internal {
804         _addressData[owner].aux = aux;
805     }
806 
807     /**
808      * Gas spent here starts off proportional to the maximum mint batch size.
809      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
810      */
811     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
812         uint256 curr = tokenId;
813 
814         unchecked {
815             if (_startTokenId() <= curr && curr < _currentIndex) {
816                 TokenOwnership memory ownership = _ownerships[curr];
817                 if (!ownership.burned) {
818                     if (ownership.addr != address(0)) {
819                         return ownership;
820                     }
821                     // Invariant:
822                     // There will always be an ownership that has an address and is not burned
823                     // before an ownership that does not have an address and is not burned.
824                     // Hence, curr will not underflow.
825                     while (true) {
826                         curr--;
827                         ownership = _ownerships[curr];
828                         if (ownership.addr != address(0)) {
829                             return ownership;
830                         }
831                     }
832                 }
833             }
834         }
835         revert OwnerQueryForNonexistentToken();
836     }
837 
838     /**
839      * @dev See {IERC721-ownerOf}.
840      */
841     function ownerOf(uint256 tokenId) public view override returns (address) {
842         return _ownershipOf(tokenId).addr;
843     }
844 
845     /**
846      * @dev See {IERC721Metadata-name}.
847      */
848     function name() public view virtual override returns (string memory) {
849         return _name;
850     }
851 
852     /**
853      * @dev See {IERC721Metadata-symbol}.
854      */
855     function symbol() public view virtual override returns (string memory) {
856         return _symbol;
857     }
858 
859     /**
860      * @dev See {IERC721Metadata-tokenURI}.
861      */
862     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
863         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
864 
865         string memory baseURI = _baseURI();
866         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
867     }
868 
869     /**
870      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
871      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
872      * by default, can be overriden in child contracts.
873      */
874     function _baseURI() internal view virtual returns (string memory) {
875         return '';
876     }
877 
878     /**
879      * @dev See {IERC721-approve}.
880      */
881     function approve(address to, uint256 tokenId) public override {
882         address owner = ERC721A.ownerOf(tokenId);
883         if (to == owner) revert ApprovalToCurrentOwner();
884 
885         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
886             revert ApprovalCallerNotOwnerNorApproved();
887         }
888 
889         _approve(to, tokenId, owner);
890     }
891 
892     /**
893      * @dev See {IERC721-getApproved}.
894      */
895     function getApproved(uint256 tokenId) public view override returns (address) {
896         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
897 
898         return _tokenApprovals[tokenId];
899     }
900 
901     /**
902      * @dev See {IERC721-setApprovalForAll}.
903      */
904     function setApprovalForAll(address operator, bool approved) public virtual override {
905         if (operator == _msgSender()) revert ApproveToCaller();
906 
907         _operatorApprovals[_msgSender()][operator] = approved;
908         emit ApprovalForAll(_msgSender(), operator, approved);
909     }
910 
911     /**
912      * @dev See {IERC721-isApprovedForAll}.
913      */
914     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
915         return _operatorApprovals[owner][operator];
916     }
917 
918     /**
919      * @dev See {IERC721-transferFrom}.
920      */
921     function transferFrom(
922         address from,
923         address to,
924         uint256 tokenId
925     ) public virtual override {
926         _transfer(from, to, tokenId);
927     }
928 
929     /**
930      * @dev See {IERC721-safeTransferFrom}.
931      */
932     function safeTransferFrom(
933         address from,
934         address to,
935         uint256 tokenId
936     ) public virtual override {
937         safeTransferFrom(from, to, tokenId, '');
938     }
939 
940     /**
941      * @dev See {IERC721-safeTransferFrom}.
942      */
943     function safeTransferFrom(
944         address from,
945         address to,
946         uint256 tokenId,
947         bytes memory _data
948     ) public virtual override {
949         _transfer(from, to, tokenId);
950         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
951             revert TransferToNonERC721ReceiverImplementer();
952         }
953     }
954 
955     /**
956      * @dev Returns whether `tokenId` exists.
957      *
958      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
959      *
960      * Tokens start existing when they are minted (`_mint`),
961      */
962     function _exists(uint256 tokenId) internal view returns (bool) {
963         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
964             !_ownerships[tokenId].burned;
965     }
966 
967     function _safeMint(address to, uint256 quantity) internal {
968         _safeMint(to, quantity, '');
969     }
970 
971     /**
972      * @dev Safely mints `quantity` tokens and transfers them to `to`.
973      *
974      * Requirements:
975      *
976      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
977      * - `quantity` must be greater than 0.
978      *
979      * Emits a {Transfer} event.
980      */
981     function _safeMint(
982         address to,
983         uint256 quantity,
984         bytes memory _data
985     ) internal {
986         _mint(to, quantity, _data, true);
987     }
988 
989     /**
990      * @dev Mints `quantity` tokens and transfers them to `to`.
991      *
992      * Requirements:
993      *
994      * - `to` cannot be the zero address.
995      * - `quantity` must be greater than 0.
996      *
997      * Emits a {Transfer} event.
998      */
999     function _mint(
1000         address to,
1001         uint256 quantity,
1002         bytes memory _data,
1003         bool safe
1004     ) internal {
1005         uint256 startTokenId = _currentIndex;
1006         if (to == address(0)) revert MintToZeroAddress();
1007         if (quantity == 0) revert MintZeroQuantity();
1008 
1009         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1010 
1011         // Overflows are incredibly unrealistic.
1012         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1013         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1014         unchecked {
1015             _addressData[to].balance += uint64(quantity);
1016             _addressData[to].numberMinted += uint64(quantity);
1017 
1018             _ownerships[startTokenId].addr = to;
1019             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1020 
1021             uint256 updatedIndex = startTokenId;
1022             uint256 end = updatedIndex + quantity;
1023 
1024             if (safe && to.isContract()) {
1025                 do {
1026                     emit Transfer(address(0), to, updatedIndex);
1027                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1028                         revert TransferToNonERC721ReceiverImplementer();
1029                     }
1030                 } while (updatedIndex != end);
1031                 // Reentrancy protection
1032                 if (_currentIndex != startTokenId) revert();
1033             } else {
1034                 do {
1035                     emit Transfer(address(0), to, updatedIndex++);
1036                 } while (updatedIndex != end);
1037             }
1038             _currentIndex = updatedIndex;
1039         }
1040         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1041     }
1042 
1043     /**
1044      * @dev Transfers `tokenId` from `from` to `to`.
1045      *
1046      * Requirements:
1047      *
1048      * - `to` cannot be the zero address.
1049      * - `tokenId` token must be owned by `from`.
1050      *
1051      * Emits a {Transfer} event.
1052      */
1053     function _transfer(
1054         address from,
1055         address to,
1056         uint256 tokenId
1057     ) private {
1058         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1059 
1060         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1061 
1062         bool isApprovedOrOwner = (_msgSender() == from ||
1063             isApprovedForAll(from, _msgSender()) ||
1064             getApproved(tokenId) == _msgSender());
1065 
1066         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1067         if (to == address(0)) revert TransferToZeroAddress();
1068 
1069         _beforeTokenTransfers(from, to, tokenId, 1);
1070 
1071         // Clear approvals from the previous owner
1072         _approve(address(0), tokenId, from);
1073 
1074         // Underflow of the sender's balance is impossible because we check for
1075         // ownership above and the recipient's balance can't realistically overflow.
1076         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1077         unchecked {
1078             _addressData[from].balance -= 1;
1079             _addressData[to].balance += 1;
1080 
1081             TokenOwnership storage currSlot = _ownerships[tokenId];
1082             currSlot.addr = to;
1083             currSlot.startTimestamp = uint64(block.timestamp);
1084 
1085             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1086             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1087             uint256 nextTokenId = tokenId + 1;
1088             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1089             if (nextSlot.addr == address(0)) {
1090                 // This will suffice for checking _exists(nextTokenId),
1091                 // as a burned slot cannot contain the zero address.
1092                 if (nextTokenId != _currentIndex) {
1093                     nextSlot.addr = from;
1094                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1095                 }
1096             }
1097         }
1098 
1099         emit Transfer(from, to, tokenId);
1100         _afterTokenTransfers(from, to, tokenId, 1);
1101     }
1102 
1103     /**
1104      * @dev This is equivalent to _burn(tokenId, false)
1105      */
1106     function _burn(uint256 tokenId) internal virtual {
1107         _burn(tokenId, false);
1108     }
1109 
1110     /**
1111      * @dev Destroys `tokenId`.
1112      * The approval is cleared when the token is burned.
1113      *
1114      * Requirements:
1115      *
1116      * - `tokenId` must exist.
1117      *
1118      * Emits a {Transfer} event.
1119      */
1120     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1121         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1122 
1123         address from = prevOwnership.addr;
1124 
1125         if (approvalCheck) {
1126             bool isApprovedOrOwner = (_msgSender() == from ||
1127                 isApprovedForAll(from, _msgSender()) ||
1128                 getApproved(tokenId) == _msgSender());
1129 
1130             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1131         }
1132 
1133         _beforeTokenTransfers(from, address(0), tokenId, 1);
1134 
1135         // Clear approvals from the previous owner
1136         _approve(address(0), tokenId, from);
1137 
1138         // Underflow of the sender's balance is impossible because we check for
1139         // ownership above and the recipient's balance can't realistically overflow.
1140         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1141         unchecked {
1142             AddressData storage addressData = _addressData[from];
1143             addressData.balance -= 1;
1144             addressData.numberBurned += 1;
1145 
1146             // Keep track of who burned the token, and the timestamp of burning.
1147             TokenOwnership storage currSlot = _ownerships[tokenId];
1148             currSlot.addr = from;
1149             currSlot.startTimestamp = uint64(block.timestamp);
1150             currSlot.burned = true;
1151 
1152             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1153             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1154             uint256 nextTokenId = tokenId + 1;
1155             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1156             if (nextSlot.addr == address(0)) {
1157                 // This will suffice for checking _exists(nextTokenId),
1158                 // as a burned slot cannot contain the zero address.
1159                 if (nextTokenId != _currentIndex) {
1160                     nextSlot.addr = from;
1161                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1162                 }
1163             }
1164         }
1165 
1166         emit Transfer(from, address(0), tokenId);
1167         _afterTokenTransfers(from, address(0), tokenId, 1);
1168 
1169         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1170         unchecked {
1171             _burnCounter++;
1172         }
1173     }
1174 
1175     /**
1176      * @dev Approve `to` to operate on `tokenId`
1177      *
1178      * Emits a {Approval} event.
1179      */
1180     function _approve(
1181         address to,
1182         uint256 tokenId,
1183         address owner
1184     ) private {
1185         _tokenApprovals[tokenId] = to;
1186         emit Approval(owner, to, tokenId);
1187     }
1188 
1189     /**
1190      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1191      *
1192      * @param from address representing the previous owner of the given token ID
1193      * @param to target address that will receive the tokens
1194      * @param tokenId uint256 ID of the token to be transferred
1195      * @param _data bytes optional data to send along with the call
1196      * @return bool whether the call correctly returned the expected magic value
1197      */
1198     function _checkContractOnERC721Received(
1199         address from,
1200         address to,
1201         uint256 tokenId,
1202         bytes memory _data
1203     ) private returns (bool) {
1204         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1205             return retval == IERC721Receiver(to).onERC721Received.selector;
1206         } catch (bytes memory reason) {
1207             if (reason.length == 0) {
1208                 revert TransferToNonERC721ReceiverImplementer();
1209             } else {
1210                 assembly {
1211                     revert(add(32, reason), mload(reason))
1212                 }
1213             }
1214         }
1215     }
1216 
1217     /**
1218      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1219      * And also called before burning one token.
1220      *
1221      * startTokenId - the first token id to be transferred
1222      * quantity - the amount to be transferred
1223      *
1224      * Calling conditions:
1225      *
1226      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1227      * transferred to `to`.
1228      * - When `from` is zero, `tokenId` will be minted for `to`.
1229      * - When `to` is zero, `tokenId` will be burned by `from`.
1230      * - `from` and `to` are never both zero.
1231      */
1232     function _beforeTokenTransfers(
1233         address from,
1234         address to,
1235         uint256 startTokenId,
1236         uint256 quantity
1237     ) internal virtual {}
1238 
1239     /**
1240      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1241      * minting.
1242      * And also called after one token has been burned.
1243      *
1244      * startTokenId - the first token id to be transferred
1245      * quantity - the amount to be transferred
1246      *
1247      * Calling conditions:
1248      *
1249      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1250      * transferred to `to`.
1251      * - When `from` is zero, `tokenId` has been minted for `to`.
1252      * - When `to` is zero, `tokenId` has been burned by `from`.
1253      * - `from` and `to` are never both zero.
1254      */
1255     function _afterTokenTransfers(
1256         address from,
1257         address to,
1258         uint256 startTokenId,
1259         uint256 quantity
1260     ) internal virtual {}
1261 }
1262 
1263 abstract contract Ownable is Context {
1264     address private _owner;
1265 
1266     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1267 
1268     /**
1269      * @dev Initializes the contract setting the deployer as the initial owner.
1270      */
1271     constructor() {
1272         _transferOwnership(_msgSender());
1273     }
1274 
1275     /**
1276      * @dev Returns the address of the current owner.
1277      */
1278     function owner() public view virtual returns (address) {
1279         return _owner;
1280     }
1281 
1282     /**
1283      * @dev Throws if called by any account other than the owner.
1284      */
1285     modifier onlyOwner() {
1286         require(owner() == _msgSender() , "Ownable: caller is not the owner");
1287         _;
1288     }
1289 
1290     /**
1291      * @dev Leaves the contract without owner. It will not be possible to call
1292      * `onlyOwner` functions anymore. Can only be called by the current owner.
1293      *
1294      * NOTE: Renouncing ownership will leave the contract without an owner,
1295      * thereby removing any functionality that is only available to the owner.
1296      */
1297     function renounceOwnership() public virtual onlyOwner {
1298         _transferOwnership(address(0));
1299     }
1300 
1301     /**
1302      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1303      * Can only be called by the current owner.
1304      */
1305     function transferOwnership(address newOwner) public virtual onlyOwner {
1306         require(newOwner != address(0), "Ownable: new owner is the zero address");
1307         _transferOwnership(newOwner);
1308     }
1309 
1310     /**
1311      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1312      * Internal function without access restriction.
1313      */
1314     function _transferOwnership(address newOwner) internal virtual {
1315         address oldOwner = _owner;
1316         _owner = newOwner;
1317         emit OwnershipTransferred(oldOwner, newOwner);
1318     }
1319 }
1320 pragma solidity ^0.8.13;
1321 
1322 interface IOperatorFilterRegistry {
1323     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1324     function register(address registrant) external;
1325     function registerAndSubscribe(address registrant, address subscription) external;
1326     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1327     function updateOperator(address registrant, address operator, bool filtered) external;
1328     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1329     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1330     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1331     function subscribe(address registrant, address registrantToSubscribe) external;
1332     function unsubscribe(address registrant, bool copyExistingEntries) external;
1333     function subscriptionOf(address addr) external returns (address registrant);
1334     function subscribers(address registrant) external returns (address[] memory);
1335     function subscriberAt(address registrant, uint256 index) external returns (address);
1336     function copyEntriesOf(address registrant, address registrantToCopy) external;
1337     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1338     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1339     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1340     function filteredOperators(address addr) external returns (address[] memory);
1341     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1342     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1343     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1344     function isRegistered(address addr) external returns (bool);
1345     function codeHashOf(address addr) external returns (bytes32);
1346 }
1347 pragma solidity ^0.8.13;
1348 
1349 
1350 
1351 abstract contract OperatorFilterer {
1352     error OperatorNotAllowed(address operator);
1353 
1354     IOperatorFilterRegistry constant operatorFilterRegistry =
1355         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1356 
1357     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1358         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1359         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1360         // order for the modifier to filter addresses.
1361         if (address(operatorFilterRegistry).code.length > 0) {
1362             if (subscribe) {
1363                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1364             } else {
1365                 if (subscriptionOrRegistrantToCopy != address(0)) {
1366                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1367                 } else {
1368                     operatorFilterRegistry.register(address(this));
1369                 }
1370             }
1371         }
1372     }
1373 
1374     modifier onlyAllowedOperator(address from) virtual {
1375         // Check registry code length to facilitate testing in environments without a deployed registry.
1376         if (address(operatorFilterRegistry).code.length > 0) {
1377             // Allow spending tokens from addresses with balance
1378             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1379             // from an EOA.
1380             if (from == msg.sender) {
1381                 _;
1382                 return;
1383             }
1384             if (
1385                 !(
1386                     operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
1387                         && operatorFilterRegistry.isOperatorAllowed(address(this), from)
1388                 )
1389             ) {
1390                 revert OperatorNotAllowed(msg.sender);
1391             }
1392         }
1393         _;
1394     }
1395 }
1396 pragma solidity ^0.8.13;
1397 
1398 
1399 
1400 abstract contract DefaultOperatorFilterer is OperatorFilterer {
1401     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1402 
1403     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1404 }
1405     pragma solidity ^0.8.7;
1406     
1407     contract LoveLikeACat is ERC721A, DefaultOperatorFilterer , Ownable {
1408     using Strings for uint256;
1409 
1410 
1411   string private uriPrefix ;
1412   string private uriSuffix = ".json";
1413   string public hiddenURL;
1414 
1415   
1416   
1417 
1418   uint256 public cost = 0.002 ether;
1419  
1420   
1421 
1422   uint16 public maxSupply = 8888;
1423   uint8 public maxMintAmountPerTx = 25;
1424     uint8 public maxFreeMintAmountPerWallet = 1;
1425                                                              
1426  
1427   bool public paused = true;
1428   bool public reveal =false;
1429 
1430    mapping (address => uint8) public NFTPerPublicAddress;
1431 
1432  
1433   
1434   
1435  
1436   
1437 
1438   constructor() ERC721A("Love Like A Cat", "LLAC") {
1439   }
1440 
1441 
1442   
1443  
1444   function mint(uint8 _mintAmount) external payable  {
1445      uint16 totalSupply = uint16(totalSupply());
1446      uint8 nft = NFTPerPublicAddress[msg.sender];
1447     require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
1448     require(_mintAmount + nft <= maxMintAmountPerTx, "Exceeds max per transaction.");
1449     require(msg.sender == tx.origin , "No Bots Allowed");
1450 
1451     require(!paused, "The contract is paused!");
1452     
1453       if(nft >= maxFreeMintAmountPerWallet)
1454     {
1455     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1456     }
1457     else {
1458          uint8 costAmount = _mintAmount + nft;
1459         if(costAmount > maxFreeMintAmountPerWallet)
1460        {
1461         costAmount = costAmount - maxFreeMintAmountPerWallet;
1462         require(msg.value >= cost * costAmount, "Insufficient funds!");
1463        }
1464        
1465          
1466     }
1467     
1468 
1469 
1470     _safeMint(msg.sender , _mintAmount);
1471 
1472     NFTPerPublicAddress[msg.sender] = _mintAmount + nft;
1473      
1474      delete totalSupply;
1475      delete _mintAmount;
1476   }
1477   
1478   function Reserve(uint16 _mintAmount, address _receiver) external onlyOwner {
1479      uint16 totalSupply = uint16(totalSupply());
1480     require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
1481      _safeMint(_receiver , _mintAmount);
1482      delete _mintAmount;
1483      delete _receiver;
1484      delete totalSupply;
1485   }
1486 
1487   function  Airdrop(uint8 _amountPerAddress, address[] calldata addresses) external onlyOwner {
1488      uint16 totalSupply = uint16(totalSupply());
1489      uint totalAmount =   _amountPerAddress * addresses.length;
1490     require(totalSupply + totalAmount <= maxSupply, "Exceeds max supply.");
1491      for (uint256 i = 0; i < addresses.length; i++) {
1492             _safeMint(addresses[i], _amountPerAddress);
1493         }
1494 
1495      delete _amountPerAddress;
1496      delete totalSupply;
1497   }
1498 
1499  
1500 
1501   function setMaxSupply(uint16 _maxSupply) external onlyOwner {
1502       maxSupply = _maxSupply;
1503   }
1504 
1505 
1506 
1507    
1508   function tokenURI(uint256 _tokenId)
1509     public
1510     view
1511     virtual
1512     override
1513     returns (string memory)
1514   {
1515     require(
1516       _exists(_tokenId),
1517       "ERC721Metadata: URI query for nonexistent token"
1518     );
1519     
1520   
1521 if ( reveal == false)
1522 {
1523     return hiddenURL;
1524 }
1525     
1526 
1527     string memory currentBaseURI = _baseURI();
1528     return bytes(currentBaseURI).length > 0
1529         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString() ,uriSuffix))
1530         : "";
1531   }
1532  
1533  
1534 
1535 
1536  function setFreeMaxLimitPerAddress(uint8 _limit) external onlyOwner{
1537     maxFreeMintAmountPerWallet = _limit;
1538    delete _limit;
1539 
1540 }
1541 
1542     
1543   
1544 
1545   function setUriPrefix(string memory _uriPrefix) external onlyOwner {
1546     uriPrefix = _uriPrefix;
1547   }
1548    function setHiddenUri(string memory _uriPrefix) external onlyOwner {
1549     hiddenURL = _uriPrefix;
1550   }
1551 
1552 
1553   function setPaused() external onlyOwner {
1554     paused = !paused;
1555    
1556   }
1557 
1558   function setCost(uint _cost) external onlyOwner{
1559       cost = _cost;
1560 
1561   }
1562 
1563  function setRevealed() external onlyOwner{
1564      reveal = !reveal;
1565  }
1566 
1567   function setMaxMintAmountPerTx(uint8 _maxtx) external onlyOwner{
1568       maxMintAmountPerTx = _maxtx;
1569 
1570   }
1571 
1572  
1573 
1574   function withdraw() external onlyOwner {
1575   uint _balance = address(this).balance;
1576      payable(msg.sender).transfer(_balance ); 
1577        
1578   }
1579 
1580 
1581   function _baseURI() internal view  override returns (string memory) {
1582     return uriPrefix;
1583   }
1584 
1585     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1586         super.transferFrom(from, to, tokenId);
1587     }
1588 
1589     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1590         super.safeTransferFrom(from, to, tokenId);
1591     }
1592 
1593     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1594         public
1595         override
1596         onlyAllowedOperator(from)
1597     {
1598         super.safeTransferFrom(from, to, tokenId, data);
1599     }
1600 }