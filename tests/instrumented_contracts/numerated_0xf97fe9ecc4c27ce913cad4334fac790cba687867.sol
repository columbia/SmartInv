1 /*******************************************************
2 ⣿⣿⣿⣿⣿⣿⣿⣿⠿⠛⢉⣉⣀⣠⣄⣈⠙⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
3 ⣿⣿⣿⣿⣿⣿⡟⢁⣴⣾⣿⣿⣿⣿⣿⣿⣿⣦⡈⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
4 ⣿⣿⣿⣿⣿⠏⣠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡀⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
5 ⣿⣿⣿⣿⠇⢰⣿⣿⣿⣿⣿⣿⡿⠟⠉⠉⣉⠻⣿⣧⠈⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
6 ⣿⣿⣿⡟⠄⠛⠛⢿⣿⣿⣿⡿⠁⠄⠄⠄⣿⡇⢸⣿⡄⢹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠋⢁⣄⣉⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
7 ⣿⣿⠋⠄⠄⠄⣷⡄⠋⣠⣿⣇⠄⢀⣀⡼⠟⢁⣼⣿⣧⠘⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠄⣿⣿⣿⡆⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿
8 ⣿⣿⠄⠄⢀⠴⠋⠄⡰⠟⠛⢻⣷⣤⣤⡤⠞⠋⢉⣿⣿⡀⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠄⣿⣿⣿⣿⠄⣿⣿⣿⣿⣿⣿⣿⣿⣿
9 ⣿⣿⣷⠄⣴⣶⣧⡀⠛⠉⣁⠼⠛⠋⣁⣤⣶⣿⣿⣿⣿⣧⠈⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡏⠄⣿⣿⣛⣿⠄⣿⣿⣿⣿⣿⣿⣿⣿⣿
10 ⣿⣿⣿⡀⣿⠿⠟⠛⠉⣁⣤⣴⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⡄⠹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠇⢸⣿⣿⣥⠇⢰⠟⠛⢿⣿⣿⣿⣿⣿⣿
11 ⣿⣿⣿⡇⢠⣴⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⢿⡟⠻⣿⣿⡄⠙⣿⣿⣿⠿⠛⢉⣡⣤⡄⢀⣿⣿⣿⠃⠄⣁⣔⣂⠄⣿⣿⣿⣿⣿⣿
12 ⣿⣿⣿⣷⠄⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡄⢿⡄⢻⣿⣿⡄⠘⠟⢁⣴⠿⢿⠿⠟⠁⠘⠛⠙⠛⠻⠿⣧⣤⣀⣠⣄⠈⣿⣿⣿⣿
13 ⣿⣿⣿⣿⡆⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⠸⣧⠈⣿⣿⣷⡄⢰⣿⠛⡶⢀⣤⣾⣿⣿⣿⣿⣿⣷⣦⡈⠻⠻⣏⠛⢀⣿⣿⣿⣿
14 ⣿⣿⣿⣿⣧⠄⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡆⢻⡆⢸⣿⣿⣿⣦⣿⣿⢠⣾⣿⣿⠟⣿⣿⣿⣿⣿⣿⣿⡀⢡⣤⣶⣾⣿⣿⣿⣿
15 ⣿⣿⣿⣿⣿⣆⠘⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⠈⣷⠘⣿⣿⣿⣿⣿⣿⣿⣿⣿⣯⣼⣿⣿⣿⣿⣿⣿⣿⡇⢸⣿⣿⣿⣿⣿⣿⣿
16 ⣿⣿⣿⣿⣿⣿⣧⠘⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⢘⣦⠤⣤⣉⠙⣿⣿⣿⣿⣿⣿⢿⣿⣿⣿⣿⣿⣿⡿⢀⣾⣿⣿⣿⣿⣿⣿⣿
17 ⣿⣿⣿⣿⣿⣿⣿⣧⡈⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠁⡎⠙⡀⢤⣤⣶⣿⣿⣿⣿⣿⣷⣾⣋⣿⣿⣿⣿⡟⢁⣼⣿⣿⣿⣿⣿⣿⣿⣿
18 ⣿⣿⣿⣿⣿⣿⣿⣿⣷⣄⠙⢿⣿⣿⣿⣿⣿⣿⣿⣿⣄⣁⣤⣀⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣼⡿⠋⢀⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿
19 ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡈⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠛⠛⠛⢉⣠⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
20 ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⣄⠙⠻⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⠋⠄⢻⡆⢰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
21 ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣶⣤⣀⣉⠉⠉⢉⠉⠉⠉⢉⣉⣠⣤⣶⣿⣇⠸⣧⠄⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
22 ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠇⣼⡀⢹⣿⣿⣿⣿⠄⠤⣤⣀⣀⣽⡆⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
23 ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠄⣿⠆⢻⣿⣿⣿⣿⣷⣤⣈⠙⠛⠿⢷⠄⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
24 ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣏⠠⣤⣉⠛⠄⣿⠄⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣶⣦⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
25 ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⡈⠛⠿⣶⡿⢀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
26 ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣦⣤⣀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
27 ********************************************************/
28 
29 // SPDX-License-Identifier: MIT
30 
31 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
32 
33 
34 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
35 
36 pragma solidity ^0.8.0;
37 
38 /**
39  * @dev Contract module that helps prevent reentrant calls to a function.
40  *
41  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
42  * available, which can be applied to functions to make sure there are no nested
43  * (reentrant) calls to them.
44  *
45  * Note that because there is a single `nonReentrant` guard, functions marked as
46  * `nonReentrant` may not call one another. This can be worked around by making
47  * those functions `private`, and then adding `external` `nonReentrant` entry
48  * points to them.
49  *
50  * TIP: If you would like to learn more about reentrancy and alternative ways
51  * to protect against it, check out our blog post
52  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
53  */
54 abstract contract ReentrancyGuard {
55     // Booleans are more expensive than uint256 or any type that takes up a full
56     // word because each write operation emits an extra SLOAD to first read the
57     // slot's contents, replace the bits taken up by the boolean, and then write
58     // back. This is the compiler's defense against contract upgrades and
59     // pointer aliasing, and it cannot be disabled.
60 
61     // The values being non-zero value makes deployment a bit more expensive,
62     // but in exchange the refund on every call to nonReentrant will be lower in
63     // amount. Since refunds are capped to a percentage of the total
64     // transaction's gas, it is best to keep them low in cases like this one, to
65     // increase the likelihood of the full refund coming into effect.
66     uint256 private constant _NOT_ENTERED = 1;
67     uint256 private constant _ENTERED = 2;
68 
69     uint256 private _status;
70 
71     constructor() {
72         _status = _NOT_ENTERED;
73     }
74 
75     /**
76      * @dev Prevents a contract from calling itself, directly or indirectly.
77      * Calling a `nonReentrant` function from another `nonReentrant`
78      * function is not supported. It is possible to prevent this from happening
79      * by making the `nonReentrant` function external, and making it call a
80      * `private` function that does the actual work.
81      */
82     modifier nonReentrant() {
83         // On the first call to nonReentrant, _notEntered will be true
84         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
85 
86         // Any calls to nonReentrant after this point will fail
87         _status = _ENTERED;
88 
89         _;
90 
91         // By storing the original value once again, a refund is triggered (see
92         // https://eips.ethereum.org/EIPS/eip-2200)
93         _status = _NOT_ENTERED;
94     }
95 }
96 
97 // File: @openzeppelin/contracts/utils/Strings.sol
98 
99 
100 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
101 
102 pragma solidity ^0.8.0;
103 
104 /**
105  * @dev String operations.
106  */
107 library Strings {
108     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
109 
110     /**
111      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
112      */
113     function toString(uint256 value) internal pure returns (string memory) {
114         // Inspired by OraclizeAPI's implementation - MIT licence
115         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
116 
117         if (value == 0) {
118             return "0";
119         }
120         uint256 temp = value;
121         uint256 digits;
122         while (temp != 0) {
123             digits++;
124             temp /= 10;
125         }
126         bytes memory buffer = new bytes(digits);
127         while (value != 0) {
128             digits -= 1;
129             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
130             value /= 10;
131         }
132         return string(buffer);
133     }
134 
135     /**
136      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
137      */
138     function toHexString(uint256 value) internal pure returns (string memory) {
139         if (value == 0) {
140             return "0x00";
141         }
142         uint256 temp = value;
143         uint256 length = 0;
144         while (temp != 0) {
145             length++;
146             temp >>= 8;
147         }
148         return toHexString(value, length);
149     }
150 
151     /**
152      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
153      */
154     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
155         bytes memory buffer = new bytes(2 * length + 2);
156         buffer[0] = "0";
157         buffer[1] = "x";
158         for (uint256 i = 2 * length + 1; i > 1; --i) {
159             buffer[i] = _HEX_SYMBOLS[value & 0xf];
160             value >>= 4;
161         }
162         require(value == 0, "Strings: hex length insufficient");
163         return string(buffer);
164     }
165 }
166 
167 // File: @openzeppelin/contracts/utils/Context.sol
168 
169 
170 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
171 
172 pragma solidity ^0.8.0;
173 
174 /**
175  * @dev Provides information about the current execution context, including the
176  * sender of the transaction and its data. While these are generally available
177  * via msg.sender and msg.data, they should not be accessed in such a direct
178  * manner, since when dealing with meta-transactions the account sending and
179  * paying for execution may not be the actual sender (as far as an application
180  * is concerned).
181  *
182  * This contract is only required for intermediate, library-like contracts.
183  */
184 abstract contract Context {
185     function _msgSender() internal view virtual returns (address) {
186         return msg.sender;
187     }
188 
189     function _msgData() internal view virtual returns (bytes calldata) {
190         return msg.data;
191     }
192 }
193 
194 // File: @openzeppelin/contracts/access/Ownable.sol
195 
196 
197 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
198 
199 pragma solidity ^0.8.0;
200 
201 
202 /**
203  * @dev Contract module which provides a basic access control mechanism, where
204  * there is an account (an owner) that can be granted exclusive access to
205  * specific functions.
206  *
207  * By default, the owner account will be the one that deploys the contract. This
208  * can later be changed with {transferOwnership}.
209  *
210  * This module is used through inheritance. It will make available the modifier
211  * `onlyOwner`, which can be applied to your functions to restrict their use to
212  * the owner.
213  */
214 abstract contract Ownable is Context {
215     address private _owner;
216 
217     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
218 
219     /**
220      * @dev Initializes the contract setting the deployer as the initial owner.
221      */
222     constructor() {
223         _transferOwnership(_msgSender());
224     }
225 
226     /**
227      * @dev Returns the address of the current owner.
228      */
229     function owner() public view virtual returns (address) {
230         return _owner;
231     }
232 
233     /**
234      * @dev Throws if called by any account other than the owner.
235      */
236     modifier onlyOwner() {
237         require(owner() == _msgSender(), "Ownable: caller is not the owner");
238         _;
239     }
240 
241     /**
242      * @dev Leaves the contract without owner. It will not be possible to call
243      * `onlyOwner` functions anymore. Can only be called by the current owner.
244      *
245      * NOTE: Renouncing ownership will leave the contract without an owner,
246      * thereby removing any functionality that is only available to the owner.
247      */
248     function renounceOwnership() public virtual onlyOwner {
249         _transferOwnership(address(0));
250     }
251 
252     /**
253      * @dev Transfers ownership of the contract to a new account (`newOwner`).
254      * Can only be called by the current owner.
255      */
256     function transferOwnership(address newOwner) public virtual onlyOwner {
257         require(newOwner != address(0), "Ownable: new owner is the zero address");
258         _transferOwnership(newOwner);
259     }
260 
261     /**
262      * @dev Transfers ownership of the contract to a new account (`newOwner`).
263      * Internal function without access restriction.
264      */
265     function _transferOwnership(address newOwner) internal virtual {
266         address oldOwner = _owner;
267         _owner = newOwner;
268         emit OwnershipTransferred(oldOwner, newOwner);
269     }
270 }
271 
272 // File: @openzeppelin/contracts/utils/Address.sol
273 
274 
275 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
276 
277 pragma solidity ^0.8.1;
278 
279 /**
280  * @dev Collection of functions related to the address type
281  */
282 library Address {
283     /**
284      * @dev Returns true if `account` is a contract.
285      *
286      * [IMPORTANT]
287      * ====
288      * It is unsafe to assume that an address for which this function returns
289      * false is an externally-owned account (EOA) and not a contract.
290      *
291      * Among others, `isContract` will return false for the following
292      * types of addresses:
293      *
294      *  - an externally-owned account
295      *  - a contract in construction
296      *  - an address where a contract will be created
297      *  - an address where a contract lived, but was destroyed
298      * ====
299      *
300      * [IMPORTANT]
301      * ====
302      * You shouldn't rely on `isContract` to protect against flash loan attacks!
303      *
304      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
305      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
306      * constructor.
307      * ====
308      */
309     function isContract(address account) internal view returns (bool) {
310         // This method relies on extcodesize/address.code.length, which returns 0
311         // for contracts in construction, since the code is only stored at the end
312         // of the constructor execution.
313 
314         return account.code.length > 0;
315     }
316 
317     /**
318      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
319      * `recipient`, forwarding all available gas and reverting on errors.
320      *
321      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
322      * of certain opcodes, possibly making contracts go over the 2300 gas limit
323      * imposed by `transfer`, making them unable to receive funds via
324      * `transfer`. {sendValue} removes this limitation.
325      *
326      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
327      *
328      * IMPORTANT: because control is transferred to `recipient`, care must be
329      * taken to not create reentrancy vulnerabilities. Consider using
330      * {ReentrancyGuard} or the
331      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
332      */
333     function sendValue(address payable recipient, uint256 amount) internal {
334         require(address(this).balance >= amount, "Address: insufficient balance");
335 
336         (bool success, ) = recipient.call{value: amount}("");
337         require(success, "Address: unable to send value, recipient may have reverted");
338     }
339 
340     /**
341      * @dev Performs a Solidity function call using a low level `call`. A
342      * plain `call` is an unsafe replacement for a function call: use this
343      * function instead.
344      *
345      * If `target` reverts with a revert reason, it is bubbled up by this
346      * function (like regular Solidity function calls).
347      *
348      * Returns the raw returned data. To convert to the expected return value,
349      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
350      *
351      * Requirements:
352      *
353      * - `target` must be a contract.
354      * - calling `target` with `data` must not revert.
355      *
356      * _Available since v3.1._
357      */
358     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
359         return functionCall(target, data, "Address: low-level call failed");
360     }
361 
362     /**
363      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
364      * `errorMessage` as a fallback revert reason when `target` reverts.
365      *
366      * _Available since v3.1._
367      */
368     function functionCall(
369         address target,
370         bytes memory data,
371         string memory errorMessage
372     ) internal returns (bytes memory) {
373         return functionCallWithValue(target, data, 0, errorMessage);
374     }
375 
376     /**
377      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
378      * but also transferring `value` wei to `target`.
379      *
380      * Requirements:
381      *
382      * - the calling contract must have an ETH balance of at least `value`.
383      * - the called Solidity function must be `payable`.
384      *
385      * _Available since v3.1._
386      */
387     function functionCallWithValue(
388         address target,
389         bytes memory data,
390         uint256 value
391     ) internal returns (bytes memory) {
392         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
393     }
394 
395     /**
396      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
397      * with `errorMessage` as a fallback revert reason when `target` reverts.
398      *
399      * _Available since v3.1._
400      */
401     function functionCallWithValue(
402         address target,
403         bytes memory data,
404         uint256 value,
405         string memory errorMessage
406     ) internal returns (bytes memory) {
407         require(address(this).balance >= value, "Address: insufficient balance for call");
408         require(isContract(target), "Address: call to non-contract");
409 
410         (bool success, bytes memory returndata) = target.call{value: value}(data);
411         return verifyCallResult(success, returndata, errorMessage);
412     }
413 
414     /**
415      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
416      * but performing a static call.
417      *
418      * _Available since v3.3._
419      */
420     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
421         return functionStaticCall(target, data, "Address: low-level static call failed");
422     }
423 
424     /**
425      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
426      * but performing a static call.
427      *
428      * _Available since v3.3._
429      */
430     function functionStaticCall(
431         address target,
432         bytes memory data,
433         string memory errorMessage
434     ) internal view returns (bytes memory) {
435         require(isContract(target), "Address: static call to non-contract");
436 
437         (bool success, bytes memory returndata) = target.staticcall(data);
438         return verifyCallResult(success, returndata, errorMessage);
439     }
440 
441     /**
442      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
443      * but performing a delegate call.
444      *
445      * _Available since v3.4._
446      */
447     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
448         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
449     }
450 
451     /**
452      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
453      * but performing a delegate call.
454      *
455      * _Available since v3.4._
456      */
457     function functionDelegateCall(
458         address target,
459         bytes memory data,
460         string memory errorMessage
461     ) internal returns (bytes memory) {
462         require(isContract(target), "Address: delegate call to non-contract");
463 
464         (bool success, bytes memory returndata) = target.delegatecall(data);
465         return verifyCallResult(success, returndata, errorMessage);
466     }
467 
468     /**
469      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
470      * revert reason using the provided one.
471      *
472      * _Available since v4.3._
473      */
474     function verifyCallResult(
475         bool success,
476         bytes memory returndata,
477         string memory errorMessage
478     ) internal pure returns (bytes memory) {
479         if (success) {
480             return returndata;
481         } else {
482             // Look for revert reason and bubble it up if present
483             if (returndata.length > 0) {
484                 // The easiest way to bubble the revert reason is using memory via assembly
485 
486                 assembly {
487                     let returndata_size := mload(returndata)
488                     revert(add(32, returndata), returndata_size)
489                 }
490             } else {
491                 revert(errorMessage);
492             }
493         }
494     }
495 }
496 
497 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
498 
499 
500 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
501 
502 pragma solidity ^0.8.0;
503 
504 /**
505  * @title ERC721 token receiver interface
506  * @dev Interface for any contract that wants to support safeTransfers
507  * from ERC721 asset contracts.
508  */
509 interface IERC721Receiver {
510     /**
511      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
512      * by `operator` from `from`, this function is called.
513      *
514      * It must return its Solidity selector to confirm the token transfer.
515      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
516      *
517      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
518      */
519     function onERC721Received(
520         address operator,
521         address from,
522         uint256 tokenId,
523         bytes calldata data
524     ) external returns (bytes4);
525 }
526 
527 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
528 
529 
530 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
531 
532 pragma solidity ^0.8.0;
533 
534 /**
535  * @dev Interface of the ERC165 standard, as defined in the
536  * https://eips.ethereum.org/EIPS/eip-165[EIP].
537  *
538  * Implementers can declare support of contract interfaces, which can then be
539  * queried by others ({ERC165Checker}).
540  *
541  * For an implementation, see {ERC165}.
542  */
543 interface IERC165 {
544     /**
545      * @dev Returns true if this contract implements the interface defined by
546      * `interfaceId`. See the corresponding
547      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
548      * to learn more about how these ids are created.
549      *
550      * This function call must use less than 30 000 gas.
551      */
552     function supportsInterface(bytes4 interfaceId) external view returns (bool);
553 }
554 
555 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
556 
557 
558 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
559 
560 pragma solidity ^0.8.0;
561 
562 
563 /**
564  * @dev Implementation of the {IERC165} interface.
565  *
566  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
567  * for the additional interface id that will be supported. For example:
568  *
569  * ```solidity
570  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
571  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
572  * }
573  * ```
574  *
575  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
576  */
577 abstract contract ERC165 is IERC165 {
578     /**
579      * @dev See {IERC165-supportsInterface}.
580      */
581     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
582         return interfaceId == type(IERC165).interfaceId;
583     }
584 }
585 
586 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
587 
588 
589 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
590 
591 pragma solidity ^0.8.0;
592 
593 
594 /**
595  * @dev Required interface of an ERC721 compliant contract.
596  */
597 interface IERC721 is IERC165 {
598     /**
599      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
600      */
601     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
602 
603     /**
604      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
605      */
606     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
607 
608     /**
609      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
610      */
611     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
612 
613     /**
614      * @dev Returns the number of tokens in ``owner``'s account.
615      */
616     function balanceOf(address owner) external view returns (uint256 balance);
617 
618     /**
619      * @dev Returns the owner of the `tokenId` token.
620      *
621      * Requirements:
622      *
623      * - `tokenId` must exist.
624      */
625     function ownerOf(uint256 tokenId) external view returns (address owner);
626 
627     /**
628      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
629      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
630      *
631      * Requirements:
632      *
633      * - `from` cannot be the zero address.
634      * - `to` cannot be the zero address.
635      * - `tokenId` token must exist and be owned by `from`.
636      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
637      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
638      *
639      * Emits a {Transfer} event.
640      */
641     function safeTransferFrom(
642         address from,
643         address to,
644         uint256 tokenId
645     ) external;
646 
647     /**
648      * @dev Transfers `tokenId` token from `from` to `to`.
649      *
650      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
651      *
652      * Requirements:
653      *
654      * - `from` cannot be the zero address.
655      * - `to` cannot be the zero address.
656      * - `tokenId` token must be owned by `from`.
657      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
658      *
659      * Emits a {Transfer} event.
660      */
661     function transferFrom(
662         address from,
663         address to,
664         uint256 tokenId
665     ) external;
666 
667     /**
668      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
669      * The approval is cleared when the token is transferred.
670      *
671      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
672      *
673      * Requirements:
674      *
675      * - The caller must own the token or be an approved operator.
676      * - `tokenId` must exist.
677      *
678      * Emits an {Approval} event.
679      */
680     function approve(address to, uint256 tokenId) external;
681 
682     /**
683      * @dev Returns the account approved for `tokenId` token.
684      *
685      * Requirements:
686      *
687      * - `tokenId` must exist.
688      */
689     function getApproved(uint256 tokenId) external view returns (address operator);
690 
691     /**
692      * @dev Approve or remove `operator` as an operator for the caller.
693      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
694      *
695      * Requirements:
696      *
697      * - The `operator` cannot be the caller.
698      *
699      * Emits an {ApprovalForAll} event.
700      */
701     function setApprovalForAll(address operator, bool _approved) external;
702 
703     /**
704      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
705      *
706      * See {setApprovalForAll}
707      */
708     function isApprovedForAll(address owner, address operator) external view returns (bool);
709 
710     /**
711      * @dev Safely transfers `tokenId` token from `from` to `to`.
712      *
713      * Requirements:
714      *
715      * - `from` cannot be the zero address.
716      * - `to` cannot be the zero address.
717      * - `tokenId` token must exist and be owned by `from`.
718      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
719      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
720      *
721      * Emits a {Transfer} event.
722      */
723     function safeTransferFrom(
724         address from,
725         address to,
726         uint256 tokenId,
727         bytes calldata data
728     ) external;
729 }
730 
731 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
732 
733 
734 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
735 
736 pragma solidity ^0.8.0;
737 
738 
739 /**
740  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
741  * @dev See https://eips.ethereum.org/EIPS/eip-721
742  */
743 interface IERC721Enumerable is IERC721 {
744     /**
745      * @dev Returns the total amount of tokens stored by the contract.
746      */
747     function totalSupply() external view returns (uint256);
748 
749     /**
750      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
751      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
752      */
753     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
754 
755     /**
756      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
757      * Use along with {totalSupply} to enumerate all tokens.
758      */
759     function tokenByIndex(uint256 index) external view returns (uint256);
760 }
761 
762 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
763 
764 
765 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
766 
767 pragma solidity ^0.8.0;
768 
769 
770 /**
771  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
772  * @dev See https://eips.ethereum.org/EIPS/eip-721
773  */
774 interface IERC721Metadata is IERC721 {
775     /**
776      * @dev Returns the token collection name.
777      */
778     function name() external view returns (string memory);
779 
780     /**
781      * @dev Returns the token collection symbol.
782      */
783     function symbol() external view returns (string memory);
784 
785     /**
786      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
787      */
788     function tokenURI(uint256 tokenId) external view returns (string memory);
789 }
790 
791 // File: contracts/ERC721A.sol
792 
793 
794 // Creator: Chiru Labs
795 
796 pragma solidity ^0.8.4;
797 
798 
799 
800 
801 
802 
803 
804 
805 
806 error ApprovalCallerNotOwnerNorApproved();
807 error ApprovalQueryForNonexistentToken();
808 error ApproveToCaller();
809 error ApprovalToCurrentOwner();
810 error BalanceQueryForZeroAddress();
811 error MintedQueryForZeroAddress();
812 error MintToZeroAddress();
813 error MintZeroQuantity();
814 error OwnerIndexOutOfBounds();
815 error OwnerQueryForNonexistentToken();
816 error TokenIndexOutOfBounds();
817 error TransferCallerNotOwnerNorApproved();
818 error TransferFromIncorrectOwner();
819 error TransferToNonERC721ReceiverImplementer();
820 error TransferToZeroAddress();
821 error UnableDetermineTokenOwner();
822 error URIQueryForNonexistentToken();
823 
824 /**
825  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
826  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
827  *
828  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
829  *
830  * Does not support burning tokens to address(0).
831  *
832  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
833  */
834 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
835     using Address for address;
836     using Strings for uint256;
837 
838     struct TokenOwnership {
839         address addr;
840         uint64 startTimestamp;
841     }
842 
843     struct AddressData {
844         uint128 balance;
845         uint128 numberMinted;
846     }
847 
848     uint256 internal _currentIndex;
849 
850     // Token name
851     string private _name;
852 
853     // Token symbol
854     string private _symbol;
855 
856     // Mapping from token ID to ownership details
857     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
858     mapping(uint256 => TokenOwnership) internal _ownerships;
859 
860     // Mapping owner address to address data
861     mapping(address => AddressData) private _addressData;
862 
863     // Mapping from token ID to approved address
864     mapping(uint256 => address) private _tokenApprovals;
865 
866     // Mapping from owner to operator approvals
867     mapping(address => mapping(address => bool)) private _operatorApprovals;
868 
869     constructor(string memory name_, string memory symbol_) {
870         _name = name_;
871         _symbol = symbol_;
872     }
873 
874     /**
875      * @dev See {IERC721Enumerable-totalSupply}.
876      */
877     function totalSupply() public view override returns (uint256) {
878         return _currentIndex;
879     }
880 
881     /**
882      * @dev See {IERC721Enumerable-tokenByIndex}.
883      */
884     function tokenByIndex(uint256 index) public view override returns (uint256) {
885         if (index >= totalSupply()) revert TokenIndexOutOfBounds();
886         return index;
887     }
888 
889     /**
890      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
891      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
892      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
893      */
894     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
895         if (index >= balanceOf(owner)) revert OwnerIndexOutOfBounds();
896         uint256 numMintedSoFar = totalSupply();
897         uint256 tokenIdsIdx;
898         address currOwnershipAddr;
899 
900         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
901         unchecked {
902             for (uint256 i; i < numMintedSoFar; i++) {
903                 TokenOwnership memory ownership = _ownerships[i];
904                 if (ownership.addr != address(0)) {
905                     currOwnershipAddr = ownership.addr;
906                 }
907                 if (currOwnershipAddr == owner) {
908                     if (tokenIdsIdx == index) {
909                         return i;
910                     }
911                     tokenIdsIdx++;
912                 }
913             }
914         }
915 
916         // Execution should never reach this point.
917         assert(false);
918     }
919 
920     /**
921      * @dev See {IERC165-supportsInterface}.
922      */
923     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
924         return
925             interfaceId == type(IERC721).interfaceId ||
926             interfaceId == type(IERC721Metadata).interfaceId ||
927             interfaceId == type(IERC721Enumerable).interfaceId ||
928             super.supportsInterface(interfaceId);
929     }
930 
931     /**
932      * @dev See {IERC721-balanceOf}.
933      */
934     function balanceOf(address owner) public view override returns (uint256) {
935         if (owner == address(0)) revert BalanceQueryForZeroAddress();
936         return uint256(_addressData[owner].balance);
937     }
938 
939     function _numberMinted(address owner) internal view returns (uint256) {
940         if (owner == address(0)) revert MintedQueryForZeroAddress();
941         return uint256(_addressData[owner].numberMinted);
942     }
943 
944     /**
945      * Gas spent here starts off proportional to the maximum mint batch size.
946      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
947      */
948     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
949         if (!_exists(tokenId)) revert OwnerQueryForNonexistentToken();
950 
951         unchecked {
952             for (uint256 curr = tokenId;; curr--) {
953                 TokenOwnership memory ownership = _ownerships[curr];
954                 if (ownership.addr != address(0)) {
955                     return ownership;
956                 }
957             }
958         }
959     }
960 
961     /**
962      * @dev See {IERC721-ownerOf}.
963      */
964     function ownerOf(uint256 tokenId) public view override returns (address) {
965         return ownershipOf(tokenId).addr;
966     }
967 
968     /**
969      * @dev See {IERC721Metadata-name}.
970      */
971     function name() public view virtual override returns (string memory) {
972         return _name;
973     }
974 
975     /**
976      * @dev See {IERC721Metadata-symbol}.
977      */
978     function symbol() public view virtual override returns (string memory) {
979         return _symbol;
980     }
981 
982     /**
983      * @dev See {IERC721Metadata-tokenURI}.
984      */
985     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
986         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
987 
988         string memory baseURI = _baseURI();
989         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
990     }
991 
992     /**
993      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
994      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
995      * by default, can be overriden in child contracts.
996      */
997     function _baseURI() internal view virtual returns (string memory) {
998         return '';
999     }
1000 
1001     /**
1002      * @dev See {IERC721-approve}.
1003      */
1004     function approve(address to, uint256 tokenId) public override {
1005         address owner = ERC721A.ownerOf(tokenId);
1006         if (to == owner) revert ApprovalToCurrentOwner();
1007 
1008         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) revert ApprovalCallerNotOwnerNorApproved();
1009 
1010         _approve(to, tokenId, owner);
1011     }
1012 
1013     /**
1014      * @dev See {IERC721-getApproved}.
1015      */
1016     function getApproved(uint256 tokenId) public view override returns (address) {
1017         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1018 
1019         return _tokenApprovals[tokenId];
1020     }
1021 
1022     /**
1023      * @dev See {IERC721-setApprovalForAll}.
1024      */
1025     function setApprovalForAll(address operator, bool approved) public override {
1026         if (operator == _msgSender()) revert ApproveToCaller();
1027 
1028         _operatorApprovals[_msgSender()][operator] = approved;
1029         emit ApprovalForAll(_msgSender(), operator, approved);
1030     }
1031 
1032     /**
1033      * @dev See {IERC721-isApprovedForAll}.
1034      */
1035     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1036         return _operatorApprovals[owner][operator];
1037     }
1038 
1039     /**
1040      * @dev See {IERC721-transferFrom}.
1041      */
1042     function transferFrom(
1043         address from,
1044         address to,
1045         uint256 tokenId
1046     ) public virtual override {
1047         _transfer(from, to, tokenId);
1048     }
1049 
1050     /**
1051      * @dev See {IERC721-safeTransferFrom}.
1052      */
1053     function safeTransferFrom(
1054         address from,
1055         address to,
1056         uint256 tokenId
1057     ) public virtual override {
1058         safeTransferFrom(from, to, tokenId, '');
1059     }
1060 
1061     /**
1062      * @dev See {IERC721-safeTransferFrom}.
1063      */
1064     function safeTransferFrom(
1065         address from,
1066         address to,
1067         uint256 tokenId,
1068         bytes memory _data
1069     ) public override {
1070         _transfer(from, to, tokenId);
1071         if (!_checkOnERC721Received(from, to, tokenId, _data)) revert TransferToNonERC721ReceiverImplementer();
1072     }
1073 
1074     /**
1075      * @dev Returns whether `tokenId` exists.
1076      *
1077      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1078      *
1079      * Tokens start existing when they are minted (`_mint`),
1080      */
1081     function _exists(uint256 tokenId) internal view returns (bool) {
1082         return tokenId < _currentIndex;
1083     }
1084 
1085     function _safeMint(address to, uint256 quantity) internal {
1086         _safeMint(to, quantity, '');
1087     }
1088 
1089     /**
1090      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1091      *
1092      * Requirements:
1093      *
1094      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1095      * - `quantity` must be greater than 0.
1096      *
1097      * Emits a {Transfer} event.
1098      */
1099     function _safeMint(
1100         address to,
1101         uint256 quantity,
1102         bytes memory _data
1103     ) internal {
1104         _mint(to, quantity, _data, true);
1105     }
1106 
1107     /**
1108      * @dev Mints `quantity` tokens and transfers them to `to`.
1109      *
1110      * Requirements:
1111      *
1112      * - `to` cannot be the zero address.
1113      * - `quantity` must be greater than 0.
1114      *
1115      * Emits a {Transfer} event.
1116      */
1117     function _mint(
1118         address to,
1119         uint256 quantity,
1120         bytes memory _data,
1121         bool safe
1122     ) internal {
1123         uint256 startTokenId = _currentIndex;
1124         if (to == address(0)) revert MintToZeroAddress();
1125         if (quantity == 0) revert MintZeroQuantity();
1126 
1127         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1128 
1129         // Overflows are incredibly unrealistic.
1130         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1131         // updatedIndex overflows if _currentIndex + quantity > 1.56e77 (2**256) - 1
1132         unchecked {
1133             _addressData[to].balance += uint128(quantity);
1134             _addressData[to].numberMinted += uint128(quantity);
1135 
1136             _ownerships[startTokenId].addr = to;
1137             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1138 
1139             uint256 updatedIndex = startTokenId;
1140 
1141             for (uint256 i; i < quantity; i++) {
1142                 emit Transfer(address(0), to, updatedIndex);
1143                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
1144                     revert TransferToNonERC721ReceiverImplementer();
1145                 }
1146 
1147                 updatedIndex++;
1148             }
1149 
1150             _currentIndex = updatedIndex;
1151         }
1152 
1153         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1154     }
1155 
1156     /**
1157      * @dev Transfers `tokenId` from `from` to `to`.
1158      *
1159      * Requirements:
1160      *
1161      * - `to` cannot be the zero address.
1162      * - `tokenId` token must be owned by `from`.
1163      *
1164      * Emits a {Transfer} event.
1165      */
1166     function _transfer(
1167         address from,
1168         address to,
1169         uint256 tokenId
1170     ) private {
1171         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1172 
1173         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1174             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1175             getApproved(tokenId) == _msgSender());
1176 
1177         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1178         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1179         if (to == address(0)) revert TransferToZeroAddress();
1180 
1181         _beforeTokenTransfers(from, to, tokenId, 1);
1182 
1183         // Clear approvals from the previous owner
1184         _approve(address(0), tokenId, prevOwnership.addr);
1185 
1186         // Underflow of the sender's balance is impossible because we check for
1187         // ownership above and the recipient's balance can't realistically overflow.
1188         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1189         unchecked {
1190             _addressData[from].balance -= 1;
1191             _addressData[to].balance += 1;
1192 
1193             _ownerships[tokenId].addr = to;
1194             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1195 
1196             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1197             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1198             uint256 nextTokenId = tokenId + 1;
1199             if (_ownerships[nextTokenId].addr == address(0)) {
1200                 if (_exists(nextTokenId)) {
1201                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1202                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1203                 }
1204             }
1205         }
1206 
1207         emit Transfer(from, to, tokenId);
1208         _afterTokenTransfers(from, to, tokenId, 1);
1209     }
1210 
1211     /**
1212      * @dev Approve `to` to operate on `tokenId`
1213      *
1214      * Emits a {Approval} event.
1215      */
1216     function _approve(
1217         address to,
1218         uint256 tokenId,
1219         address owner
1220     ) private {
1221         _tokenApprovals[tokenId] = to;
1222         emit Approval(owner, to, tokenId);
1223     }
1224 
1225     /**
1226      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1227      * The call is not executed if the target address is not a contract.
1228      *
1229      * @param from address representing the previous owner of the given token ID
1230      * @param to target address that will receive the tokens
1231      * @param tokenId uint256 ID of the token to be transferred
1232      * @param _data bytes optional data to send along with the call
1233      * @return bool whether the call correctly returned the expected magic value
1234      */
1235     function _checkOnERC721Received(
1236         address from,
1237         address to,
1238         uint256 tokenId,
1239         bytes memory _data
1240     ) private returns (bool) {
1241         if (to.isContract()) {
1242             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1243                 return retval == IERC721Receiver(to).onERC721Received.selector;
1244             } catch (bytes memory reason) {
1245                 if (reason.length == 0) revert TransferToNonERC721ReceiverImplementer();
1246                 else {
1247                     assembly {
1248                         revert(add(32, reason), mload(reason))
1249                     }
1250                 }
1251             }
1252         } else {
1253             return true;
1254         }
1255     }
1256 
1257     /**
1258      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1259      *
1260      * startTokenId - the first token id to be transferred
1261      * quantity - the amount to be transferred
1262      *
1263      * Calling conditions:
1264      *
1265      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1266      * transferred to `to`.
1267      * - When `from` is zero, `tokenId` will be minted for `to`.
1268      */
1269     function _beforeTokenTransfers(
1270         address from,
1271         address to,
1272         uint256 startTokenId,
1273         uint256 quantity
1274     ) internal virtual {}
1275 
1276     /**
1277      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1278      * minting.
1279      *
1280      * startTokenId - the first token id to be transferred
1281      * quantity - the amount to be transferred
1282      *
1283      * Calling conditions:
1284      *
1285      * - when `from` and `to` are both non-zero.
1286      * - `from` and `to` are never both zero.
1287      */
1288     function _afterTokenTransfers(
1289         address from,
1290         address to,
1291         uint256 startTokenId,
1292         uint256 quantity
1293     ) internal virtual {}
1294 }
1295 
1296 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
1297 
1298 pragma solidity ^0.8.0;
1299 
1300 /**
1301  * @dev These functions deal with verification of Merkle Trees proofs.
1302  *
1303  * The proofs can be generated using the JavaScript library
1304  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1305  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1306  *
1307  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1308  *
1309  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1310  * hashing, or use a hash function other than keccak256 for hashing leaves.
1311  * This is because the concatenation of a sorted pair of internal nodes in
1312  * the merkle tree could be reinterpreted as a leaf value.
1313  */
1314 library MerkleProof {
1315     /**
1316      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1317      * defined by `root`. For this, a `proof` must be provided, containing
1318      * sibling hashes on the branch from the leaf to the root of the tree. Each
1319      * pair of leaves and each pair of pre-images are assumed to be sorted.
1320      */
1321     function verify(
1322         bytes32[] memory proof,
1323         bytes32 root,
1324         bytes32 leaf
1325     ) internal pure returns (bool) {
1326         return processProof(proof, leaf) == root;
1327     }
1328 
1329     /**
1330      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1331      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1332      * hash matches the root of the tree. When processing the proof, the pairs
1333      * of leafs & pre-images are assumed to be sorted.
1334      *
1335      * _Available since v4.4._
1336      */
1337     function processProof(bytes32[] memory proof, bytes32 leaf)
1338         internal
1339         pure
1340         returns (bytes32)
1341     {
1342         bytes32 computedHash = leaf;
1343         for (uint256 i = 0; i < proof.length; i++) {
1344             bytes32 proofElement = proof[i];
1345             if (computedHash <= proofElement) {
1346                 // Hash(current computed hash + current element of the proof)
1347                 computedHash = _efficientHash(computedHash, proofElement);
1348             } else {
1349                 // Hash(current element of the proof + current computed hash)
1350                 computedHash = _efficientHash(proofElement, computedHash);
1351             }
1352         }
1353         return computedHash;
1354     }
1355 
1356     function _efficientHash(bytes32 a, bytes32 b)
1357         private
1358         pure
1359         returns (bytes32 value)
1360     {
1361         assembly {
1362             mstore(0x00, a)
1363             mstore(0x20, b)
1364             value := keccak256(0x00, 0x40)
1365         }
1366     }
1367 }
1368 
1369 // File: contracts/dicktoadz.sol
1370 
1371 pragma solidity ^0.8.0;
1372 
1373 contract DickToadz is ERC721A, Ownable, ReentrancyGuard {
1374   using Address for address;
1375   using Strings for uint;
1376 
1377   uint256 public maxSupply = 5200;
1378   uint256 public pricePerToken = 0.069 ether;
1379   uint256 public maxMintAmountPerWallet = 10;
1380   bool public mintIsActive = false;
1381   bool public tierOneMintIsActive = false;
1382   bool public publicMintIsActive = false;
1383 
1384   bytes32 public merkleRootOne;
1385 
1386   mapping(address => uint256) public addressMinted;
1387 
1388   string public _baseTokenURI;
1389 
1390   constructor() ERC721A("DickToadz", "DTOADZ") {}
1391 
1392   function tierOneMint(bytes32[] calldata _merkleProof, uint256 quantity) external payable {
1393     require(mintIsActive, "Not open for minting.");
1394     require(tierOneMintIsActive, "Tier One is not open for minting.");
1395     bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1396     require(MerkleProof.verify(_merkleProof, merkleRootOne, leaf), "Invalid proof.");
1397     require(totalSupply() + quantity <= maxSupply, "Minted Out!");
1398     require(addressMinted[msg.sender] + quantity <= maxMintAmountPerWallet, "Can only mint 10 per wallet.");
1399     require(quantity <= maxMintAmountPerWallet, "Can only mint 10 per wallet.");
1400     require(pricePerToken * quantity <= msg.value, "It is 0.069 per token.");
1401     addressMinted[msg.sender] += quantity;
1402     _safeMint(msg.sender, quantity);
1403   }
1404 
1405   function publicMint(uint256 quantity) external payable {
1406     require(mintIsActive, "Not open for minting.");
1407     require(publicMintIsActive, "Not open for public minting.");
1408     require(totalSupply() + quantity <= maxSupply, "Minted Out!");
1409     require(addressMinted[msg.sender] + quantity <= maxMintAmountPerWallet, "Can only mint 10 per wallet.");
1410     require(quantity <= maxMintAmountPerWallet, "Can only mint 10 per wallet.");
1411     require(pricePerToken * quantity <= msg.value, "It is 0.069 per token.");
1412     addressMinted[msg.sender] += quantity;
1413     _safeMint(msg.sender, quantity);
1414   }
1415 
1416   // dev mint special tokens 
1417   function devMint(uint256 quantity) external onlyOwner {
1418     _safeMint(msg.sender, quantity);
1419   }
1420 
1421   function setBaseURI(string memory baseURI) external onlyOwner {
1422     _baseTokenURI = baseURI;
1423   }
1424 
1425   function withdraw() public onlyOwner nonReentrant {
1426     uint total = address(this).balance;
1427     Address.sendValue(payable(0x011B63A4ccBc5bD55F9Fb9fbEDA3525cA6707451), total * 2090/10000);
1428     Address.sendValue(payable(0x099dd85261862A729A58d67649e8056B3df9904f), total * 2090/10000);
1429     Address.sendValue(payable(0x2255374629CA8EA9f862d5867124521AA3a90151), total * 1254/10000);
1430     Address.sendValue(payable(0x31C1b03EC94EC958DD6E53351f1760f8FF72946B), total * 1115/10000);
1431     Address.sendValue(payable(0xE209B86Fab947e6716aEF53C00CEAC7a2bF3C586), total * 1115/10000);
1432     Address.sendValue(payable(0xc8FA8f3589dD37488433CB78f8E9160e81AcF6Cf), total * 1115/10000);
1433     Address.sendValue(payable(0xF14d484b29A8aC040FEb489aFADB4b972422B4E9), total * 557/10000);
1434     Address.sendValue(payable(0x7e9656C4B7F56FA280Ba20D1667c8CDd923fe9Bd), total * 557/10000);
1435     Address.sendValue(payable(0xc9F972796C4e2494044BcaB703482AE5df6f3438), total * 107/10000);
1436   }
1437 
1438   function setMintState(bool newState) external onlyOwner {
1439     mintIsActive = newState;
1440   }
1441 
1442   function setTierOneState(bool newState) external onlyOwner {
1443     tierOneMintIsActive = newState;
1444   }
1445 
1446   function setPublicState(bool newState) external onlyOwner {
1447     publicMintIsActive = newState;
1448   }
1449 
1450   function mintState() public view returns (bool) {
1451     return mintIsActive;
1452   }
1453 
1454   function tierOneMintState() public view returns (bool) {
1455     return tierOneMintIsActive;
1456   }
1457 
1458   function publicMintState() public view returns (bool) {
1459     return publicMintIsActive;
1460   }
1461 
1462   function setMerkleRootOne(bytes32 newMerkleRoot) external onlyOwner {
1463     merkleRootOne = newMerkleRoot;
1464   }
1465 
1466   function tokenURI(uint _tokenId) public view virtual override returns (string memory) {
1467     require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
1468     return string(abi.encodePacked(_baseTokenURI, _tokenId.toString()));
1469   }
1470 
1471   function _baseURI() internal view virtual override returns (string memory) {
1472     return _baseTokenURI;
1473   }
1474 
1475   function setMaxMintAmountPerWallet(uint256 newAmount) external onlyOwner {
1476     maxMintAmountPerWallet = newAmount;
1477   }
1478 
1479   function setTokenCost(uint256 newCost) external onlyOwner {
1480     pricePerToken = newCost;
1481   }
1482 
1483 }