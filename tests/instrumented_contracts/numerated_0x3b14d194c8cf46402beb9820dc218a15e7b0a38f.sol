1 // SPDX-License-Identifier: GPL-3.0
2 /**
3 *    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣤⣶⣶⣶⣶⣶⣦⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
4 *⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
5 *⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⢿⣿⣿⡿⣿⣿⣿⣿⣿⣿⣿⣿⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
6 *⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣿⣿⣿⣿⡇⣿⣷⣿⣿⣿⣿⣿⣿⣯⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
7 *⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡰⣿⣿⣿⣇⣿⣀⠸⡟⢹⣿⣿⣿⣿⣿⣿⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
8 *⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⢡⣿⣿⣿⡇⠝⠋⠀⠀⠀⢿⢿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
9 *⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⢸⠸⣿⣿⣇⠀⠀⠀⠀⠀⠀⠊⣽⣿⣿⣿⠁⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
10 *⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⣿⣿⣷⣄⠀⠀⠀⢠⣴⣿⣿⣿⠋⣠⡏⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
11 *⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⠾⣿⣟⡻⠉⠀⠀⠀⠈⢿⠋⣿⡿⠚⠋⠁⡁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
12 *⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣶⣾⣿⣿⡄⠀⣳⡶⡦⡀⣿⣿⣷⣶⣤⡾⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
13 *⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⡆⠀⡇⡿⠉⣺⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
14 *⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣯⠽⢲⠇⠣⠐⠚⢻⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
15 *⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⡐⣾⡏⣷⠀⠀⣼⣷⡧⣿⣿⣦⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀
16 *⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣻⣿⣿⣿⣿⣿⣮⠳⣿⣇⢈⣿⠟⣬⣿⣿⣿⣿⣿⡦⢄⠀⠀⠀⠀⠀⠀⠀
17 *⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⢄⣾⣿⣿⣿⣿⣿⣿⣿⣷⣜⢿⣼⢏⣾⣿⣿⣿⢻⣿⣝⣿⣦⡑⢄⠀⠀⠀⠀⠀
18 *⠀⠀⠀⠀⠀⠀⠀⣠⣶⣷⣿⣿⠃⠘⣿⣿⣿⣿⣿⣿⣿⡷⣥⣿⣿⣿⣿⣿⠀⠹⣿⣿⣿⣷⡀⠀⠀⠀⠀⠀
19 *⠀⠀⠀⠀⣇⣤⣾⣿⣿⡿⠻⡏⠀⠀⠸⣿⣿⣿⣿⣿⣿⣮⣾⣿⣿⣿⣿⡇⠀⠀⠙⣿⣿⡿⡇⠀⠀⠀⠀⠀
20 *⠀⠀⢀⡴⣫⣿⣿⣿⠋⠀⠀⡇⠀⠀⢰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⢘⣿⣿⣟⢦⡸⠀⠀⠀
21 *⠀⡰⠋⣴⣿⣟⣿⠃⠀⠀⠀⠈⠀⠀⣸⣿⣿⣿⣿⣿⣿⣇⣽⣿⣿⣿⣿⣇⠀⠀⠀⠁⠸⣿⢻⣦⠉⢆⠀⠀
22 *⢠⠇⡔⣿⠏⠏⠙⠆⠀⠀⠀⠀⢀⣜⣛⡻⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⡀⠀⠀⠀⠀⡇⡇⠹⣷⡈⡄⠀
23 *⠀⡸⣴⡏⠀⠀⠀⠀⠀⠀⠀⢀⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣻⣿⣿⣿⣿⣿⣿⡄⠀⠀⠀⡇⡇⠀⢻⡿⡇⠀
24 *⠀⣿⣿⣆⠀⠀⠀⠀⠀⠀⢀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡀⠀⣰⠿⠤⠒⡛⢹⣿⠄
25 *⠀⣿⣷⡆⠁⠀⠀⠀⠀⢠⣿⣿⠟⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠻⢷⡀⠀⠀⠀⠀⠀⣸⣿⠀
26 *⠀⠈⠿⢿⣄⠀⠀⠀⢞⠌⡹⠁⠀⠀⢻⡇⠹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠁⢳⠀⠀⠁⠀⠀⠀⠀⢠⣿⡏⠀
27 *⠀⠀⠀⠈⠂⠀⠀⠀⠈⣿⠁⠀⠀⠀⡇⠁⠀⠘⢿⣿⣿⠿⠟⠋⠛⠛⠛⠀⢸⠀⠀⡀⠂⠀⠀⠐⠛⠉⠀⠀
28 *⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⠕⣠⡄⣰⡇⠀⠀⠀⢸⣧⠀⠀⠀⠀⠀⠀⠀⢀⣸⠠⡪⠊⠀⠀⠀⠀⠀⠀⠀⠀
29 *⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢫⣽⡋⠭⠶⠮⢽⣿⣆⠀⠀⠀⠀⢠⣿⣓⣽⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
30 *⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⢹⣶⣦⣾⣿⣿⣿⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀
31 *
32 *        ____       _______    _______      __    
33 *       / __ \___  / ____(_)  / ____(_)____/ /____
34 *      / / / / _ \/ /_  / /  / / __/ / ___/ / ___/
35 *     / /_/ /  __/ __/ / /  / /_/ / / /  / (__  ) 
36 *    /_____/\___/_/   /_/   \____/_/_/  /_/____/  
37 *
38 *    Free Mint, Launched via https://DeFiGirls.io
39 *               Twitter: @DeFiGirlsNFT           
40 **/
41 
42 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.7/contracts/security/ReentrancyGuard.sol
43 
44 
45 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
46 
47 pragma solidity ^0.8.0;
48 
49 /**
50  * @dev Contract module that helps prevent reentrant calls to a function.
51  *
52  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
53  * available, which can be applied to functions to make sure there are no nested
54  * (reentrant) calls to them.
55  *
56  * Note that because there is a single `nonReentrant` guard, functions marked as
57  * `nonReentrant` may not call one another. This can be worked around by making
58  * those functions `private`, and then adding `external` `nonReentrant` entry
59  * points to them.
60  *
61  * TIP: If you would like to learn more about reentrancy and alternative ways
62  * to protect against it, check out our blog post
63  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
64  */
65 abstract contract ReentrancyGuard {
66     // Booleans are more expensive than uint256 or any type that takes up a full
67     // word because each write operation emits an extra SLOAD to first read the
68     // slot's contents, replace the bits taken up by the boolean, and then write
69     // back. This is the compiler's defense against contract upgrades and
70     // pointer aliasing, and it cannot be disabled.
71 
72     // The values being non-zero value makes deployment a bit more expensive,
73     // but in exchange the refund on every call to nonReentrant will be lower in
74     // amount. Since refunds are capped to a percentage of the total
75     // transaction's gas, it is best to keep them low in cases like this one, to
76     // increase the likelihood of the full refund coming into effect.
77     uint256 private constant _NOT_ENTERED = 1;
78     uint256 private constant _ENTERED = 2;
79 
80     uint256 private _status;
81 
82     constructor() {
83         _status = _NOT_ENTERED;
84     }
85 
86     /**
87      * @dev Prevents a contract from calling itself, directly or indirectly.
88      * Calling a `nonReentrant` function from another `nonReentrant`
89      * function is not supported. It is possible to prevent this from happening
90      * by making the `nonReentrant` function external, and making it call a
91      * `private` function that does the actual work.
92      */
93     modifier nonReentrant() {
94         // On the first call to nonReentrant, _notEntered will be true
95         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
96 
97         // Any calls to nonReentrant after this point will fail
98         _status = _ENTERED;
99 
100         _;
101 
102         // By storing the original value once again, a refund is triggered (see
103         // https://eips.ethereum.org/EIPS/eip-2200)
104         _status = _NOT_ENTERED;
105     }
106 }
107 
108 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.7/contracts/utils/Strings.sol
109 
110 
111 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
112 
113 pragma solidity ^0.8.0;
114 
115 /**
116  * @dev String operations.
117  */
118 library Strings {
119     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
120     uint8 private constant _ADDRESS_LENGTH = 20;
121 
122     /**
123      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
124      */
125     function toString(uint256 value) internal pure returns (string memory) {
126         // Inspired by OraclizeAPI's implementation - MIT licence
127         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
128 
129         if (value == 0) {
130             return "0";
131         }
132         uint256 temp = value;
133         uint256 digits;
134         while (temp != 0) {
135             digits++;
136             temp /= 10;
137         }
138         bytes memory buffer = new bytes(digits);
139         while (value != 0) {
140             digits -= 1;
141             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
142             value /= 10;
143         }
144         return string(buffer);
145     }
146 
147     /**
148      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
149      */
150     function toHexString(uint256 value) internal pure returns (string memory) {
151         if (value == 0) {
152             return "0x00";
153         }
154         uint256 temp = value;
155         uint256 length = 0;
156         while (temp != 0) {
157             length++;
158             temp >>= 8;
159         }
160         return toHexString(value, length);
161     }
162 
163     /**
164      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
165      */
166     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
167         bytes memory buffer = new bytes(2 * length + 2);
168         buffer[0] = "0";
169         buffer[1] = "x";
170         for (uint256 i = 2 * length + 1; i > 1; --i) {
171             buffer[i] = _HEX_SYMBOLS[value & 0xf];
172             value >>= 4;
173         }
174         require(value == 0, "Strings: hex length insufficient");
175         return string(buffer);
176     }
177 
178     /**
179      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
180      */
181     function toHexString(address addr) internal pure returns (string memory) {
182         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
183     }
184 }
185 
186 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.7/contracts/utils/Context.sol
187 
188 
189 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
190 
191 pragma solidity ^0.8.0;
192 
193 /**
194  * @dev Provides information about the current execution context, including the
195  * sender of the transaction and its data. While these are generally available
196  * via msg.sender and msg.data, they should not be accessed in such a direct
197  * manner, since when dealing with meta-transactions the account sending and
198  * paying for execution may not be the actual sender (as far as an application
199  * is concerned).
200  *
201  * This contract is only required for intermediate, library-like contracts.
202  */
203 abstract contract Context {
204     function _msgSender() internal view virtual returns (address) {
205         return msg.sender;
206     }
207 
208     function _msgData() internal view virtual returns (bytes calldata) {
209         return msg.data;
210     }
211 }
212 
213 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.7/contracts/access/Ownable.sol
214 
215 
216 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
217 
218 pragma solidity ^0.8.0;
219 
220 
221 /**
222  * @dev Contract module which provides a basic access control mechanism, where
223  * there is an account (an owner) that can be granted exclusive access to
224  * specific functions.
225  *
226  * By default, the owner account will be the one that deploys the contract. This
227  * can later be changed with {transferOwnership}.
228  *
229  * This module is used through inheritance. It will make available the modifier
230  * `onlyOwner`, which can be applied to your functions to restrict their use to
231  * the owner.
232  */
233 abstract contract Ownable is Context {
234     address private _owner;
235 
236     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
237 
238     /**
239      * @dev Initializes the contract setting the deployer as the initial owner.
240      */
241     constructor() {
242         _transferOwnership(_msgSender());
243     }
244 
245     /**
246      * @dev Throws if called by any account other than the owner.
247      */
248     modifier onlyOwner() {
249         _checkOwner();
250         _;
251     }
252 
253     /**
254      * @dev Returns the address of the current owner.
255      */
256     function owner() public view virtual returns (address) {
257         return _owner;
258     }
259 
260     /**
261      * @dev Throws if the sender is not the owner.
262      */
263     function _checkOwner() internal view virtual {
264         require(owner() == _msgSender(), "Ownable: caller is not the owner");
265     }
266 
267     /**
268      * @dev Leaves the contract without owner. It will not be possible to call
269      * `onlyOwner` functions anymore. Can only be called by the current owner.
270      *
271      * NOTE: Renouncing ownership will leave the contract without an owner,
272      * thereby removing any functionality that is only available to the owner.
273      */
274     function renounceOwnership() public virtual onlyOwner {
275         _transferOwnership(address(0));
276     }
277 
278     /**
279      * @dev Transfers ownership of the contract to a new account (`newOwner`).
280      * Can only be called by the current owner.
281      */
282     function transferOwnership(address newOwner) public virtual onlyOwner {
283         require(newOwner != address(0), "Ownable: new owner is the zero address");
284         _transferOwnership(newOwner);
285     }
286 
287     /**
288      * @dev Transfers ownership of the contract to a new account (`newOwner`).
289      * Internal function without access restriction.
290      */
291     function _transferOwnership(address newOwner) internal virtual {
292         address oldOwner = _owner;
293         _owner = newOwner;
294         emit OwnershipTransferred(oldOwner, newOwner);
295     }
296 }
297 
298 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.7/contracts/utils/Address.sol
299 
300 
301 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
302 
303 pragma solidity ^0.8.1;
304 
305 /**
306  * @dev Collection of functions related to the address type
307  */
308 library Address {
309     /**
310      * @dev Returns true if `account` is a contract.
311      *
312      * [IMPORTANT]
313      * ====
314      * It is unsafe to assume that an address for which this function returns
315      * false is an externally-owned account (EOA) and not a contract.
316      *
317      * Among others, `isContract` will return false for the following
318      * types of addresses:
319      *
320      *  - an externally-owned account
321      *  - a contract in construction
322      *  - an address where a contract will be created
323      *  - an address where a contract lived, but was destroyed
324      * ====
325      *
326      * [IMPORTANT]
327      * ====
328      * You shouldn't rely on `isContract` to protect against flash loan attacks!
329      *
330      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
331      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
332      * constructor.
333      * ====
334      */
335     function isContract(address account) internal view returns (bool) {
336         // This method relies on extcodesize/address.code.length, which returns 0
337         // for contracts in construction, since the code is only stored at the end
338         // of the constructor execution.
339 
340         return account.code.length > 0;
341     }
342 
343     /**
344      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
345      * `recipient`, forwarding all available gas and reverting on errors.
346      *
347      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
348      * of certain opcodes, possibly making contracts go over the 2300 gas limit
349      * imposed by `transfer`, making them unable to receive funds via
350      * `transfer`. {sendValue} removes this limitation.
351      *
352      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
353      *
354      * IMPORTANT: because control is transferred to `recipient`, care must be
355      * taken to not create reentrancy vulnerabilities. Consider using
356      * {ReentrancyGuard} or the
357      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
358      */
359     function sendValue(address payable recipient, uint256 amount) internal {
360         require(address(this).balance >= amount, "Address: insufficient balance");
361 
362         (bool success, ) = recipient.call{value: amount}("");
363         require(success, "Address: unable to send value, recipient may have reverted");
364     }
365 
366     /**
367      * @dev Performs a Solidity function call using a low level `call`. A
368      * plain `call` is an unsafe replacement for a function call: use this
369      * function instead.
370      *
371      * If `target` reverts with a revert reason, it is bubbled up by this
372      * function (like regular Solidity function calls).
373      *
374      * Returns the raw returned data. To convert to the expected return value,
375      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
376      *
377      * Requirements:
378      *
379      * - `target` must be a contract.
380      * - calling `target` with `data` must not revert.
381      *
382      * _Available since v3.1._
383      */
384     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
385         return functionCall(target, data, "Address: low-level call failed");
386     }
387 
388     /**
389      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
390      * `errorMessage` as a fallback revert reason when `target` reverts.
391      *
392      * _Available since v3.1._
393      */
394     function functionCall(
395         address target,
396         bytes memory data,
397         string memory errorMessage
398     ) internal returns (bytes memory) {
399         return functionCallWithValue(target, data, 0, errorMessage);
400     }
401 
402     /**
403      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
404      * but also transferring `value` wei to `target`.
405      *
406      * Requirements:
407      *
408      * - the calling contract must have an ETH balance of at least `value`.
409      * - the called Solidity function must be `payable`.
410      *
411      * _Available since v3.1._
412      */
413     function functionCallWithValue(
414         address target,
415         bytes memory data,
416         uint256 value
417     ) internal returns (bytes memory) {
418         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
419     }
420 
421     /**
422      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
423      * with `errorMessage` as a fallback revert reason when `target` reverts.
424      *
425      * _Available since v3.1._
426      */
427     function functionCallWithValue(
428         address target,
429         bytes memory data,
430         uint256 value,
431         string memory errorMessage
432     ) internal returns (bytes memory) {
433         require(address(this).balance >= value, "Address: insufficient balance for call");
434         require(isContract(target), "Address: call to non-contract");
435 
436         (bool success, bytes memory returndata) = target.call{value: value}(data);
437         return verifyCallResult(success, returndata, errorMessage);
438     }
439 
440     /**
441      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
442      * but performing a static call.
443      *
444      * _Available since v3.3._
445      */
446     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
447         return functionStaticCall(target, data, "Address: low-level static call failed");
448     }
449 
450     /**
451      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
452      * but performing a static call.
453      *
454      * _Available since v3.3._
455      */
456     function functionStaticCall(
457         address target,
458         bytes memory data,
459         string memory errorMessage
460     ) internal view returns (bytes memory) {
461         require(isContract(target), "Address: static call to non-contract");
462 
463         (bool success, bytes memory returndata) = target.staticcall(data);
464         return verifyCallResult(success, returndata, errorMessage);
465     }
466 
467     /**
468      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
469      * but performing a delegate call.
470      *
471      * _Available since v3.4._
472      */
473     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
474         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
475     }
476 
477     /**
478      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
479      * but performing a delegate call.
480      *
481      * _Available since v3.4._
482      */
483     function functionDelegateCall(
484         address target,
485         bytes memory data,
486         string memory errorMessage
487     ) internal returns (bytes memory) {
488         require(isContract(target), "Address: delegate call to non-contract");
489 
490         (bool success, bytes memory returndata) = target.delegatecall(data);
491         return verifyCallResult(success, returndata, errorMessage);
492     }
493 
494     /**
495      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
496      * revert reason using the provided one.
497      *
498      * _Available since v4.3._
499      */
500     function verifyCallResult(
501         bool success,
502         bytes memory returndata,
503         string memory errorMessage
504     ) internal pure returns (bytes memory) {
505         if (success) {
506             return returndata;
507         } else {
508             // Look for revert reason and bubble it up if present
509             if (returndata.length > 0) {
510                 // The easiest way to bubble the revert reason is using memory via assembly
511                 /// @solidity memory-safe-assembly
512                 assembly {
513                     let returndata_size := mload(returndata)
514                     revert(add(32, returndata), returndata_size)
515                 }
516             } else {
517                 revert(errorMessage);
518             }
519         }
520     }
521 }
522 
523 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.7/contracts/token/ERC721/IERC721Receiver.sol
524 
525 
526 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
527 
528 pragma solidity ^0.8.0;
529 
530 /**
531  * @title ERC721 token receiver interface
532  * @dev Interface for any contract that wants to support safeTransfers
533  * from ERC721 asset contracts.
534  */
535 interface IERC721Receiver {
536     /**
537      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
538      * by `operator` from `from`, this function is called.
539      *
540      * It must return its Solidity selector to confirm the token transfer.
541      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
542      *
543      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
544      */
545     function onERC721Received(
546         address operator,
547         address from,
548         uint256 tokenId,
549         bytes calldata data
550     ) external returns (bytes4);
551 }
552 
553 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.7/contracts/utils/introspection/IERC165.sol
554 
555 
556 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
557 
558 pragma solidity ^0.8.0;
559 
560 /**
561  * @dev Interface of the ERC165 standard, as defined in the
562  * https://eips.ethereum.org/EIPS/eip-165[EIP].
563  *
564  * Implementers can declare support of contract interfaces, which can then be
565  * queried by others ({ERC165Checker}).
566  *
567  * For an implementation, see {ERC165}.
568  */
569 interface IERC165 {
570     /**
571      * @dev Returns true if this contract implements the interface defined by
572      * `interfaceId`. See the corresponding
573      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
574      * to learn more about how these ids are created.
575      *
576      * This function call must use less than 30 000 gas.
577      */
578     function supportsInterface(bytes4 interfaceId) external view returns (bool);
579 }
580 
581 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.7/contracts/utils/introspection/ERC165.sol
582 
583 
584 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
585 
586 pragma solidity ^0.8.0;
587 
588 
589 /**
590  * @dev Implementation of the {IERC165} interface.
591  *
592  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
593  * for the additional interface id that will be supported. For example:
594  *
595  * ```solidity
596  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
597  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
598  * }
599  * ```
600  *
601  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
602  */
603 abstract contract ERC165 is IERC165 {
604     /**
605      * @dev See {IERC165-supportsInterface}.
606      */
607     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
608         return interfaceId == type(IERC165).interfaceId;
609     }
610 }
611 
612 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.7/contracts/token/ERC721/IERC721.sol
613 
614 
615 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
616 
617 pragma solidity ^0.8.0;
618 
619 
620 /**
621  * @dev Required interface of an ERC721 compliant contract.
622  */
623 interface IERC721 is IERC165 {
624     /**
625      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
626      */
627     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
628 
629     /**
630      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
631      */
632     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
633 
634     /**
635      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
636      */
637     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
638 
639     /**
640      * @dev Returns the number of tokens in ``owner``'s account.
641      */
642     function balanceOf(address owner) external view returns (uint256 balance);
643 
644     /**
645      * @dev Returns the owner of the `tokenId` token.
646      *
647      * Requirements:
648      *
649      * - `tokenId` must exist.
650      */
651     function ownerOf(uint256 tokenId) external view returns (address owner);
652 
653     /**
654      * @dev Safely transfers `tokenId` token from `from` to `to`.
655      *
656      * Requirements:
657      *
658      * - `from` cannot be the zero address.
659      * - `to` cannot be the zero address.
660      * - `tokenId` token must exist and be owned by `from`.
661      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
662      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
663      *
664      * Emits a {Transfer} event.
665      */
666     function safeTransferFrom(
667         address from,
668         address to,
669         uint256 tokenId,
670         bytes calldata data
671     ) external;
672 
673     /**
674      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
675      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
676      *
677      * Requirements:
678      *
679      * - `from` cannot be the zero address.
680      * - `to` cannot be the zero address.
681      * - `tokenId` token must exist and be owned by `from`.
682      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
683      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
684      *
685      * Emits a {Transfer} event.
686      */
687     function safeTransferFrom(
688         address from,
689         address to,
690         uint256 tokenId
691     ) external;
692 
693     /**
694      * @dev Transfers `tokenId` token from `from` to `to`.
695      *
696      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
697      *
698      * Requirements:
699      *
700      * - `from` cannot be the zero address.
701      * - `to` cannot be the zero address.
702      * - `tokenId` token must be owned by `from`.
703      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
704      *
705      * Emits a {Transfer} event.
706      */
707     function transferFrom(
708         address from,
709         address to,
710         uint256 tokenId
711     ) external;
712 
713     /**
714      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
715      * The approval is cleared when the token is transferred.
716      *
717      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
718      *
719      * Requirements:
720      *
721      * - The caller must own the token or be an approved operator.
722      * - `tokenId` must exist.
723      *
724      * Emits an {Approval} event.
725      */
726     function approve(address to, uint256 tokenId) external;
727 
728     /**
729      * @dev Approve or remove `operator` as an operator for the caller.
730      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
731      *
732      * Requirements:
733      *
734      * - The `operator` cannot be the caller.
735      *
736      * Emits an {ApprovalForAll} event.
737      */
738     function setApprovalForAll(address operator, bool _approved) external;
739 
740     /**
741      * @dev Returns the account approved for `tokenId` token.
742      *
743      * Requirements:
744      *
745      * - `tokenId` must exist.
746      */
747     function getApproved(uint256 tokenId) external view returns (address operator);
748 
749     /**
750      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
751      *
752      * See {setApprovalForAll}
753      */
754     function isApprovedForAll(address owner, address operator) external view returns (bool);
755 }
756 
757 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.7/contracts/token/ERC721/extensions/IERC721Enumerable.sol
758 
759 
760 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
761 
762 pragma solidity ^0.8.0;
763 
764 
765 /**
766  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
767  * @dev See https://eips.ethereum.org/EIPS/eip-721
768  */
769 interface IERC721Enumerable is IERC721 {
770     /**
771      * @dev Returns the total amount of tokens stored by the contract.
772      */
773     function totalSupply() external view returns (uint256);
774 
775     /**
776      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
777      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
778      */
779     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
780 
781     /**
782      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
783      * Use along with {totalSupply} to enumerate all tokens.
784      */
785     function tokenByIndex(uint256 index) external view returns (uint256);
786 }
787 
788 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.7/contracts/token/ERC721/extensions/IERC721Metadata.sol
789 
790 
791 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
792 
793 pragma solidity ^0.8.0;
794 
795 
796 /**
797  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
798  * @dev See https://eips.ethereum.org/EIPS/eip-721
799  */
800 interface IERC721Metadata is IERC721 {
801     /**
802      * @dev Returns the token collection name.
803      */
804     function name() external view returns (string memory);
805 
806     /**
807      * @dev Returns the token collection symbol.
808      */
809     function symbol() external view returns (string memory);
810 
811     /**
812      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
813      */
814     function tokenURI(uint256 tokenId) external view returns (string memory);
815 }
816 
817 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.7/contracts/token/ERC721/ERC721.sol
818 
819 
820 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
821 
822 pragma solidity ^0.8.0;
823 
824 
825 
826 
827 
828 
829 
830 
831 /**
832  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
833  * the Metadata extension, but not including the Enumerable extension, which is available separately as
834  * {ERC721Enumerable}.
835  */
836 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
837     using Address for address;
838     using Strings for uint256;
839 
840     // Token name
841     string private _name;
842 
843     // Token symbol
844     string private _symbol;
845 
846     // Mapping from token ID to owner address
847     mapping(uint256 => address) private _owners;
848 
849     // Mapping owner address to token count
850     mapping(address => uint256) private _balances;
851 
852     // Mapping from token ID to approved address
853     mapping(uint256 => address) private _tokenApprovals;
854 
855     // Mapping from owner to operator approvals
856     mapping(address => mapping(address => bool)) private _operatorApprovals;
857 
858     /**
859      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
860      */
861     constructor(string memory name_, string memory symbol_) {
862         _name = name_;
863         _symbol = symbol_;
864     }
865 
866     /**
867      * @dev See {IERC165-supportsInterface}.
868      */
869     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
870         return
871             interfaceId == type(IERC721).interfaceId ||
872             interfaceId == type(IERC721Metadata).interfaceId ||
873             super.supportsInterface(interfaceId);
874     }
875 
876     /**
877      * @dev See {IERC721-balanceOf}.
878      */
879     function balanceOf(address owner) public view virtual override returns (uint256) {
880         require(owner != address(0), "ERC721: address zero is not a valid owner");
881         return _balances[owner];
882     }
883 
884     /**
885      * @dev See {IERC721-ownerOf}.
886      */
887     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
888         address owner = _owners[tokenId];
889         require(owner != address(0), "ERC721: invalid token ID");
890         return owner;
891     }
892 
893     /**
894      * @dev See {IERC721Metadata-name}.
895      */
896     function name() public view virtual override returns (string memory) {
897         return _name;
898     }
899 
900     /**
901      * @dev See {IERC721Metadata-symbol}.
902      */
903     function symbol() public view virtual override returns (string memory) {
904         return _symbol;
905     }
906 
907     /**
908      * @dev See {IERC721Metadata-tokenURI}.
909      */
910     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
911         _requireMinted(tokenId);
912 
913         string memory baseURI = _baseURI();
914         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
915     }
916 
917     /**
918      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
919      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
920      * by default, can be overridden in child contracts.
921      */
922     function _baseURI() internal view virtual returns (string memory) {
923         return "";
924     }
925 
926     /**
927      * @dev See {IERC721-approve}.
928      */
929     function approve(address to, uint256 tokenId) public virtual override {
930         address owner = ERC721.ownerOf(tokenId);
931         require(to != owner, "ERC721: approval to current owner");
932 
933         require(
934             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
935             "ERC721: approve caller is not token owner nor approved for all"
936         );
937 
938         _approve(to, tokenId);
939     }
940 
941     /**
942      * @dev See {IERC721-getApproved}.
943      */
944     function getApproved(uint256 tokenId) public view virtual override returns (address) {
945         _requireMinted(tokenId);
946 
947         return _tokenApprovals[tokenId];
948     }
949 
950     /**
951      * @dev See {IERC721-setApprovalForAll}.
952      */
953     function setApprovalForAll(address operator, bool approved) public virtual override {
954         _setApprovalForAll(_msgSender(), operator, approved);
955     }
956 
957     /**
958      * @dev See {IERC721-isApprovedForAll}.
959      */
960     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
961         return _operatorApprovals[owner][operator];
962     }
963 
964     /**
965      * @dev See {IERC721-transferFrom}.
966      */
967     function transferFrom(
968         address from,
969         address to,
970         uint256 tokenId
971     ) public virtual override {
972         //solhint-disable-next-line max-line-length
973         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
974 
975         _transfer(from, to, tokenId);
976     }
977 
978     /**
979      * @dev See {IERC721-safeTransferFrom}.
980      */
981     function safeTransferFrom(
982         address from,
983         address to,
984         uint256 tokenId
985     ) public virtual override {
986         safeTransferFrom(from, to, tokenId, "");
987     }
988 
989     /**
990      * @dev See {IERC721-safeTransferFrom}.
991      */
992     function safeTransferFrom(
993         address from,
994         address to,
995         uint256 tokenId,
996         bytes memory data
997     ) public virtual override {
998         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
999         _safeTransfer(from, to, tokenId, data);
1000     }
1001 
1002     /**
1003      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1004      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1005      *
1006      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1007      *
1008      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1009      * implement alternative mechanisms to perform token transfer, such as signature-based.
1010      *
1011      * Requirements:
1012      *
1013      * - `from` cannot be the zero address.
1014      * - `to` cannot be the zero address.
1015      * - `tokenId` token must exist and be owned by `from`.
1016      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1017      *
1018      * Emits a {Transfer} event.
1019      */
1020     function _safeTransfer(
1021         address from,
1022         address to,
1023         uint256 tokenId,
1024         bytes memory data
1025     ) internal virtual {
1026         _transfer(from, to, tokenId);
1027         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1028     }
1029 
1030     /**
1031      * @dev Returns whether `tokenId` exists.
1032      *
1033      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1034      *
1035      * Tokens start existing when they are minted (`_mint`),
1036      * and stop existing when they are burned (`_burn`).
1037      */
1038     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1039         return _owners[tokenId] != address(0);
1040     }
1041 
1042     /**
1043      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1044      *
1045      * Requirements:
1046      *
1047      * - `tokenId` must exist.
1048      */
1049     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1050         address owner = ERC721.ownerOf(tokenId);
1051         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1052     }
1053 
1054     /**
1055      * @dev Safely mints `tokenId` and transfers it to `to`.
1056      *
1057      * Requirements:
1058      *
1059      * - `tokenId` must not exist.
1060      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1061      *
1062      * Emits a {Transfer} event.
1063      */
1064     function _safeMint(address to, uint256 tokenId) internal virtual {
1065         _safeMint(to, tokenId, "");
1066     }
1067 
1068     /**
1069      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1070      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1071      */
1072     function _safeMint(
1073         address to,
1074         uint256 tokenId,
1075         bytes memory data
1076     ) internal virtual {
1077         _mint(to, tokenId);
1078         require(
1079             _checkOnERC721Received(address(0), to, tokenId, data),
1080             "ERC721: transfer to non ERC721Receiver implementer"
1081         );
1082     }
1083 
1084     /**
1085      * @dev Mints `tokenId` and transfers it to `to`.
1086      *
1087      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1088      *
1089      * Requirements:
1090      *
1091      * - `tokenId` must not exist.
1092      * - `to` cannot be the zero address.
1093      *
1094      * Emits a {Transfer} event.
1095      */
1096     function _mint(address to, uint256 tokenId) internal virtual {
1097         require(to != address(0), "ERC721: mint to the zero address");
1098         require(!_exists(tokenId), "ERC721: token already minted");
1099 
1100         _beforeTokenTransfer(address(0), to, tokenId);
1101 
1102         _balances[to] += 1;
1103         _owners[tokenId] = to;
1104 
1105         emit Transfer(address(0), to, tokenId);
1106 
1107         _afterTokenTransfer(address(0), to, tokenId);
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
1120     function _burn(uint256 tokenId) internal virtual {
1121         address owner = ERC721.ownerOf(tokenId);
1122 
1123         _beforeTokenTransfer(owner, address(0), tokenId);
1124 
1125         // Clear approvals
1126         _approve(address(0), tokenId);
1127 
1128         _balances[owner] -= 1;
1129         delete _owners[tokenId];
1130 
1131         emit Transfer(owner, address(0), tokenId);
1132 
1133         _afterTokenTransfer(owner, address(0), tokenId);
1134     }
1135 
1136     /**
1137      * @dev Transfers `tokenId` from `from` to `to`.
1138      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1139      *
1140      * Requirements:
1141      *
1142      * - `to` cannot be the zero address.
1143      * - `tokenId` token must be owned by `from`.
1144      *
1145      * Emits a {Transfer} event.
1146      */
1147     function _transfer(
1148         address from,
1149         address to,
1150         uint256 tokenId
1151     ) internal virtual {
1152         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1153         require(to != address(0), "ERC721: transfer to the zero address");
1154 
1155         _beforeTokenTransfer(from, to, tokenId);
1156 
1157         // Clear approvals from the previous owner
1158         _approve(address(0), tokenId);
1159 
1160         _balances[from] -= 1;
1161         _balances[to] += 1;
1162         _owners[tokenId] = to;
1163 
1164         emit Transfer(from, to, tokenId);
1165 
1166         _afterTokenTransfer(from, to, tokenId);
1167     }
1168 
1169     /**
1170      * @dev Approve `to` to operate on `tokenId`
1171      *
1172      * Emits an {Approval} event.
1173      */
1174     function _approve(address to, uint256 tokenId) internal virtual {
1175         _tokenApprovals[tokenId] = to;
1176         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1177     }
1178 
1179     /**
1180      * @dev Approve `operator` to operate on all of `owner` tokens
1181      *
1182      * Emits an {ApprovalForAll} event.
1183      */
1184     function _setApprovalForAll(
1185         address owner,
1186         address operator,
1187         bool approved
1188     ) internal virtual {
1189         require(owner != operator, "ERC721: approve to caller");
1190         _operatorApprovals[owner][operator] = approved;
1191         emit ApprovalForAll(owner, operator, approved);
1192     }
1193 
1194     /**
1195      * @dev Reverts if the `tokenId` has not been minted yet.
1196      */
1197     function _requireMinted(uint256 tokenId) internal view virtual {
1198         require(_exists(tokenId), "ERC721: invalid token ID");
1199     }
1200 
1201     /**
1202      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1203      * The call is not executed if the target address is not a contract.
1204      *
1205      * @param from address representing the previous owner of the given token ID
1206      * @param to target address that will receive the tokens
1207      * @param tokenId uint256 ID of the token to be transferred
1208      * @param data bytes optional data to send along with the call
1209      * @return bool whether the call correctly returned the expected magic value
1210      */
1211     function _checkOnERC721Received(
1212         address from,
1213         address to,
1214         uint256 tokenId,
1215         bytes memory data
1216     ) private returns (bool) {
1217         if (to.isContract()) {
1218             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1219                 return retval == IERC721Receiver.onERC721Received.selector;
1220             } catch (bytes memory reason) {
1221                 if (reason.length == 0) {
1222                     revert("ERC721: transfer to non ERC721Receiver implementer");
1223                 } else {
1224                     /// @solidity memory-safe-assembly
1225                     assembly {
1226                         revert(add(32, reason), mload(reason))
1227                     }
1228                 }
1229             }
1230         } else {
1231             return true;
1232         }
1233     }
1234 
1235     /**
1236      * @dev Hook that is called before any token transfer. This includes minting
1237      * and burning.
1238      *
1239      * Calling conditions:
1240      *
1241      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1242      * transferred to `to`.
1243      * - When `from` is zero, `tokenId` will be minted for `to`.
1244      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1245      * - `from` and `to` are never both zero.
1246      *
1247      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1248      */
1249     function _beforeTokenTransfer(
1250         address from,
1251         address to,
1252         uint256 tokenId
1253     ) internal virtual {}
1254 
1255     /**
1256      * @dev Hook that is called after any transfer of tokens. This includes
1257      * minting and burning.
1258      *
1259      * Calling conditions:
1260      *
1261      * - when `from` and `to` are both non-zero.
1262      * - `from` and `to` are never both zero.
1263      *
1264      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1265      */
1266     function _afterTokenTransfer(
1267         address from,
1268         address to,
1269         uint256 tokenId
1270     ) internal virtual {}
1271 }
1272 
1273 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.7/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1274 
1275 
1276 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1277 
1278 pragma solidity ^0.8.0;
1279 
1280 
1281 
1282 /**
1283  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1284  * enumerability of all the token ids in the contract as well as all token ids owned by each
1285  * account.
1286  */
1287 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1288     // Mapping from owner to list of owned token IDs
1289     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1290 
1291     // Mapping from token ID to index of the owner tokens list
1292     mapping(uint256 => uint256) private _ownedTokensIndex;
1293 
1294     // Array with all token ids, used for enumeration
1295     uint256[] private _allTokens;
1296 
1297     // Mapping from token id to position in the allTokens array
1298     mapping(uint256 => uint256) private _allTokensIndex;
1299 
1300     /**
1301      * @dev See {IERC165-supportsInterface}.
1302      */
1303     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1304         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1305     }
1306 
1307     /**
1308      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1309      */
1310     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1311         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1312         return _ownedTokens[owner][index];
1313     }
1314 
1315     /**
1316      * @dev See {IERC721Enumerable-totalSupply}.
1317      */
1318     function totalSupply() public view virtual override returns (uint256) {
1319         return _allTokens.length;
1320     }
1321 
1322     /**
1323      * @dev See {IERC721Enumerable-tokenByIndex}.
1324      */
1325     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1326         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1327         return _allTokens[index];
1328     }
1329 
1330     /**
1331      * @dev Hook that is called before any token transfer. This includes minting
1332      * and burning.
1333      *
1334      * Calling conditions:
1335      *
1336      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1337      * transferred to `to`.
1338      * - When `from` is zero, `tokenId` will be minted for `to`.
1339      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1340      * - `from` cannot be the zero address.
1341      * - `to` cannot be the zero address.
1342      *
1343      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1344      */
1345     function _beforeTokenTransfer(
1346         address from,
1347         address to,
1348         uint256 tokenId
1349     ) internal virtual override {
1350         super._beforeTokenTransfer(from, to, tokenId);
1351 
1352         if (from == address(0)) {
1353             _addTokenToAllTokensEnumeration(tokenId);
1354         } else if (from != to) {
1355             _removeTokenFromOwnerEnumeration(from, tokenId);
1356         }
1357         if (to == address(0)) {
1358             _removeTokenFromAllTokensEnumeration(tokenId);
1359         } else if (to != from) {
1360             _addTokenToOwnerEnumeration(to, tokenId);
1361         }
1362     }
1363 
1364     /**
1365      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1366      * @param to address representing the new owner of the given token ID
1367      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1368      */
1369     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1370         uint256 length = ERC721.balanceOf(to);
1371         _ownedTokens[to][length] = tokenId;
1372         _ownedTokensIndex[tokenId] = length;
1373     }
1374 
1375     /**
1376      * @dev Private function to add a token to this extension's token tracking data structures.
1377      * @param tokenId uint256 ID of the token to be added to the tokens list
1378      */
1379     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1380         _allTokensIndex[tokenId] = _allTokens.length;
1381         _allTokens.push(tokenId);
1382     }
1383 
1384     /**
1385      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1386      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1387      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1388      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1389      * @param from address representing the previous owner of the given token ID
1390      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1391      */
1392     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1393         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1394         // then delete the last slot (swap and pop).
1395 
1396         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1397         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1398 
1399         // When the token to delete is the last token, the swap operation is unnecessary
1400         if (tokenIndex != lastTokenIndex) {
1401             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1402 
1403             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1404             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1405         }
1406 
1407         // This also deletes the contents at the last position of the array
1408         delete _ownedTokensIndex[tokenId];
1409         delete _ownedTokens[from][lastTokenIndex];
1410     }
1411 
1412     /**
1413      * @dev Private function to remove a token from this extension's token tracking data structures.
1414      * This has O(1) time complexity, but alters the order of the _allTokens array.
1415      * @param tokenId uint256 ID of the token to be removed from the tokens list
1416      */
1417     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1418         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1419         // then delete the last slot (swap and pop).
1420 
1421         uint256 lastTokenIndex = _allTokens.length - 1;
1422         uint256 tokenIndex = _allTokensIndex[tokenId];
1423 
1424         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1425         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1426         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1427         uint256 lastTokenId = _allTokens[lastTokenIndex];
1428 
1429         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1430         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1431 
1432         // This also deletes the contents at the last position of the array
1433         delete _allTokensIndex[tokenId];
1434         _allTokens.pop();
1435     }
1436 }
1437 
1438 pragma solidity 0.8.16;
1439 
1440 
1441 
1442 
1443 
1444 
1445 contract DeFiGirls is ERC721Enumerable, ReentrancyGuard, Ownable {
1446     using Strings for uint;
1447 
1448     string public baseURI;
1449 
1450     bool public earlyBirdLive = false;
1451     bool public publicMintLive = false;
1452     bool public walletMintingLimits = true;
1453 
1454     uint public constant maxSupply = 6765;
1455     uint public constant maxInHouseMint = maxSupply / 20;
1456     uint public inHouseMinted = 0;
1457 
1458     mapping(address => bool) public earlyBirds;
1459     mapping(address => uint) public walletMints;
1460     mapping(address => uint) public lastMintBlock;
1461 
1462     event inHouseMintComplete(uint blockNum, uint minted, uint totalInHouseMints);
1463     event earlyBirdOpen(uint blockNum);
1464     event publicMintOpen(uint blockNum);
1465     event earlyBirdSet(address birb, bool status);
1466     event earlyBirdGroupSet(address[] birbs, bool status);
1467     event walletMintingLimitsSet(bool status);
1468 
1469     constructor(string memory _uri) ERC721("DeFi Girls", "DFGIRL") { 
1470         setURI(_uri);
1471     }
1472 
1473     function inHouseMint(uint _amt) external onlyOwner nonReentrant {
1474         uint s = totalSupply();
1475         require(_amt + inHouseMinted < maxInHouseMint, "Maximum in-house mint amount exceeded");
1476         require(s + _amt < maxSupply, "Max supply reached!");
1477         for (uint i = 0; i < _amt; i++) {
1478             _safeMint(msg.sender, s + i);
1479         }
1480         inHouseMinted += _amt;
1481         emit inHouseMintComplete(block.number, _amt, inHouseMinted);
1482     }
1483 
1484     function mint() public nonReentrant {
1485         uint s = totalSupply();
1486         require(s < maxSupply, "Max supply reached!");
1487         require(tx.origin == msg.sender, "Humans only please!");
1488 
1489         if (!publicMintLive) {
1490             require(earlyBirdLive, "Early Bird mints not yet live!");
1491             require(isEarlyBird(msg.sender), "You're not on the Early Bird list!");
1492             require(walletMints[msg.sender] < 2, "Only two mints per Early Bird during the premint phase!");
1493         }
1494 
1495         //Not using a require/revert, ensuring there's no un-needed gas exhaustion
1496         if (walletMintingLimits) {
1497             if (walletMints[msg.sender] < 3) {
1498                 walletMints[msg.sender]++;
1499                 _safeMint(msg.sender, s);
1500             }
1501         } else {
1502             walletMints[msg.sender]++;
1503             _safeMint(msg.sender, s);
1504         }
1505         
1506     }
1507 
1508     function setwalletMintingLimits(bool _status) external onlyOwner {
1509         walletMintingLimits = _status;
1510         emit walletMintingLimitsSet(_status);
1511     }
1512 
1513     function setEarlyBird(address _birb, bool _status) external onlyOwner {
1514         earlyBirds[_birb] = _status;
1515         emit earlyBirdSet(_birb, _status);
1516     }
1517 
1518     function setEarlyBirdGroup(address[] memory _birbs, bool _status) external onlyOwner {
1519         for (uint i = 0; i < _birbs.length; i++) {
1520             earlyBirds[_birbs[i]] = _status;
1521         }
1522         emit earlyBirdGroupSet(_birbs, _status);
1523     }
1524 
1525     function openEarlyBird() external onlyOwner() {
1526         earlyBirdLive = true;
1527         emit earlyBirdOpen(block.number);
1528     }
1529 
1530     function openPublicMint() external onlyOwner() {
1531         publicMintLive = true;
1532         emit publicMintOpen(block.number);
1533     }
1534 
1535     function _baseURI() internal view virtual override returns (string memory) {
1536         return baseURI;
1537     }
1538 
1539     function tokenURI(uint tokenId) public view virtual override returns (string memory) {
1540         require(_exists(tokenId), "Token ID Does not exist!");
1541         string memory currentBaseURI = _baseURI();
1542         return bytes(currentBaseURI).length > 0	? string(abi.encodePacked(currentBaseURI, tokenId.toString())) : "";
1543     }
1544 
1545     //write metadata
1546     function setURI(string memory _newBaseURI) public onlyOwner {
1547         baseURI = _newBaseURI;
1548     }
1549 
1550     function isEarlyBird(address _birb) public view returns(bool) {
1551         return earlyBirds[_birb];
1552     }
1553 
1554     //warning: gassy!
1555     function tokensOfOwner(address _owner) public view returns (uint256[] memory) {
1556         uint balance = balanceOf(_owner);
1557         uint[] memory tokens = new uint[](balance);
1558 
1559         for (uint i=0; i<balance; i++) {
1560             tokens[i] = tokenOfOwnerByIndex(_owner, i);
1561         }
1562 
1563         return tokens;
1564     }
1565 }