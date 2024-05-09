1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Counters.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
6 /**
7 Camera Person NFT by BOSH
8 
9 ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░
10 ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
11 ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
12 ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░▄ÄM▀▀▀▀▀░▄░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
13 ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░Ä▀░░░░░░░░░░░░░▀▄░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
14 ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▄▀░░░░░░░░░░░░░░░░░░▐░░░░░░░░░░░░░░░░░░░░░░░░░░░▒
15 ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░█░░░░░░░░░░░░░░░░░░░▐░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒
16 ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█░░░░░░░░░░░░░░░░░░░░░░░▌░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒
17 ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░▄█▄▄▄▄▄▄▄▄▄▄▄▄≡∞╪M▀▀▀▀░░░░░▌░░░░░░░░░░░░░░░░░░▒▒▒▒▒▒
18 ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█░░░░░░░░░░░░░░░░░░░░░░░░░░░█▄▄░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒
19 ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▌░░░░░░░░░░░░░░▄▄▄▄▄▄▄▄▄░░░▄██████▌░░░░░░░▒▒▒▒▒▒▒▒▒▒▒
20 ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▄▓▀▀▀▀█████████████▒█▒▒▒▒▒█▀▀▀█▒▐▌░_░░█▐▌░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒
21 ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▌░░░▐▒▐▌░░░░█▐▌░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒
22 ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▄███▒▒▒▒▀▀▀█▓█▐▌░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
23 ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▄▄▄▄▄▄█▀░░░░╓▓████▓▓░░░▐▌▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
24 ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█▀▀▀▀▀▀▀▀▀▀░░▒░░░▒▒░█░░░░╓▓█▀░░░░░░▀▀▓░▐▌▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
25 ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▐▌░░░░Ñ█░░▄▀▀▀▀▀▀▄░░█▓▌▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
26 ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█░░░░▌█░░█  ,▄▄▄  █░▐█▌▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
27 ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█░░░j▓▌░j▌  █████ █░j█▌▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
28 ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█▄░░░▌█░░█, "▀▀▀ ▄▀░██▌▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
29 ▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▀▄░░╙▓▌░░▀▀▄▄▄P▀_,█▀▐▌▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
30 ▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░▀▀▀███▄▄,░░,▄▄█▀▀▀░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
31 ▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░▀█▓▄▄▄▄▄▄▄▄▄▄▄▄▄▄▓▓██▀▀▀█▌█▌░▀▀▀░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
32 ▒▒▒▒▒▒▒░░░░░░░░░░░░░▄▄▄▄▄▄█▀▀▀░░░▀█▄░░░░░░▀█▄█░░█▀▀▀██▄▄▄▄▄▄▄▄░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
33 ▒▒▒▒▒░░░░░░░░░░▄▀▀░░░░░░░░░░░░░░░░░▀█▄░░░▄█░█░█▄█░░░░░░░░░░░░░░▀█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
34 ▒▒▒░░░░░░░░░░░█▀░░░░░░░░░░░░░░░░░░░░░░█▄█▀░░█░░▀▀░░░░░░░░░░░░░░░░█▌▒▒▒▒▒▒▒▒▒▒▒▒▒
35 ▒░░░░░░░░░░░░▐▌░░░░░░░░░░░░░░░░░░░░░░░░░░░░░█░░░░░░░░░░░░░░░░░░░░░█▒▒▒▒▒▒▒▒▒▒▒▒▒
36 ░░░░░░░░░░░░░█░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░█░░░░░░░░░░░░░░░░░░░░░▐▌▒▒▒▒▒▒▒▒▒▒▒▒
37 ░░░░░░░░░░░░▐▌░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░█▌░░░░░░░░░░░█░░░░░░░░░█▒▒▒▒▒▒▒▒▒▒▒▒
38 ░░░░░░░░░░░░█░░░░░░░░░░▐▌░░░░░░░░░░░░░░░░░░░▐▌░░░░░░░░░░░▐▌░░░░░░░░▐▌▒▒▒▒▒▒▒▒▒▒▒
39 ░░░░░░░░░░░░█░░░░░░░░░░█░░░░░░░░░░░░░░░░░░░░▐▌░░░░░░░░░░░░█░░░░░░░░░█▒▒▒▒▒▒▒▒▒▒▒
40 ░░░░░░░░░░░▐▌░░░░░░░░░░█░░░░░░░░░░░░░░░░░░░░j█░░░░░░░░░░░░█░░░░░░░░░█▒▒▒▒▒▒▒▒▒▒▒
41 ░░░░░░░░░░░█░░░░░░░░░░j█░░░░░░░░░░░░░░░░░░░░░█░░░░░░░░░░░░█░░░░░░░░░▐▌▒▒▒▒▒▒▒▒▒▒
42 ░░░░░░░░░░▐▌░░░░░░░░░░▐▌░░░░░░░░░░░░░░░░░░░░░█░░░░░░░░░░░░▐▌░░░░░░░░░█▒▒▒▒▒▒▒▒▒▒
43 ░░░░░░░░░░█▌░░░░░░░░░░█░░░░░░░░░░░░░░░░░░░░░░█░░░░░░░░░░░░░█░░░░░░░░░█▒▒▒▒▒▒▒▒▒▒
44 pragma solidity ^0.8.0;
45 /*
46 /**
47  * @title Counters
48  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
49  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
50  *
51  * Include with `using Counters for Counters.Counter;`
52  */
53 library Counters {
54     struct Counter {
55         // This variable should never be directly accessed by users of the library: interactions must be restricted to
56         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
57         // this feature: see https://github.com/ethereum/solidity/issues/4637
58         uint256 _value; // default: 0
59     }
60 
61     function current(Counter storage counter) internal view returns (uint256) {
62         return counter._value;
63     }
64 
65     function increment(Counter storage counter) internal {
66         unchecked {
67             counter._value += 1;
68         }
69     }
70 
71     function decrement(Counter storage counter) internal {
72         uint256 value = counter._value;
73         require(value > 0, "Counter: decrement overflow");
74         unchecked {
75             counter._value = value - 1;
76         }
77     }
78 
79     function reset(Counter storage counter) internal {
80         counter._value = 0;
81     }
82 }
83 
84 // File: @openzeppelin/contracts/utils/Strings.sol
85 
86 
87 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
88 
89 pragma solidity ^0.8.0;
90 
91 /**
92  * @dev String operations.
93  */
94 library Strings {
95     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
96 
97     /**
98      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
99      */
100     function toString(uint256 value) internal pure returns (string memory) {
101         // Inspired by OraclizeAPI's implementation - MIT licence
102         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
103 
104         if (value == 0) {
105             return "0";
106         }
107         uint256 temp = value;
108         uint256 digits;
109         while (temp != 0) {
110             digits++;
111             temp /= 10;
112         }
113         bytes memory buffer = new bytes(digits);
114         while (value != 0) {
115             digits -= 1;
116             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
117             value /= 10;
118         }
119         return string(buffer);
120     }
121 
122     /**
123      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
124      */
125     function toHexString(uint256 value) internal pure returns (string memory) {
126         if (value == 0) {
127             return "0x00";
128         }
129         uint256 temp = value;
130         uint256 length = 0;
131         while (temp != 0) {
132             length++;
133             temp >>= 8;
134         }
135         return toHexString(value, length);
136     }
137 
138     /**
139      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
140      */
141     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
142         bytes memory buffer = new bytes(2 * length + 2);
143         buffer[0] = "0";
144         buffer[1] = "x";
145         for (uint256 i = 2 * length + 1; i > 1; --i) {
146             buffer[i] = _HEX_SYMBOLS[value & 0xf];
147             value >>= 4;
148         }
149         require(value == 0, "Strings: hex length insufficient");
150         return string(buffer);
151     }
152 }
153 
154 // File: @openzeppelin/contracts/utils/Context.sol
155 
156 
157 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
158 
159 pragma solidity ^0.8.0;
160 
161 /**
162  * @dev Provides information about the current execution context, including the
163  * sender of the transaction and its data. While these are generally available
164  * via msg.sender and msg.data, they should not be accessed in such a direct
165  * manner, since when dealing with meta-transactions the account sending and
166  * paying for execution may not be the actual sender (as far as an application
167  * is concerned).
168  *
169  * This contract is only required for intermediate, library-like contracts.
170  */
171 abstract contract Context {
172     function _msgSender() internal view virtual returns (address) {
173         return msg.sender;
174     }
175 
176     function _msgData() internal view virtual returns (bytes calldata) {
177         return msg.data;
178     }
179 }
180 
181 // File: @openzeppelin/contracts/access/Ownable.sol
182 
183 
184 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
185 
186 pragma solidity ^0.8.0;
187 
188 
189 /**
190  * @dev Contract module which provides a basic access control mechanism, where
191  * there is an account (an owner) that can be granted exclusive access to
192  * specific functions.
193  *
194  * By default, the owner account will be the one that deploys the contract. This
195  * can later be changed with {transferOwnership}.
196  *
197  * This module is used through inheritance. It will make available the modifier
198  * `onlyOwner`, which can be applied to your functions to restrict their use to
199  * the owner.
200  */
201 abstract contract Ownable is Context {
202     address private _owner;
203 
204     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
205 
206     /**
207      * @dev Initializes the contract setting the deployer as the initial owner.
208      */
209     constructor() {
210         _transferOwnership(_msgSender());
211     }
212 
213     /**
214      * @dev Returns the address of the current owner.
215      */
216     function owner() public view virtual returns (address) {
217         return _owner;
218     }
219 
220     /**
221      * @dev Throws if called by any account other than the owner.
222      */
223     modifier onlyOwner() {
224         require(owner() == _msgSender(), "Ownable: caller is not the owner");
225         _;
226     }
227 
228     /**
229      * @dev Leaves the contract without owner. It will not be possible to call
230      * `onlyOwner` functions anymore. Can only be called by the current owner.
231      *
232      * NOTE: Renouncing ownership will leave the contract without an owner,
233      * thereby removing any functionality that is only available to the owner.
234      */
235     function renounceOwnership() public virtual onlyOwner {
236         _transferOwnership(address(0));
237     }
238 
239     /**
240      * @dev Transfers ownership of the contract to a new account (`newOwner`).
241      * Can only be called by the current owner.
242      */
243     function transferOwnership(address newOwner) public virtual onlyOwner {
244         require(newOwner != address(0), "Ownable: new owner is the zero address");
245         _transferOwnership(newOwner);
246     }
247 
248     /**
249      * @dev Transfers ownership of the contract to a new account (`newOwner`).
250      * Internal function without access restriction.
251      */
252     function _transferOwnership(address newOwner) internal virtual {
253         address oldOwner = _owner;
254         _owner = newOwner;
255         emit OwnershipTransferred(oldOwner, newOwner);
256     }
257 }
258 
259 // File: @openzeppelin/contracts/utils/Address.sol
260 
261 
262 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
263 
264 pragma solidity ^0.8.0;
265 
266 /**
267  * @dev Collection of functions related to the address type
268  */
269 library Address {
270     /**
271      * @dev Returns true if `account` is a contract.
272      *
273      * [IMPORTANT]
274      * ====
275      * It is unsafe to assume that an address for which this function returns
276      * false is an externally-owned account (EOA) and not a contract.
277      *
278      * Among others, `isContract` will return false for the following
279      * types of addresses:
280      *
281      *  - an externally-owned account
282      *  - a contract in construction
283      *  - an address where a contract will be created
284      *  - an address where a contract lived, but was destroyed
285      * ====
286      */
287     function isContract(address account) internal view returns (bool) {
288         // This method relies on extcodesize, which returns 0 for contracts in
289         // construction, since the code is only stored at the end of the
290         // constructor execution.
291 
292         uint256 size;
293         assembly {
294             size := extcodesize(account)
295         }
296         return size > 0;
297     }
298 
299     /**
300      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
301      * `recipient`, forwarding all available gas and reverting on errors.
302      *
303      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
304      * of certain opcodes, possibly making contracts go over the 2300 gas limit
305      * imposed by `transfer`, making them unable to receive funds via
306      * `transfer`. {sendValue} removes this limitation.
307      *
308      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
309      *
310      * IMPORTANT: because control is transferred to `recipient`, care must be
311      * taken to not create reentrancy vulnerabilities. Consider using
312      * {ReentrancyGuard} or the
313      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
314      */
315     function sendValue(address payable recipient, uint256 amount) internal {
316         require(address(this).balance >= amount, "Address: insufficient balance");
317 
318         (bool success, ) = recipient.call{value: amount}("");
319         require(success, "Address: unable to send value, recipient may have reverted");
320     }
321 
322     /**
323      * @dev Performs a Solidity function call using a low level `call`. A
324      * plain `call` is an unsafe replacement for a function call: use this
325      * function instead.
326      *
327      * If `target` reverts with a revert reason, it is bubbled up by this
328      * function (like regular Solidity function calls).
329      *
330      * Returns the raw returned data. To convert to the expected return value,
331      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
332      *
333      * Requirements:
334      *
335      * - `target` must be a contract.
336      * - calling `target` with `data` must not revert.
337      *
338      * _Available since v3.1._
339      */
340     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
341         return functionCall(target, data, "Address: low-level call failed");
342     }
343 
344     /**
345      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
346      * `errorMessage` as a fallback revert reason when `target` reverts.
347      *
348      * _Available since v3.1._
349      */
350     function functionCall(
351         address target,
352         bytes memory data,
353         string memory errorMessage
354     ) internal returns (bytes memory) {
355         return functionCallWithValue(target, data, 0, errorMessage);
356     }
357 
358     /**
359      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
360      * but also transferring `value` wei to `target`.
361      *
362      * Requirements:
363      *
364      * - the calling contract must have an ETH balance of at least `value`.
365      * - the called Solidity function must be `payable`.
366      *
367      * _Available since v3.1._
368      */
369     function functionCallWithValue(
370         address target,
371         bytes memory data,
372         uint256 value
373     ) internal returns (bytes memory) {
374         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
375     }
376 
377     /**
378      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
379      * with `errorMessage` as a fallback revert reason when `target` reverts.
380      *
381      * _Available since v3.1._
382      */
383     function functionCallWithValue(
384         address target,
385         bytes memory data,
386         uint256 value,
387         string memory errorMessage
388     ) internal returns (bytes memory) {
389         require(address(this).balance >= value, "Address: insufficient balance for call");
390         require(isContract(target), "Address: call to non-contract");
391 
392         (bool success, bytes memory returndata) = target.call{value: value}(data);
393         return verifyCallResult(success, returndata, errorMessage);
394     }
395 
396     /**
397      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
398      * but performing a static call.
399      *
400      * _Available since v3.3._
401      */
402     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
403         return functionStaticCall(target, data, "Address: low-level static call failed");
404     }
405 
406     /**
407      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
408      * but performing a static call.
409      *
410      * _Available since v3.3._
411      */
412     function functionStaticCall(
413         address target,
414         bytes memory data,
415         string memory errorMessage
416     ) internal view returns (bytes memory) {
417         require(isContract(target), "Address: static call to non-contract");
418 
419         (bool success, bytes memory returndata) = target.staticcall(data);
420         return verifyCallResult(success, returndata, errorMessage);
421     }
422 
423     /**
424      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
425      * but performing a delegate call.
426      *
427      * _Available since v3.4._
428      */
429     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
430         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
431     }
432 
433     /**
434      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
435      * but performing a delegate call.
436      *
437      * _Available since v3.4._
438      */
439     function functionDelegateCall(
440         address target,
441         bytes memory data,
442         string memory errorMessage
443     ) internal returns (bytes memory) {
444         require(isContract(target), "Address: delegate call to non-contract");
445 
446         (bool success, bytes memory returndata) = target.delegatecall(data);
447         return verifyCallResult(success, returndata, errorMessage);
448     }
449 
450     /**
451      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
452      * revert reason using the provided one.
453      *
454      * _Available since v4.3._
455      */
456     function verifyCallResult(
457         bool success,
458         bytes memory returndata,
459         string memory errorMessage
460     ) internal pure returns (bytes memory) {
461         if (success) {
462             return returndata;
463         } else {
464             // Look for revert reason and bubble it up if present
465             if (returndata.length > 0) {
466                 // The easiest way to bubble the revert reason is using memory via assembly
467 
468                 assembly {
469                     let returndata_size := mload(returndata)
470                     revert(add(32, returndata), returndata_size)
471                 }
472             } else {
473                 revert(errorMessage);
474             }
475         }
476     }
477 }
478 
479 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
480 
481 
482 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
483 
484 pragma solidity ^0.8.0;
485 
486 /**
487  * @title ERC721 token receiver interface
488  * @dev Interface for any contract that wants to support safeTransfers
489  * from ERC721 asset contracts.
490  */
491 interface IERC721Receiver {
492     /**
493      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
494      * by `operator` from `from`, this function is called.
495      *
496      * It must return its Solidity selector to confirm the token transfer.
497      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
498      *
499      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
500      */
501     function onERC721Received(
502         address operator,
503         address from,
504         uint256 tokenId,
505         bytes calldata data
506     ) external returns (bytes4);
507 }
508 
509 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
510 
511 
512 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
513 
514 pragma solidity ^0.8.0;
515 
516 /**
517  * @dev Interface of the ERC165 standard, as defined in the
518  * https://eips.ethereum.org/EIPS/eip-165[EIP].
519  *
520  * Implementers can declare support of contract interfaces, which can then be
521  * queried by others ({ERC165Checker}).
522  *
523  * For an implementation, see {ERC165}.
524  */
525 interface IERC165 {
526     /**
527      * @dev Returns true if this contract implements the interface defined by
528      * `interfaceId`. See the corresponding
529      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
530      * to learn more about how these ids are created.
531      *
532      * This function call must use less than 30 000 gas.
533      */
534     function supportsInterface(bytes4 interfaceId) external view returns (bool);
535 }
536 
537 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
538 
539 
540 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
541 
542 pragma solidity ^0.8.0;
543 
544 
545 /**
546  * @dev Implementation of the {IERC165} interface.
547  *
548  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
549  * for the additional interface id that will be supported. For example:
550  *
551  * ```solidity
552  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
553  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
554  * }
555  * ```
556  *
557  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
558  */
559 abstract contract ERC165 is IERC165 {
560     /**
561      * @dev See {IERC165-supportsInterface}.
562      */
563     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
564         return interfaceId == type(IERC165).interfaceId;
565     }
566 }
567 
568 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
569 
570 
571 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
572 
573 pragma solidity ^0.8.0;
574 
575 
576 /**
577  * @dev Required interface of an ERC721 compliant contract.
578  */
579 interface IERC721 is IERC165 {
580     /**
581      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
582      */
583     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
584 
585     /**
586      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
587      */
588     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
589 
590     /**
591      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
592      */
593     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
594 
595     /**
596      * @dev Returns the number of tokens in ``owner``'s account.
597      */
598     function balanceOf(address owner) external view returns (uint256 balance);
599 
600     /**
601      * @dev Returns the owner of the `tokenId` token.
602      *
603      * Requirements:
604      *
605      * - `tokenId` must exist.
606      */
607     function ownerOf(uint256 tokenId) external view returns (address owner);
608 
609     /**
610      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
611      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
612      *
613      * Requirements:
614      *
615      * - `from` cannot be the zero address.
616      * - `to` cannot be the zero address.
617      * - `tokenId` token must exist and be owned by `from`.
618      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
619      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
620      *
621      * Emits a {Transfer} event.
622      */
623     function safeTransferFrom(
624         address from,
625         address to,
626         uint256 tokenId
627     ) external;
628 
629     /**
630      * @dev Transfers `tokenId` token from `from` to `to`.
631      *
632      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
633      *
634      * Requirements:
635      *
636      * - `from` cannot be the zero address.
637      * - `to` cannot be the zero address.
638      * - `tokenId` token must be owned by `from`.
639      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
640      *
641      * Emits a {Transfer} event.
642      */
643     function transferFrom(
644         address from,
645         address to,
646         uint256 tokenId
647     ) external;
648 
649     /**
650      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
651      * The approval is cleared when the token is transferred.
652      *
653      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
654      *
655      * Requirements:
656      *
657      * - The caller must own the token or be an approved operator.
658      * - `tokenId` must exist.
659      *
660      * Emits an {Approval} event.
661      */
662     function approve(address to, uint256 tokenId) external;
663 
664     /**
665      * @dev Returns the account approved for `tokenId` token.
666      *
667      * Requirements:
668      *
669      * - `tokenId` must exist.
670      */
671     function getApproved(uint256 tokenId) external view returns (address operator);
672 
673     /**
674      * @dev Approve or remove `operator` as an operator for the caller.
675      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
676      *
677      * Requirements:
678      *
679      * - The `operator` cannot be the caller.
680      *
681      * Emits an {ApprovalForAll} event.
682      */
683     function setApprovalForAll(address operator, bool _approved) external;
684 
685     /**
686      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
687      *
688      * See {setApprovalForAll}
689      */
690     function isApprovedForAll(address owner, address operator) external view returns (bool);
691 
692     /**
693      * @dev Safely transfers `tokenId` token from `from` to `to`.
694      *
695      * Requirements:
696      *
697      * - `from` cannot be the zero address.
698      * - `to` cannot be the zero address.
699      * - `tokenId` token must exist and be owned by `from`.
700      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
701      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
702      *
703      * Emits a {Transfer} event.
704      */
705     function safeTransferFrom(
706         address from,
707         address to,
708         uint256 tokenId,
709         bytes calldata data
710     ) external;
711 }
712 
713 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
714 
715 
716 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
717 
718 pragma solidity ^0.8.0;
719 
720 
721 /**
722  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
723  * @dev See https://eips.ethereum.org/EIPS/eip-721
724  */
725 interface IERC721Metadata is IERC721 {
726     /**
727      * @dev Returns the token collection name.
728      */
729     function name() external view returns (string memory);
730 
731     /**
732      * @dev Returns the token collection symbol.
733      */
734     function symbol() external view returns (string memory);
735 
736     /**
737      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
738      */
739     function tokenURI(uint256 tokenId) external view returns (string memory);
740 }
741 
742 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
743 
744 
745 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
746 
747 pragma solidity ^0.8.0;
748 
749 
750 
751 
752 
753 
754 
755 
756 /**
757  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
758  * the Metadata extension, but not including the Enumerable extension, which is available separately as
759  * {ERC721Enumerable}.
760  */
761 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
762     using Address for address;
763     using Strings for uint256;
764 
765     // Token name
766     string private _name;
767 
768     // Token symbol
769     string private _symbol;
770 
771     // Mapping from token ID to owner address
772     mapping(uint256 => address) private _owners;
773 
774     // Mapping owner address to token count
775     mapping(address => uint256) private _balances;
776 
777     // Mapping from token ID to approved address
778     mapping(uint256 => address) private _tokenApprovals;
779 
780     // Mapping from owner to operator approvals
781     mapping(address => mapping(address => bool)) private _operatorApprovals;
782 
783     /**
784      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
785      */
786     constructor(string memory name_, string memory symbol_) {
787         _name = name_;
788         _symbol = symbol_;
789     }
790 
791     /**
792      * @dev See {IERC165-supportsInterface}.
793      */
794     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
795         return
796             interfaceId == type(IERC721).interfaceId ||
797             interfaceId == type(IERC721Metadata).interfaceId ||
798             super.supportsInterface(interfaceId);
799     }
800 
801     /**
802      * @dev See {IERC721-balanceOf}.
803      */
804     function balanceOf(address owner) public view virtual override returns (uint256) {
805         require(owner != address(0), "ERC721: balance query for the zero address");
806         return _balances[owner];
807     }
808 
809     /**
810      * @dev See {IERC721-ownerOf}.
811      */
812     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
813         address owner = _owners[tokenId];
814         require(owner != address(0), "ERC721: owner query for nonexistent token");
815         return owner;
816     }
817 
818     /**
819      * @dev See {IERC721Metadata-name}.
820      */
821     function name() public view virtual override returns (string memory) {
822         return _name;
823     }
824 
825     /**
826      * @dev See {IERC721Metadata-symbol}.
827      */
828     function symbol() public view virtual override returns (string memory) {
829         return _symbol;
830     }
831 
832     /**
833      * @dev See {IERC721Metadata-tokenURI}.
834      */
835     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
836         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
837 
838         string memory baseURI = _baseURI();
839         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
840     }
841 
842     /**
843      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
844      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
845      * by default, can be overriden in child contracts.
846      */
847     function _baseURI() internal view virtual returns (string memory) {
848         return "";
849     }
850 
851     /**
852      * @dev See {IERC721-approve}.
853      */
854     function approve(address to, uint256 tokenId) public virtual override {
855         address owner = ERC721.ownerOf(tokenId);
856         require(to != owner, "ERC721: approval to current owner");
857 
858         require(
859             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
860             "ERC721: approve caller is not owner nor approved for all"
861         );
862 
863         _approve(to, tokenId);
864     }
865 
866     /**
867      * @dev See {IERC721-getApproved}.
868      */
869     function getApproved(uint256 tokenId) public view virtual override returns (address) {
870         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
871 
872         return _tokenApprovals[tokenId];
873     }
874 
875     /**
876      * @dev See {IERC721-setApprovalForAll}.
877      */
878     function setApprovalForAll(address operator, bool approved) public virtual override {
879         _setApprovalForAll(_msgSender(), operator, approved);
880     }
881 
882     /**
883      * @dev See {IERC721-isApprovedForAll}.
884      */
885     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
886         return _operatorApprovals[owner][operator];
887     }
888 
889     /**
890      * @dev See {IERC721-transferFrom}.
891      */
892     function transferFrom(
893         address from,
894         address to,
895         uint256 tokenId
896     ) public virtual override {
897         //solhint-disable-next-line max-line-length
898         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
899 
900         _transfer(from, to, tokenId);
901     }
902 
903     /**
904      * @dev See {IERC721-safeTransferFrom}.
905      */
906     function safeTransferFrom(
907         address from,
908         address to,
909         uint256 tokenId
910     ) public virtual override {
911         safeTransferFrom(from, to, tokenId, "");
912     }
913 
914     /**
915      * @dev See {IERC721-safeTransferFrom}.
916      */
917     function safeTransferFrom(
918         address from,
919         address to,
920         uint256 tokenId,
921         bytes memory _data
922     ) public virtual override {
923         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
924         _safeTransfer(from, to, tokenId, _data);
925     }
926 
927     /**
928      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
929      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
930      *
931      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
932      *
933      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
934      * implement alternative mechanisms to perform token transfer, such as signature-based.
935      *
936      * Requirements:
937      *
938      * - `from` cannot be the zero address.
939      * - `to` cannot be the zero address.
940      * - `tokenId` token must exist and be owned by `from`.
941      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
942      *
943      * Emits a {Transfer} event.
944      */
945     function _safeTransfer(
946         address from,
947         address to,
948         uint256 tokenId,
949         bytes memory _data
950     ) internal virtual {
951         _transfer(from, to, tokenId);
952         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
953     }
954 
955     /**
956      * @dev Returns whether `tokenId` exists.
957      *
958      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
959      *
960      * Tokens start existing when they are minted (`_mint`),
961      * and stop existing when they are burned (`_burn`).
962      */
963     function _exists(uint256 tokenId) internal view virtual returns (bool) {
964         return _owners[tokenId] != address(0);
965     }
966 
967     /**
968      * @dev Returns whether `spender` is allowed to manage `tokenId`.
969      *
970      * Requirements:
971      *
972      * - `tokenId` must exist.
973      */
974     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
975         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
976         address owner = ERC721.ownerOf(tokenId);
977         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
978     }
979 
980     /**
981      * @dev Safely mints `tokenId` and transfers it to `to`.
982      *
983      * Requirements:
984      *
985      * - `tokenId` must not exist.
986      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
987      *
988      * Emits a {Transfer} event.
989      */
990     function _safeMint(address to, uint256 tokenId) internal virtual {
991         _safeMint(to, tokenId, "");
992     }
993 
994     /**
995      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
996      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
997      */
998     function _safeMint(
999         address to,
1000         uint256 tokenId,
1001         bytes memory _data
1002     ) internal virtual {
1003         _mint(to, tokenId);
1004         require(
1005             _checkOnERC721Received(address(0), to, tokenId, _data),
1006             "ERC721: transfer to non ERC721Receiver implementer"
1007         );
1008     }
1009 
1010     /**
1011      * @dev Mints `tokenId` and transfers it to `to`.
1012      *
1013      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1014      *
1015      * Requirements:
1016      *
1017      * - `tokenId` must not exist.
1018      * - `to` cannot be the zero address.
1019      *
1020      * Emits a {Transfer} event.
1021      */
1022     function _mint(address to, uint256 tokenId) internal virtual {
1023         require(to != address(0), "ERC721: mint to the zero address");
1024         require(!_exists(tokenId), "ERC721: token already minted");
1025 
1026         _beforeTokenTransfer(address(0), to, tokenId);
1027 
1028         _balances[to] += 1;
1029         _owners[tokenId] = to;
1030 
1031         emit Transfer(address(0), to, tokenId);
1032     }
1033 
1034     /**
1035      * @dev Destroys `tokenId`.
1036      * The approval is cleared when the token is burned.
1037      *
1038      * Requirements:
1039      *
1040      * - `tokenId` must exist.
1041      *
1042      * Emits a {Transfer} event.
1043      */
1044     function _burn(uint256 tokenId) internal virtual {
1045         address owner = ERC721.ownerOf(tokenId);
1046 
1047         _beforeTokenTransfer(owner, address(0), tokenId);
1048 
1049         // Clear approvals
1050         _approve(address(0), tokenId);
1051 
1052         _balances[owner] -= 1;
1053         delete _owners[tokenId];
1054 
1055         emit Transfer(owner, address(0), tokenId);
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
1074         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
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
1087     }
1088 
1089     /**
1090      * @dev Approve `to` to operate on `tokenId`
1091      *
1092      * Emits a {Approval} event.
1093      */
1094     function _approve(address to, uint256 tokenId) internal virtual {
1095         _tokenApprovals[tokenId] = to;
1096         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1097     }
1098 
1099     /**
1100      * @dev Approve `operator` to operate on all of `owner` tokens
1101      *
1102      * Emits a {ApprovalForAll} event.
1103      */
1104     function _setApprovalForAll(
1105         address owner,
1106         address operator,
1107         bool approved
1108     ) internal virtual {
1109         require(owner != operator, "ERC721: approve to caller");
1110         _operatorApprovals[owner][operator] = approved;
1111         emit ApprovalForAll(owner, operator, approved);
1112     }
1113 
1114     /**
1115      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1116      * The call is not executed if the target address is not a contract.
1117      *
1118      * @param from address representing the previous owner of the given token ID
1119      * @param to target address that will receive the tokens
1120      * @param tokenId uint256 ID of the token to be transferred
1121      * @param _data bytes optional data to send along with the call
1122      * @return bool whether the call correctly returned the expected magic value
1123      */
1124     function _checkOnERC721Received(
1125         address from,
1126         address to,
1127         uint256 tokenId,
1128         bytes memory _data
1129     ) private returns (bool) {
1130         if (to.isContract()) {
1131             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1132                 return retval == IERC721Receiver.onERC721Received.selector;
1133             } catch (bytes memory reason) {
1134                 if (reason.length == 0) {
1135                     revert("ERC721: transfer to non ERC721Receiver implementer");
1136                 } else {
1137                     assembly {
1138                         revert(add(32, reason), mload(reason))
1139                     }
1140                 }
1141             }
1142         } else {
1143             return true;
1144         }
1145     }
1146 
1147     /**
1148      * @dev Hook that is called before any token transfer. This includes minting
1149      * and burning.
1150      *
1151      * Calling conditions:
1152      *
1153      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1154      * transferred to `to`.
1155      * - When `from` is zero, `tokenId` will be minted for `to`.
1156      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1157      * - `from` and `to` are never both zero.
1158      *
1159      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1160      */
1161     function _beforeTokenTransfer(
1162         address from,
1163         address to,
1164         uint256 tokenId
1165     ) internal virtual {}
1166 }
1167 
1168 // File: contracts/lowgas.sol
1169 
1170 
1171 
1172 // 
1173 
1174 pragma solidity >=0.7.0 <0.9.0;
1175 
1176 
1177 
1178 
1179 contract CameraPerson is ERC721, Ownable {
1180   using Strings for uint256;
1181   using Counters for Counters.Counter;
1182 
1183   Counters.Counter private supply;
1184 
1185   string public uriPrefix = "";
1186   string public uriSuffix = ".json";
1187   string public hiddenMetadataUri;
1188   
1189   uint256 public cost = 0.02 ether;
1190   uint256 public maxSupply = 2000;
1191   uint256 public maxMintAmountPerTx = 55;
1192 
1193   bool public paused = false;
1194   bool public revealed = false;
1195 
1196   constructor() ERC721("CAMERA PERSON NFT", "CPNFT") {
1197     setHiddenMetadataUri("ipfs://QmdRbdKxVdrMW9HE6WHVEyhWvnrpF1hM8CUzUoVPzseHSe/hidden.json");
1198   }
1199 
1200   modifier mintCompliance(uint256 _mintAmount) {
1201     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1202     require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
1203     _;
1204   }
1205 
1206   function totalSupply() public view returns (uint256) {
1207     return supply.current();
1208   }
1209 
1210   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1211     require(!paused, "The contract is paused!");
1212     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1213 
1214     _mintLoop(msg.sender, _mintAmount);
1215   }
1216   
1217   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1218     _mintLoop(_receiver, _mintAmount);
1219   }
1220 
1221   function walletOfOwner(address _owner)
1222     public
1223     view
1224     returns (uint256[] memory)
1225   {
1226     uint256 ownerTokenCount = balanceOf(_owner);
1227     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1228     uint256 currentTokenId = 1;
1229     uint256 ownedTokenIndex = 0;
1230 
1231     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1232       address currentTokenOwner = ownerOf(currentTokenId);
1233 
1234       if (currentTokenOwner == _owner) {
1235         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1236 
1237         ownedTokenIndex++;
1238       }
1239 
1240       currentTokenId++;
1241     }
1242 
1243     return ownedTokenIds;
1244   }
1245 
1246   function tokenURI(uint256 _tokenId)
1247     public
1248     view
1249     virtual
1250     override
1251     returns (string memory)
1252   {
1253     require(
1254       _exists(_tokenId),
1255       "ERC721Metadata: URI query for nonexistent token"
1256     );
1257 
1258     if (revealed == false) {
1259       return hiddenMetadataUri;
1260     }
1261 
1262     string memory currentBaseURI = _baseURI();
1263     return bytes(currentBaseURI).length > 0
1264         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1265         : "";
1266   }
1267 
1268   function setRevealed(bool _state) public onlyOwner {
1269     revealed = _state;
1270   }
1271 
1272   function setCost(uint256 _cost) public onlyOwner {
1273     cost = _cost;
1274   }
1275 
1276   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1277     maxMintAmountPerTx = _maxMintAmountPerTx;
1278   }
1279 
1280   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1281     hiddenMetadataUri = _hiddenMetadataUri;
1282   }
1283 
1284   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1285     uriPrefix = _uriPrefix;
1286   }
1287 
1288   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1289     uriSuffix = _uriSuffix;
1290   }
1291 
1292   function setPaused(bool _state) public onlyOwner {
1293     paused = _state;
1294   }
1295 
1296   function withdraw() public onlyOwner {
1297 
1298 
1299     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1300     require(os);
1301     // =============================================================================
1302   }
1303 
1304   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1305     for (uint256 i = 0; i < _mintAmount; i++) {
1306       supply.increment();
1307       _safeMint(_receiver, supply.current());
1308     }
1309   }
1310 
1311   function _baseURI() internal view virtual override returns (string memory) {
1312     return uriPrefix;
1313   }
1314 }