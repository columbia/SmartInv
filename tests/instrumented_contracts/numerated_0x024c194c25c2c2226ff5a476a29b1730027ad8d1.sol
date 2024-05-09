1 /**
2 
3 ▀█▀ █ █▄░█ █▄█   █▄▄ ▄▀█ ▀█▀ ▀█▀ █░░ █▀▀   █▄▄ █▀█ ▀█▀ █▀
4 ░█░ █ █░▀█ ░█░   █▄█ █▀█ ░█░ ░█░ █▄▄ ██▄   █▄█ █▄█ ░█░ ▄█
5 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⣰⣿⣿⣒⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
6 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡝⢿⣿⣽⢿⠆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
7 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⣤⣽⣷⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
8 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣸⣿⣭⣭⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
9 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣿⣿⣿⣿⣿⣿⣿⣷⡶⠶⣤⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
10 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⣾⣿⣿⣯⡿⠿⠾⠿⠾⠿⢿⣷⣥⣄⣀⠙⡗⢢⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
11 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⣻⡿⠟⠛⠉⠁⠀⠀⠀⠀⠀⠀⠀⠉⠙⣛⠻⢿⣳⢤⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
12 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣆⣴⠋⠀⠀⠀⠀⠀⢀⣾⣿⣆⠀⠀⠀⠀⣸⡟⢧⠀⢹⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
13 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⣿⣿⡀⠀⠀⠀⠀⢸⣿⣯⣽⠀⠀⠀⠰⣿⣿⣿⠀⣬⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
14 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⢿⣯⣷⡀⠀⠀⠀⡘⣿⣇⣝⣀⣤⠤⢤⣿⣧⣏⡀⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
15 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢻⣿⡿⣄⠀⠀⠈⠉⢀⡀⠀⠀⠀⠀⠀⣀⠀⢸⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
16 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣿⣿⠀⠀⠀⠀⠉⠢⢤⣀⣀⠤⠖⠉⠀⢸⢻⠀⠀⠀⢠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
17 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⢈⣿⣫⣤⡤⠤⠶⠶⠒⠒⠒⠒⠒⠒⠒⠒⠬⠾⣄⣀⣠⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
18 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⡼⣏⠉⠁⣀⠀⠀⠀⣀⣀⣀⡠⠤⠤⠤⠤⣀⣀⡴⠀⠆⣿⠁⠀⠀⢠⢀⣀⣤⣸⠉⣧⠀⠀⠴⠄⠀
19 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⠞⠁⠀⠘⣆⠀⠸⣶⣯⡭⠥⠞⠒⠓⠒⠒⠒⠒⢶⢊⠇⠀⣼⣇⣠⣤⣤⣾⡏⣸⣿⠟⠓⠊⢹⣧⣤⣒⣭
20 ⠀⠀⠀⠀⠀⠀⠀⠀⡾⣿⣧⡤⠖⠛⠒⢜⡄⠀⢻⠀⠀⠀⢀⠀⣰⡆⠀⠀⠀⢸⣼⠀⢀⡟⣽⠨⣿⢹⡟⠁⣿⡏⠀⠀⠀⣸⢙⣯⣥⠬
21 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣃⠔⠉⠉⢹⣿⡄⠘⡇⢆⠀⡼⣀⢿⡇⡆⣰⢀⣼⣿⠰⢼⡇⢸⠇⢿⡈⡧⠀⠸⣿⣄⣀⣶⡿⠿⣈⢙⠆
22 ⠀⠀⠀⠀⠀⢀⡄⢀⣤⡞⡟⣷⣦⣤⣤⡼⠉⡇⠀⢻⠘⢆⠃⣿⠈⣿⢹⡿⠟⣻⡟⠀⣾⠉⠉⠉⠉⠉⠙⠒⠂⠛⠛⠃⠀⠀⠀⠈⠁⠀
23 ⠀⠀⠀⣠⣠⣾⣷⢻⡜⣧⠑⢬⣭⣟⠋⠀⠀⢱⠀⢸⡄⠈⠂⠙⠀⠈⠀⠀⠀⣧⡇⣀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
24 ⠀⠀⠀⣿⣿⠘⣿⣌⠻⡈⢳⠿⠻⣿⣓⠀⠀⠈⡷⠀⢧⠀⠀⠀⠀⠀⠀⠀⢠⣿⡇⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
25 ⣠⠄⠼⣿⣿⡄⠘⢿⣿⣾⡇⠀⠀⢻⣋⡇⠀⠀⢱⠀⠼⠦⠶⠖⠒⠒⠒⠒⠚⠛⠃⣀⣇⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
26 ⣹⠶⠀⠘⢿⣿⣦⣀⣉⠽⠃⠀⠀⢈⣿⣗⣀⣀⣸⣤⣠⣤⣔⣦⣶⣤⣠⣤⠤⣦⠶⠞⠿⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
27 ⠙⠶⡷⢠⡶⣄⢹⡍⠁⠀⠀⠀⠀⠀⠀⢀⣸⡯⣍⡙⠳⠮⡏⠉⠹⣿⣏⡠⢊⠩⢷⣀⣶⡖⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
28 ⠀⠀⠙⠋⠀⠈⠉⠁⠀⠀⠀⠀⠀⢠⣿⣾⣿⡏⠲⢍⣙⣾⠁⠀⠀⠹⣿⡴⢃⡴⠚⠁⠘⢿⣦⡀⠀⠀⠀⠀⠀⢀⣀⣀⡀⠀⠀⠀⠀⠀
29 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢲⣿⡟⣿⣿⣈⠓⠤⣼⠇⠀⠀⠀⠀⠘⣷⠏⠀⠀⠀⣠⣴⣫⣇⠀⢀⡠⠔⠊⠉⢙⣫⡿⠷⢶⡆⣀⠀
30 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣿⣿⡀⠙⠻⢿⢭⣿⠄⠀⠀⠀⠀⢰⣿⡀⣀⣠⣾⠞⠁⠀⢙⣷⠋⠀⠀⣀⡴⠚⠁⣀⣴⡾⣿⠇⠀
31 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⡴⣾⣯⣿⠋⠛⠦⣤⣿⣟⠁⠀⠀⠀⠀⠀⠀⠙⢿⣿⣿⣷⣤⡀⡠⠋⠀⠀⣠⠞⠁⣠⣴⡿⣿⢙⣾⠃⠀⠀
32 ⠀⠀⠀⠀⠀⠀⠀⠀⣼⡏⠘⢿⣿⣅⡀⣀⣴⡃⠀⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠙⣿⣿⡿⠁⠀⣠⢞⠁⣠⣾⣭⠻⣁⣽⠟⠁⠀⠀⠀
33 ⠀⠀⠀⠀⠀⠀⠀⢸⣿⠁⠀⠈⠙⠹⠋⠉⠘⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⠁⠀⣴⣷⣨⣾⣷⠍⠻⣤⡾⠁⠀⠀⠀⠀⠀
34 ⠀⠀⠀⠀⠀⠀⠀⣸⣿⠀⠀⠀⠀⠀⠀⠀⠀⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣧⣼⣟⣾⣿⢻⣎⡷⠟⠁⠀⠀⠀⠀⠀⠀⠀
35 ⠀⠀⠀⠀⠀⠀⠀⣼⣿⡄⠀⠀⠀⠀⠀⠀⣠⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠚⣷⣿⡿⠶⠚⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀
36 ⠀⠀⠀⠀⠀⠀⠀⠸⣿⣿⡀⠀⢤⣀⣤⣾⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
37 ⠀⠀⠀⠀⠀⠀⠀⠀⠙⢮⣉⠒⠢⣽⡿⠛⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
38 ⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠙⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
39 ⡇⠀⠀⠀⠀⠀⠀⠀⣀⣦⣀⣀⣤⣤⣀⣀⣀⣀⣄⣀⣀⣀⣀⠀⣀⣀⣀⣀⣀⠀⠀⢀⡄⢤⡤⡄⣠⣀⡄⣀⠀⢀⠀⠀⠀⠀⠀⠀⠀⠀
40 ⡇⠀⠀⠀⠀⠀⠀⠀⠛⠛⠛⠚⠛⠘⠓⠛⠙⠛⠓⠓⠙⠒⠛⠒⠓⠛⠛⠙⠛⠀⠀⠉⡛⠋⠘⠉⠓⠉⠋⠒⢑⠊⠓⠀⠀⠀⠀⠀⠀⠀
41  */
42 // SPDX-License-Identifier: MIT
43 
44 // File: @openzeppelin/contracts/utils/Strings.sol
45 
46 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
47 
48 pragma solidity ^0.8.0;
49 
50 /**
51  * @dev String operations.
52  */
53 library Strings {
54     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
55 
56     /**
57      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
58      */
59     function toString(uint256 value) internal pure returns (string memory) {
60         // Inspired by OraclizeAPI's implementation - MIT licence
61         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
62 
63         if (value == 0) {
64             return "0";
65         }
66         uint256 temp = value;
67         uint256 digits;
68         while (temp != 0) {
69             digits++;
70             temp /= 10;
71         }
72         bytes memory buffer = new bytes(digits);
73         while (value != 0) {
74             digits -= 1;
75             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
76             value /= 10;
77         }
78         return string(buffer);
79     }
80 
81     /**
82      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
83      */
84     function toHexString(uint256 value) internal pure returns (string memory) {
85         if (value == 0) {
86             return "0x00";
87         }
88         uint256 temp = value;
89         uint256 length = 0;
90         while (temp != 0) {
91             length++;
92             temp >>= 8;
93         }
94         return toHexString(value, length);
95     }
96 
97     /**
98      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
99      */
100     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
101         bytes memory buffer = new bytes(2 * length + 2);
102         buffer[0] = "0";
103         buffer[1] = "x";
104         for (uint256 i = 2 * length + 1; i > 1; --i) {
105             buffer[i] = _HEX_SYMBOLS[value & 0xf];
106             value >>= 4;
107         }
108         require(value == 0, "Strings: hex length insufficient");
109         return string(buffer);
110     }
111 }
112 
113 // File: @openzeppelin/contracts/utils/Context.sol
114 
115 
116 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
117 
118 pragma solidity ^0.8.0;
119 
120 /**
121  * @dev Provides information about the current execution context, including the
122  * sender of the transaction and its data. While these are generally available
123  * via msg.sender and msg.data, they should not be accessed in such a direct
124  * manner, since when dealing with meta-transactions the account sending and
125  * paying for execution may not be the actual sender (as far as an application
126  * is concerned).
127  *
128  * This contract is only required for intermediate, library-like contracts.
129  */
130 abstract contract Context {
131     function _msgSender() internal view virtual returns (address) {
132         return msg.sender;
133     }
134 
135     function _msgData() internal view virtual returns (bytes calldata) {
136         return msg.data;
137     }
138 }
139 
140 // File: @openzeppelin/contracts/utils/Address.sol
141 
142 
143 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
144 
145 pragma solidity ^0.8.1;
146 
147 /**
148  * @dev Collection of functions related to the address type
149  */
150 library Address {
151     /**
152      * @dev Returns true if `account` is a contract.
153      *
154      * [IMPORTANT]
155      * ====
156      * It is unsafe to assume that an address for which this function returns
157      * false is an externally-owned account (EOA) and not a contract.
158      *
159      * Among others, `isContract` will return false for the following
160      * types of addresses:
161      *
162      *  - an externally-owned account
163      *  - a contract in construction
164      *  - an address where a contract will be created
165      *  - an address where a contract lived, but was destroyed
166      * ====
167      *
168      * [IMPORTANT]
169      * ====
170      * You shouldn't rely on `isContract` to protect against flash loan attacks!
171      *
172      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
173      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
174      * constructor.
175      * ====
176      */
177     function isContract(address account) internal view returns (bool) {
178         // This method relies on extcodesize/address.code.length, which returns 0
179         // for contracts in construction, since the code is only stored at the end
180         // of the constructor execution.
181 
182         return account.code.length > 0;
183     }
184 
185     /**
186      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
187      * `recipient`, forwarding all available gas and reverting on errors.
188      *
189      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
190      * of certain opcodes, possibly making contracts go over the 2300 gas limit
191      * imposed by `transfer`, making them unable to receive funds via
192      * `transfer`. {sendValue} removes this limitation.
193      *
194      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
195      *
196      * IMPORTANT: because control is transferred to `recipient`, care must be
197      * taken to not create reentrancy vulnerabilities. Consider using
198      * {ReentrancyGuard} or the
199      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
200      */
201     function sendValue(address payable recipient, uint256 amount) internal {
202         require(address(this).balance >= amount, "Address: insufficient balance");
203 
204         (bool success, ) = recipient.call{value: amount}("");
205         require(success, "Address: unable to send value, recipient may have reverted");
206     }
207 
208     /**
209      * @dev Performs a Solidity function call using a low level `call`. A
210      * plain `call` is an unsafe replacement for a function call: use this
211      * function instead.
212      *
213      * If `target` reverts with a revert reason, it is bubbled up by this
214      * function (like regular Solidity function calls).
215      *
216      * Returns the raw returned data. To convert to the expected return value,
217      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
218      *
219      * Requirements:
220      *
221      * - `target` must be a contract.
222      * - calling `target` with `data` must not revert.
223      *
224      * _Available since v3.1._
225      */
226     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
227         return functionCall(target, data, "Address: low-level call failed");
228     }
229 
230     /**
231      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
232      * `errorMessage` as a fallback revert reason when `target` reverts.
233      *
234      * _Available since v3.1._
235      */
236     function functionCall(
237         address target,
238         bytes memory data,
239         string memory errorMessage
240     ) internal returns (bytes memory) {
241         return functionCallWithValue(target, data, 0, errorMessage);
242     }
243 
244     /**
245      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
246      * but also transferring `value` wei to `target`.
247      *
248      * Requirements:
249      *
250      * - the calling contract must have an ETH balance of at least `value`.
251      * - the called Solidity function must be `payable`.
252      *
253      * _Available since v3.1._
254      */
255     function functionCallWithValue(
256         address target,
257         bytes memory data,
258         uint256 value
259     ) internal returns (bytes memory) {
260         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
261     }
262 
263     /**
264      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
265      * with `errorMessage` as a fallback revert reason when `target` reverts.
266      *
267      * _Available since v3.1._
268      */
269     function functionCallWithValue(
270         address target,
271         bytes memory data,
272         uint256 value,
273         string memory errorMessage
274     ) internal returns (bytes memory) {
275         require(address(this).balance >= value, "Address: insufficient balance for call");
276         require(isContract(target), "Address: call to non-contract");
277 
278         (bool success, bytes memory returndata) = target.call{value: value}(data);
279         return verifyCallResult(success, returndata, errorMessage);
280     }
281 
282     /**
283      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
284      * but performing a static call.
285      *
286      * _Available since v3.3._
287      */
288     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
289         return functionStaticCall(target, data, "Address: low-level static call failed");
290     }
291 
292     /**
293      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
294      * but performing a static call.
295      *
296      * _Available since v3.3._
297      */
298     function functionStaticCall(
299         address target,
300         bytes memory data,
301         string memory errorMessage
302     ) internal view returns (bytes memory) {
303         require(isContract(target), "Address: static call to non-contract");
304 
305         (bool success, bytes memory returndata) = target.staticcall(data);
306         return verifyCallResult(success, returndata, errorMessage);
307     }
308 
309     /**
310      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
311      * but performing a delegate call.
312      *
313      * _Available since v3.4._
314      */
315     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
316         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
317     }
318 
319     /**
320      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
321      * but performing a delegate call.
322      *
323      * _Available since v3.4._
324      */
325     function functionDelegateCall(
326         address target,
327         bytes memory data,
328         string memory errorMessage
329     ) internal returns (bytes memory) {
330         require(isContract(target), "Address: delegate call to non-contract");
331 
332         (bool success, bytes memory returndata) = target.delegatecall(data);
333         return verifyCallResult(success, returndata, errorMessage);
334     }
335 
336     /**
337      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
338      * revert reason using the provided one.
339      *
340      * _Available since v4.3._
341      */
342     function verifyCallResult(
343         bool success,
344         bytes memory returndata,
345         string memory errorMessage
346     ) internal pure returns (bytes memory) {
347         if (success) {
348             return returndata;
349         } else {
350             // Look for revert reason and bubble it up if present
351             if (returndata.length > 0) {
352                 // The easiest way to bubble the revert reason is using memory via assembly
353 
354                 assembly {
355                     let returndata_size := mload(returndata)
356                     revert(add(32, returndata), returndata_size)
357                 }
358             } else {
359                 revert(errorMessage);
360             }
361         }
362     }
363 }
364 
365 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
366 
367 
368 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
369 
370 pragma solidity ^0.8.0;
371 
372 /**
373  * @title ERC721 token receiver interface
374  * @dev Interface for any contract that wants to support safeTransfers
375  * from ERC721 asset contracts.
376  */
377 interface IERC721Receiver {
378     /**
379      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
380      * by `operator` from `from`, this function is called.
381      *
382      * It must return its Solidity selector to confirm the token transfer.
383      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
384      *
385      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
386      */
387     function onERC721Received(
388         address operator,
389         address from,
390         uint256 tokenId,
391         bytes calldata data
392     ) external returns (bytes4);
393 }
394 
395 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
396 
397 
398 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
399 
400 pragma solidity ^0.8.0;
401 
402 /**
403  * @dev Interface of the ERC165 standard, as defined in the
404  * https://eips.ethereum.org/EIPS/eip-165[EIP].
405  *
406  * Implementers can declare support of contract interfaces, which can then be
407  * queried by others ({ERC165Checker}).
408  *
409  * For an implementation, see {ERC165}.
410  */
411 interface IERC165 {
412     /**
413      * @dev Returns true if this contract implements the interface defined by
414      * `interfaceId`. See the corresponding
415      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
416      * to learn more about how these ids are created.
417      *
418      * This function call must use less than 30 000 gas.
419      */
420     function supportsInterface(bytes4 interfaceId) external view returns (bool);
421 }
422 
423 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
424 
425 
426 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
427 
428 pragma solidity ^0.8.0;
429 
430 
431 /**
432  * @dev Implementation of the {IERC165} interface.
433  *
434  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
435  * for the additional interface id that will be supported. For example:
436  *
437  * ```solidity
438  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
439  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
440  * }
441  * ```
442  *
443  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
444  */
445 abstract contract ERC165 is IERC165 {
446     /**
447      * @dev See {IERC165-supportsInterface}.
448      */
449     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
450         return interfaceId == type(IERC165).interfaceId;
451     }
452 }
453 
454 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
455 
456 
457 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
458 
459 pragma solidity ^0.8.0;
460 
461 
462 /**
463  * @dev Required interface of an ERC721 compliant contract.
464  */
465 interface IERC721 is IERC165 {
466     /**
467      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
468      */
469     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
470 
471     /**
472      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
473      */
474     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
475 
476     /**
477      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
478      */
479     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
480 
481     /**
482      * @dev Returns the number of tokens in ``owner``'s account.
483      */
484     function balanceOf(address owner) external view returns (uint256 balance);
485 
486     /**
487      * @dev Returns the owner of the `tokenId` token.
488      *
489      * Requirements:
490      *
491      * - `tokenId` must exist.
492      */
493     function ownerOf(uint256 tokenId) external view returns (address owner);
494 
495     /**
496      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
497      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
498      *
499      * Requirements:
500      *
501      * - `from` cannot be the zero address.
502      * - `to` cannot be the zero address.
503      * - `tokenId` token must exist and be owned by `from`.
504      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
505      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
506      *
507      * Emits a {Transfer} event.
508      */
509     function safeTransferFrom(
510         address from,
511         address to,
512         uint256 tokenId
513     ) external;
514 
515     /**
516      * @dev Transfers `tokenId` token from `from` to `to`.
517      *
518      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
519      *
520      * Requirements:
521      *
522      * - `from` cannot be the zero address.
523      * - `to` cannot be the zero address.
524      * - `tokenId` token must be owned by `from`.
525      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
526      *
527      * Emits a {Transfer} event.
528      */
529     function transferFrom(
530         address from,
531         address to,
532         uint256 tokenId
533     ) external;
534 
535     /**
536      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
537      * The approval is cleared when the token is transferred.
538      *
539      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
540      *
541      * Requirements:
542      *
543      * - The caller must own the token or be an approved operator.
544      * - `tokenId` must exist.
545      *
546      * Emits an {Approval} event.
547      */
548     function approve(address to, uint256 tokenId) external;
549 
550     /**
551      * @dev Returns the account approved for `tokenId` token.
552      *
553      * Requirements:
554      *
555      * - `tokenId` must exist.
556      */
557     function getApproved(uint256 tokenId) external view returns (address operator);
558 
559     /**
560      * @dev Approve or remove `operator` as an operator for the caller.
561      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
562      *
563      * Requirements:
564      *
565      * - The `operator` cannot be the caller.
566      *
567      * Emits an {ApprovalForAll} event.
568      */
569     function setApprovalForAll(address operator, bool _approved) external;
570 
571     /**
572      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
573      *
574      * See {setApprovalForAll}
575      */
576     function isApprovedForAll(address owner, address operator) external view returns (bool);
577 
578     /**
579      * @dev Safely transfers `tokenId` token from `from` to `to`.
580      *
581      * Requirements:
582      *
583      * - `from` cannot be the zero address.
584      * - `to` cannot be the zero address.
585      * - `tokenId` token must exist and be owned by `from`.
586      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
587      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
588      *
589      * Emits a {Transfer} event.
590      */
591     function safeTransferFrom(
592         address from,
593         address to,
594         uint256 tokenId,
595         bytes calldata data
596     ) external;
597 }
598 
599 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
600 
601 
602 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
603 
604 pragma solidity ^0.8.0;
605 
606 
607 /**
608  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
609  * @dev See https://eips.ethereum.org/EIPS/eip-721
610  */
611 interface IERC721Metadata is IERC721 {
612     /**
613      * @dev Returns the token collection name.
614      */
615     function name() external view returns (string memory);
616 
617     /**
618      * @dev Returns the token collection symbol.
619      */
620     function symbol() external view returns (string memory);
621 
622     /**
623      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
624      */
625     function tokenURI(uint256 tokenId) external view returns (string memory);
626 }
627 
628 // File: contracts/new.sol
629 
630 
631 
632 
633 pragma solidity ^0.8.4;
634 
635 
636 
637 
638 
639 
640 
641 
642 error ApprovalCallerNotOwnerNorApproved();
643 error ApprovalQueryForNonexistentToken();
644 error ApproveToCaller();
645 error ApprovalToCurrentOwner();
646 error BalanceQueryForZeroAddress();
647 error MintToZeroAddress();
648 error MintZeroQuantity();
649 error OwnerQueryForNonexistentToken();
650 error TransferCallerNotOwnerNorApproved();
651 error TransferFromIncorrectOwner();
652 error TransferToNonERC721ReceiverImplementer();
653 error TransferToZeroAddress();
654 error URIQueryForNonexistentToken();
655 
656 /**
657  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
658  * the Metadata extension. Built to optimize for lower gas during batch mints.
659  *
660  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
661  *
662  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
663  *
664  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
665  */
666 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
667     using Address for address;
668     using Strings for uint256;
669 
670     // Compiler will pack this into a single 256bit word.
671     struct TokenOwnership {
672         // The address of the owner.
673         address addr;
674         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
675         uint64 startTimestamp;
676         // Whether the token has been burned.
677         bool burned;
678     }
679 
680     // Compiler will pack this into a single 256bit word.
681     struct AddressData {
682         // Realistically, 2**64-1 is more than enough.
683         uint64 balance;
684         // Keeps track of mint count with minimal overhead for tokenomics.
685         uint64 numberMinted;
686         // Keeps track of burn count with minimal overhead for tokenomics.
687         uint64 numberBurned;
688         // For miscellaneous variable(s) pertaining to the address
689         // (e.g. number of whitelist mint slots used).
690         // If there are multiple variables, please pack them into a uint64.
691         uint64 aux;
692     }
693 
694     // The tokenId of the next token to be minted.
695     uint256 internal _currentIndex;
696 
697     // The number of tokens burned.
698     uint256 internal _burnCounter;
699 
700     // Token name
701     string private _name;
702 
703     // Token symbol
704     string private _symbol;
705 
706     // Mapping from token ID to ownership details
707     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
708     mapping(uint256 => TokenOwnership) internal _ownerships;
709 
710     // Mapping owner address to address data
711     mapping(address => AddressData) private _addressData;
712 
713     // Mapping from token ID to approved address
714     mapping(uint256 => address) private _tokenApprovals;
715 
716     // Mapping from owner to operator approvals
717     mapping(address => mapping(address => bool)) private _operatorApprovals;
718 
719     constructor(string memory name_, string memory symbol_) {
720         _name = name_;
721         _symbol = symbol_;
722         _currentIndex = _startTokenId();
723     }
724 
725     /**
726      * To change the starting tokenId, please override this function.
727      */
728     function _startTokenId() internal view virtual returns (uint256) {
729         return 0;
730     }
731 
732     /**
733      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
734      */
735     function totalSupply() public view returns (uint256) {
736         // Counter underflow is impossible as _burnCounter cannot be incremented
737         // more than _currentIndex - _startTokenId() times
738         unchecked {
739             return _currentIndex - _burnCounter - _startTokenId();
740         }
741     }
742 
743     /**
744      * Returns the total amount of tokens minted in the contract.
745      */
746     function _totalMinted() internal view returns (uint256) {
747         // Counter underflow is impossible as _currentIndex does not decrement,
748         // and it is initialized to _startTokenId()
749         unchecked {
750             return _currentIndex - _startTokenId();
751         }
752     }
753 
754     /**
755      * @dev See {IERC165-supportsInterface}.
756      */
757     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
758         return
759             interfaceId == type(IERC721).interfaceId ||
760             interfaceId == type(IERC721Metadata).interfaceId ||
761             super.supportsInterface(interfaceId);
762     }
763 
764     /**
765      * @dev See {IERC721-balanceOf}.
766      */
767     function balanceOf(address owner) public view override returns (uint256) {
768         if (owner == address(0)) revert BalanceQueryForZeroAddress();
769         return uint256(_addressData[owner].balance);
770     }
771 
772     /**
773      * Returns the number of tokens minted by `owner`.
774      */
775     function _numberMinted(address owner) internal view returns (uint256) {
776         return uint256(_addressData[owner].numberMinted);
777     }
778 
779     /**
780      * Returns the number of tokens burned by or on behalf of `owner`.
781      */
782     function _numberBurned(address owner) internal view returns (uint256) {
783         return uint256(_addressData[owner].numberBurned);
784     }
785 
786     /**
787      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
788      */
789     function _getAux(address owner) internal view returns (uint64) {
790         return _addressData[owner].aux;
791     }
792 
793     /**
794      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
795      * If there are multiple variables, please pack them into a uint64.
796      */
797     function _setAux(address owner, uint64 aux) internal {
798         _addressData[owner].aux = aux;
799     }
800 
801     /**
802      * Gas spent here starts off proportional to the maximum mint batch size.
803      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
804      */
805     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
806         uint256 curr = tokenId;
807 
808         unchecked {
809             if (_startTokenId() <= curr && curr < _currentIndex) {
810                 TokenOwnership memory ownership = _ownerships[curr];
811                 if (!ownership.burned) {
812                     if (ownership.addr != address(0)) {
813                         return ownership;
814                     }
815                     // Invariant:
816                     // There will always be an ownership that has an address and is not burned
817                     // before an ownership that does not have an address and is not burned.
818                     // Hence, curr will not underflow.
819                     while (true) {
820                         curr--;
821                         ownership = _ownerships[curr];
822                         if (ownership.addr != address(0)) {
823                             return ownership;
824                         }
825                     }
826                 }
827             }
828         }
829         revert OwnerQueryForNonexistentToken();
830     }
831 
832     /**
833      * @dev See {IERC721-ownerOf}.
834      */
835     function ownerOf(uint256 tokenId) public view override returns (address) {
836         return _ownershipOf(tokenId).addr;
837     }
838 
839     /**
840      * @dev See {IERC721Metadata-name}.
841      */
842     function name() public view virtual override returns (string memory) {
843         return _name;
844     }
845 
846     /**
847      * @dev See {IERC721Metadata-symbol}.
848      */
849     function symbol() public view virtual override returns (string memory) {
850         return _symbol;
851     }
852 
853     /**
854      * @dev See {IERC721Metadata-tokenURI}.
855      */
856     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
857         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
858 
859         string memory baseURI = _baseURI();
860         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
861     }
862 
863     /**
864      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
865      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
866      * by default, can be overriden in child contracts.
867      */
868     function _baseURI() internal view virtual returns (string memory) {
869         return '';
870     }
871 
872     /**
873      * @dev See {IERC721-approve}.
874      */
875     function approve(address to, uint256 tokenId) public override {
876         address owner = ERC721A.ownerOf(tokenId);
877         if (to == owner) revert ApprovalToCurrentOwner();
878 
879         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
880             revert ApprovalCallerNotOwnerNorApproved();
881         }
882 
883         _approve(to, tokenId, owner);
884     }
885 
886     /**
887      * @dev See {IERC721-getApproved}.
888      */
889     function getApproved(uint256 tokenId) public view override returns (address) {
890         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
891 
892         return _tokenApprovals[tokenId];
893     }
894 
895     /**
896      * @dev See {IERC721-setApprovalForAll}.
897      */
898     function setApprovalForAll(address operator, bool approved) public virtual override {
899         if (operator == _msgSender()) revert ApproveToCaller();
900 
901         _operatorApprovals[_msgSender()][operator] = approved;
902         emit ApprovalForAll(_msgSender(), operator, approved);
903     }
904 
905     /**
906      * @dev See {IERC721-isApprovedForAll}.
907      */
908     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
909         return _operatorApprovals[owner][operator];
910     }
911 
912     /**
913      * @dev See {IERC721-transferFrom}.
914      */
915     function transferFrom(
916         address from,
917         address to,
918         uint256 tokenId
919     ) public virtual override {
920         _transfer(from, to, tokenId);
921     }
922 
923     /**
924      * @dev See {IERC721-safeTransferFrom}.
925      */
926     function safeTransferFrom(
927         address from,
928         address to,
929         uint256 tokenId
930     ) public virtual override {
931         safeTransferFrom(from, to, tokenId, '');
932     }
933 
934     /**
935      * @dev See {IERC721-safeTransferFrom}.
936      */
937     function safeTransferFrom(
938         address from,
939         address to,
940         uint256 tokenId,
941         bytes memory _data
942     ) public virtual override {
943         _transfer(from, to, tokenId);
944         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
945             revert TransferToNonERC721ReceiverImplementer();
946         }
947     }
948 
949     /**
950      * @dev Returns whether `tokenId` exists.
951      *
952      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
953      *
954      * Tokens start existing when they are minted (`_mint`),
955      */
956     function _exists(uint256 tokenId) internal view returns (bool) {
957         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
958             !_ownerships[tokenId].burned;
959     }
960 
961     function _safeMint(address to, uint256 quantity) internal {
962         _safeMint(to, quantity, '');
963     }
964 
965     /**
966      * @dev Safely mints `quantity` tokens and transfers them to `to`.
967      *
968      * Requirements:
969      *
970      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
971      * - `quantity` must be greater than 0.
972      *
973      * Emits a {Transfer} event.
974      */
975     function _safeMint(
976         address to,
977         uint256 quantity,
978         bytes memory _data
979     ) internal {
980         _mint(to, quantity, _data, true);
981     }
982 
983     /**
984      * @dev Mints `quantity` tokens and transfers them to `to`.
985      *
986      * Requirements:
987      *
988      * - `to` cannot be the zero address.
989      * - `quantity` must be greater than 0.
990      *
991      * Emits a {Transfer} event.
992      */
993     function _mint(
994         address to,
995         uint256 quantity,
996         bytes memory _data,
997         bool safe
998     ) internal {
999         uint256 startTokenId = _currentIndex;
1000         if (to == address(0)) revert MintToZeroAddress();
1001         if (quantity == 0) revert MintZeroQuantity();
1002 
1003         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1004 
1005         // Overflows are incredibly unrealistic.
1006         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1007         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1008         unchecked {
1009             _addressData[to].balance += uint64(quantity);
1010             _addressData[to].numberMinted += uint64(quantity);
1011 
1012             _ownerships[startTokenId].addr = to;
1013             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1014 
1015             uint256 updatedIndex = startTokenId;
1016             uint256 end = updatedIndex + quantity;
1017 
1018             if (safe && to.isContract()) {
1019                 do {
1020                     emit Transfer(address(0), to, updatedIndex);
1021                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1022                         revert TransferToNonERC721ReceiverImplementer();
1023                     }
1024                 } while (updatedIndex != end);
1025                 // Reentrancy protection
1026                 if (_currentIndex != startTokenId) revert();
1027             } else {
1028                 do {
1029                     emit Transfer(address(0), to, updatedIndex++);
1030                 } while (updatedIndex != end);
1031             }
1032             _currentIndex = updatedIndex;
1033         }
1034         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1035     }
1036 
1037     /**
1038      * @dev Transfers `tokenId` from `from` to `to`.
1039      *
1040      * Requirements:
1041      *
1042      * - `to` cannot be the zero address.
1043      * - `tokenId` token must be owned by `from`.
1044      *
1045      * Emits a {Transfer} event.
1046      */
1047     function _transfer(
1048         address from,
1049         address to,
1050         uint256 tokenId
1051     ) private {
1052         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1053 
1054         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1055 
1056         bool isApprovedOrOwner = (_msgSender() == from ||
1057             isApprovedForAll(from, _msgSender()) ||
1058             getApproved(tokenId) == _msgSender());
1059 
1060         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1061         if (to == address(0)) revert TransferToZeroAddress();
1062 
1063         _beforeTokenTransfers(from, to, tokenId, 1);
1064 
1065         // Clear approvals from the previous owner
1066         _approve(address(0), tokenId, from);
1067 
1068         // Underflow of the sender's balance is impossible because we check for
1069         // ownership above and the recipient's balance can't realistically overflow.
1070         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1071         unchecked {
1072             _addressData[from].balance -= 1;
1073             _addressData[to].balance += 1;
1074 
1075             TokenOwnership storage currSlot = _ownerships[tokenId];
1076             currSlot.addr = to;
1077             currSlot.startTimestamp = uint64(block.timestamp);
1078 
1079             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1080             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1081             uint256 nextTokenId = tokenId + 1;
1082             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1083             if (nextSlot.addr == address(0)) {
1084                 // This will suffice for checking _exists(nextTokenId),
1085                 // as a burned slot cannot contain the zero address.
1086                 if (nextTokenId != _currentIndex) {
1087                     nextSlot.addr = from;
1088                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1089                 }
1090             }
1091         }
1092 
1093         emit Transfer(from, to, tokenId);
1094         _afterTokenTransfers(from, to, tokenId, 1);
1095     }
1096 
1097     /**
1098      * @dev This is equivalent to _burn(tokenId, false)
1099      */
1100     function _burn(uint256 tokenId) internal virtual {
1101         _burn(tokenId, false);
1102     }
1103 
1104     /**
1105      * @dev Destroys `tokenId`.
1106      * The approval is cleared when the token is burned.
1107      *
1108      * Requirements:
1109      *
1110      * - `tokenId` must exist.
1111      *
1112      * Emits a {Transfer} event.
1113      */
1114     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1115         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1116 
1117         address from = prevOwnership.addr;
1118 
1119         if (approvalCheck) {
1120             bool isApprovedOrOwner = (_msgSender() == from ||
1121                 isApprovedForAll(from, _msgSender()) ||
1122                 getApproved(tokenId) == _msgSender());
1123 
1124             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1125         }
1126 
1127         _beforeTokenTransfers(from, address(0), tokenId, 1);
1128 
1129         // Clear approvals from the previous owner
1130         _approve(address(0), tokenId, from);
1131 
1132         // Underflow of the sender's balance is impossible because we check for
1133         // ownership above and the recipient's balance can't realistically overflow.
1134         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1135         unchecked {
1136             AddressData storage addressData = _addressData[from];
1137             addressData.balance -= 1;
1138             addressData.numberBurned += 1;
1139 
1140             // Keep track of who burned the token, and the timestamp of burning.
1141             TokenOwnership storage currSlot = _ownerships[tokenId];
1142             currSlot.addr = from;
1143             currSlot.startTimestamp = uint64(block.timestamp);
1144             currSlot.burned = true;
1145 
1146             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1147             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1148             uint256 nextTokenId = tokenId + 1;
1149             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1150             if (nextSlot.addr == address(0)) {
1151                 // This will suffice for checking _exists(nextTokenId),
1152                 // as a burned slot cannot contain the zero address.
1153                 if (nextTokenId != _currentIndex) {
1154                     nextSlot.addr = from;
1155                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1156                 }
1157             }
1158         }
1159 
1160         emit Transfer(from, address(0), tokenId);
1161         _afterTokenTransfers(from, address(0), tokenId, 1);
1162 
1163         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1164         unchecked {
1165             _burnCounter++;
1166         }
1167     }
1168 
1169     /**
1170      * @dev Approve `to` to operate on `tokenId`
1171      *
1172      * Emits a {Approval} event.
1173      */
1174     function _approve(
1175         address to,
1176         uint256 tokenId,
1177         address owner
1178     ) private {
1179         _tokenApprovals[tokenId] = to;
1180         emit Approval(owner, to, tokenId);
1181     }
1182 
1183     /**
1184      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1185      *
1186      * @param from address representing the previous owner of the given token ID
1187      * @param to target address that will receive the tokens
1188      * @param tokenId uint256 ID of the token to be transferred
1189      * @param _data bytes optional data to send along with the call
1190      * @return bool whether the call correctly returned the expected magic value
1191      */
1192     function _checkContractOnERC721Received(
1193         address from,
1194         address to,
1195         uint256 tokenId,
1196         bytes memory _data
1197     ) private returns (bool) {
1198         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1199             return retval == IERC721Receiver(to).onERC721Received.selector;
1200         } catch (bytes memory reason) {
1201             if (reason.length == 0) {
1202                 revert TransferToNonERC721ReceiverImplementer();
1203             } else {
1204                 assembly {
1205                     revert(add(32, reason), mload(reason))
1206                 }
1207             }
1208         }
1209     }
1210 
1211     /**
1212      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1213      * And also called before burning one token.
1214      *
1215      * startTokenId - the first token id to be transferred
1216      * quantity - the amount to be transferred
1217      *
1218      * Calling conditions:
1219      *
1220      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1221      * transferred to `to`.
1222      * - When `from` is zero, `tokenId` will be minted for `to`.
1223      * - When `to` is zero, `tokenId` will be burned by `from`.
1224      * - `from` and `to` are never both zero.
1225      */
1226     function _beforeTokenTransfers(
1227         address from,
1228         address to,
1229         uint256 startTokenId,
1230         uint256 quantity
1231     ) internal virtual {}
1232 
1233     /**
1234      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1235      * minting.
1236      * And also called after one token has been burned.
1237      *
1238      * startTokenId - the first token id to be transferred
1239      * quantity - the amount to be transferred
1240      *
1241      * Calling conditions:
1242      *
1243      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1244      * transferred to `to`.
1245      * - When `from` is zero, `tokenId` has been minted for `to`.
1246      * - When `to` is zero, `tokenId` has been burned by `from`.
1247      * - `from` and `to` are never both zero.
1248      */
1249     function _afterTokenTransfers(
1250         address from,
1251         address to,
1252         uint256 startTokenId,
1253         uint256 quantity
1254     ) internal virtual {}
1255 }
1256 
1257 abstract contract Ownable is Context {
1258     address private _owner;
1259 
1260     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1261 
1262     /**
1263      * @dev Initializes the contract setting the deployer as the initial owner.
1264      */
1265     constructor() {
1266         _transferOwnership(_msgSender());
1267     }
1268 
1269     /**
1270      * @dev Returns the address of the current owner.
1271      */
1272     function owner() public view virtual returns (address) {
1273         return _owner;
1274     }
1275 
1276     /**
1277      * @dev Throws if called by any account other than the owner.
1278      */
1279     modifier onlyOwner() {
1280         require(owner() == _msgSender() , "Ownable: caller is not the owner");
1281         _;
1282     }
1283 
1284     /**
1285      * @dev Leaves the contract without owner. It will not be possible to call
1286      * `onlyOwner` functions anymore. Can only be called by the current owner.
1287      *
1288      * NOTE: Renouncing ownership will leave the contract without an owner,
1289      * thereby removing any functionality that is only available to the owner.
1290      */
1291     function renounceOwnership() public virtual onlyOwner {
1292         _transferOwnership(address(0));
1293     }
1294 
1295     /**
1296      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1297      * Can only be called by the current owner.
1298      */
1299     function transferOwnership(address newOwner) public virtual onlyOwner {
1300         require(newOwner != address(0), "Ownable: new owner is the zero address");
1301         _transferOwnership(newOwner);
1302     }
1303 
1304     /**
1305      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1306      * Internal function without access restriction.
1307      */
1308     function _transferOwnership(address newOwner) internal virtual {
1309         address oldOwner = _owner;
1310         _owner = newOwner;
1311         emit OwnershipTransferred(oldOwner, newOwner);
1312     }
1313 }
1314 pragma solidity ^0.8.13;
1315 
1316 interface IOperatorFilterRegistry {
1317     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1318     function register(address registrant) external;
1319     function registerAndSubscribe(address registrant, address subscription) external;
1320     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1321     function updateOperator(address registrant, address operator, bool filtered) external;
1322     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1323     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1324     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1325     function subscribe(address registrant, address registrantToSubscribe) external;
1326     function unsubscribe(address registrant, bool copyExistingEntries) external;
1327     function subscriptionOf(address addr) external returns (address registrant);
1328     function subscribers(address registrant) external returns (address[] memory);
1329     function subscriberAt(address registrant, uint256 index) external returns (address);
1330     function copyEntriesOf(address registrant, address registrantToCopy) external;
1331     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1332     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1333     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1334     function filteredOperators(address addr) external returns (address[] memory);
1335     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1336     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1337     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1338     function isRegistered(address addr) external returns (bool);
1339     function codeHashOf(address addr) external returns (bytes32);
1340 }
1341 pragma solidity ^0.8.13;
1342 
1343 
1344 
1345 abstract contract OperatorFilterer {
1346     error OperatorNotAllowed(address operator);
1347 
1348     IOperatorFilterRegistry constant operatorFilterRegistry =
1349         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1350 
1351     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1352         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1353         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1354         // order for the modifier to filter addresses.
1355         if (address(operatorFilterRegistry).code.length > 0) {
1356             if (subscribe) {
1357                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1358             } else {
1359                 if (subscriptionOrRegistrantToCopy != address(0)) {
1360                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1361                 } else {
1362                     operatorFilterRegistry.register(address(this));
1363                 }
1364             }
1365         }
1366     }
1367 
1368     modifier onlyAllowedOperator(address from) virtual {
1369         // Check registry code length to facilitate testing in environments without a deployed registry.
1370         if (address(operatorFilterRegistry).code.length > 0) {
1371             // Allow spending tokens from addresses with balance
1372             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1373             // from an EOA.
1374             if (from == msg.sender) {
1375                 _;
1376                 return;
1377             }
1378             if (
1379                 !(
1380                     operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
1381                         && operatorFilterRegistry.isOperatorAllowed(address(this), from)
1382                 )
1383             ) {
1384                 revert OperatorNotAllowed(msg.sender);
1385             }
1386         }
1387         _;
1388     }
1389 }
1390 pragma solidity ^0.8.13;
1391 
1392 
1393 
1394 abstract contract DefaultOperatorFilterer is OperatorFilterer {
1395     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1396 
1397     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1398 }
1399     pragma solidity ^0.8.7;
1400     
1401     contract TinyBattleBots is ERC721A, DefaultOperatorFilterer , Ownable {
1402     using Strings for uint256;
1403 
1404 
1405   string private uriPrefix ;
1406   string private uriSuffix = ".json";
1407   string public hiddenURL;
1408 
1409   
1410   
1411 
1412   uint256 public cost = 0 ether;
1413  
1414   
1415 
1416   uint16 public maxSupply = 555;
1417   uint8 public maxMintAmountPerTx = 1;
1418     uint8 public maxFreeMintAmountPerWallet = 1;
1419                                                              
1420  
1421   bool public paused = true;
1422   bool public reveal =false;
1423 
1424    mapping (address => uint8) public NFTPerPublicAddress;
1425 
1426  
1427   
1428   
1429  
1430   
1431 
1432   constructor() ERC721A("Tiny Battle Bots", "TBB") {
1433   }
1434 
1435 
1436   
1437  
1438   function mint(uint8 _mintAmount) external payable  {
1439      uint16 totalSupply = uint16(totalSupply());
1440      uint8 nft = NFTPerPublicAddress[msg.sender];
1441     require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
1442     require(_mintAmount + nft <= maxMintAmountPerTx, "Exceeds max per transaction.");
1443 
1444     require(!paused, "The contract is paused!");
1445     
1446       if(nft >= maxFreeMintAmountPerWallet)
1447     {
1448     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1449     }
1450     else {
1451          uint8 costAmount = _mintAmount + nft;
1452         if(costAmount > maxFreeMintAmountPerWallet)
1453        {
1454         costAmount = costAmount - maxFreeMintAmountPerWallet;
1455         require(msg.value >= cost * costAmount, "Insufficient funds!");
1456        }
1457        
1458          
1459     }
1460     
1461 
1462 
1463     _safeMint(msg.sender , _mintAmount);
1464 
1465     NFTPerPublicAddress[msg.sender] = _mintAmount + nft;
1466      
1467      delete totalSupply;
1468      delete _mintAmount;
1469   }
1470   
1471   function Reserve(uint16 _mintAmount, address _receiver) external onlyOwner {
1472      uint16 totalSupply = uint16(totalSupply());
1473     require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
1474      _safeMint(_receiver , _mintAmount);
1475      delete _mintAmount;
1476      delete _receiver;
1477      delete totalSupply;
1478   }
1479 
1480   function  Airdrop(uint8 _amountPerAddress, address[] calldata addresses) external onlyOwner {
1481      uint16 totalSupply = uint16(totalSupply());
1482      uint totalAmount =   _amountPerAddress * addresses.length;
1483     require(totalSupply + totalAmount <= maxSupply, "Exceeds max supply.");
1484      for (uint256 i = 0; i < addresses.length; i++) {
1485             _safeMint(addresses[i], _amountPerAddress);
1486         }
1487 
1488      delete _amountPerAddress;
1489      delete totalSupply;
1490   }
1491 
1492  
1493 
1494   function setMaxSupply(uint16 _maxSupply) external onlyOwner {
1495       maxSupply = _maxSupply;
1496   }
1497 
1498 
1499 
1500    
1501   function tokenURI(uint256 _tokenId)
1502     public
1503     view
1504     virtual
1505     override
1506     returns (string memory)
1507   {
1508     require(
1509       _exists(_tokenId),
1510       "ERC721Metadata: URI query for nonexistent token"
1511     );
1512     
1513   
1514 if ( reveal == false)
1515 {
1516     return hiddenURL;
1517 }
1518     
1519 
1520     string memory currentBaseURI = _baseURI();
1521     return bytes(currentBaseURI).length > 0
1522         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString() ,uriSuffix))
1523         : "";
1524   }
1525  
1526  
1527 
1528 
1529  function setFreeMaxLimitPerAddress(uint8 _limit) external onlyOwner{
1530     maxFreeMintAmountPerWallet = _limit;
1531    delete _limit;
1532 
1533 }
1534 
1535     
1536   
1537 
1538   function setUriPrefix(string memory _uriPrefix) external onlyOwner {
1539     uriPrefix = _uriPrefix;
1540   }
1541    function setHiddenUri(string memory _uriPrefix) external onlyOwner {
1542     hiddenURL = _uriPrefix;
1543   }
1544 
1545 
1546   function setPaused() external onlyOwner {
1547     paused = !paused;
1548    
1549   }
1550 
1551   function setCost(uint _cost) external onlyOwner{
1552       cost = _cost;
1553 
1554   }
1555 
1556  function setRevealed() external onlyOwner{
1557      reveal = !reveal;
1558  }
1559 
1560   function setMaxMintAmountPerTx(uint8 _maxtx) external onlyOwner{
1561       maxMintAmountPerTx = _maxtx;
1562 
1563   }
1564 
1565  
1566 
1567   function withdraw() external onlyOwner {
1568   uint _balance = address(this).balance;
1569      payable(msg.sender).transfer(_balance ); 
1570        
1571   }
1572 
1573 
1574   function _baseURI() internal view  override returns (string memory) {
1575     return uriPrefix;
1576   }
1577 
1578     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1579         super.transferFrom(from, to, tokenId);
1580     }
1581 
1582     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1583         super.safeTransferFrom(from, to, tokenId);
1584     }
1585 
1586     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1587         public
1588         override
1589         onlyAllowedOperator(from)
1590     {
1591         super.safeTransferFrom(from, to, tokenId, data);
1592     }
1593 }