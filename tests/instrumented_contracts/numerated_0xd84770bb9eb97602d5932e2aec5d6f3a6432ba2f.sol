1 // SPDX-License-Identifier: MIT
2 
3 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
4 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWWWWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
5 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWNX0OkxxxkkOO0KKXNWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
6 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWNXK0OkddoooooooooooooodxkkO00KXNNWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
7 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWNK0OxddooddddddddddoooooooooooooloodxxkOO0KKXNNWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
8 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMN0kxdoooooooodddoooooooooooooooooooooooooooooooooddxkkO00KXNNWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
9 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNklcclccllllloooooooooooooddooooooooooooooooooooooooooolllooddxkkOOKKXXXNWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
10 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXdllccccccccclclllllooooooooooooooooooooooooooooooooooooooooooooollooooddxkkOO0KXXNWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
11 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXxllccccccccccccccccccllclllllllloooooooooooooooooooooooooooooooooooooooooooollooodxxkkO00KXNWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
12 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXxllcllccccccccccccccccccccccccccclllllllllooooooooooooooooooooooooooooooooooooooooooollllooddxkOO00KXXNWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
13 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXxllllllclccccccccccccccccccccccccccccccccccccccllllllllloooooooooooooooooooooooooooooooooooooooolllooodxxkkO00KXXNWWMMWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
14 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXxllllllllllccccccccccccccccccccccccccccccccccccccccccccccccclllllooooooooooooooooooooooooooooooooooooooollllllloodxxkkOO0KXXNNWWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
15 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXxllllllllllcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccclllllllooooooooooooooooooooooooooooollllllllllllllllloddxxONMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
16 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXxllllllllllcccccccccccccccccccccccccccclllccccclcccccccccccccccccccccccccccccccllllooooooooooooooooooooooooooooollllllllllccc:;;,:OMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
17 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXxllllllllllcccccccccccccccccccccccccccclllllllllccccccccclllccccccccccccccccccccccccccllllllooooooooooooooooooooooooollcc:;;,,',,;kMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
18 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXxlllllllllllcc:::::::ccccccccccccccccccllccccccccccclllllllllccccccccccccccccccccccccccccccccccc:ccccllllllooooooollc:;,,,,,,,''';OMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
19 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNxllllllllllcc:;;::::::::::::::::ccccccccccccccccllllllllllllllccccccccccccccccccccccccccccccccccccccc:ccccccccccc::;,,,,,,,,,'''.;OMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
20 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNxlllllllllccc:;;ccccccccccc::::::::::::cccccccccllllllllllllllcccccccccccccccccccccccccccccccccccccccccccccc::;;;,,,,,,,,,''''''.,OMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
21 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNxlllllllllccc:,;ccccclllccccccccccccc:::::::::::::cccccccllllllccccccccccccccccccccccccccccccccccccccccccccc:;,''',;;,,,,'''''''.;OMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
22 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNxlllllllccccc:,;cccccll:;:::::ccccccccccccc::::::::::::::::ccccccccccccclccccccccccccccccccccccccccccccccccc:;,'',,;;,,,,'''''''.;OMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
23 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNklllllccclccc;,;ccccclc;;cccccccccccccccccccccccccccccc::::::::::::::ccccccccccccccccccccccccccccccccccccccc:;,,'',,,,,,''''''''.;OMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
24 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNkllllccllclcc;,;cccccccccccccccccccccccccccccccccccccccccccccccc::::::::::::::::::cccc:ccc:ccccccccccccccccc:;,,,,,,,,,,''''''''.;OMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
25 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWkllcccllccccc;,;ccccccccccc;:cc;;cccc::ccccccccccclcccclccccccccccccccccccc::::::::;;:::::::::::ccccccccccc::;'',,,,,,,,''''''''.;0MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
26 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWOllcclccccccc;,;ccccccccccc;,cc,;ccl:,:c:;::c:::cccccclccccccccccccccccccccccccccc::::::::::;;;::cccccccccc::;'',',,,,,,''''''''':0MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
27 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWOolllcccccccc;,:cccccc:cccc;;c:,;:cc:,:c;,;::c:,:cc::c::clccccccccccccccccccccccccccccccccc::::clccccccccccc:;',,'',,,,,''''''''.:0MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
28 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMW0ollllllclccc;,:ccccccccc::::c:;:ccc;;cc,;:::c:,;c:;:::cc:;::c::ccc:cccccccccccccccccccccccccc:clcccccccccc::,''''',,,,,''''''''.:0MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
29 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM0ollllllcllcc;,:cccccccc:::cccc:::::;:cc;;:ccc:,:c;;:ccl:,;:cc:,:c:;::cc:::ccc::cccccc:ccccccccclcccccccccc::,''''',,',,''''''''.:0MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
30 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM0ollllllclccc;,;cccccccccccccccccc:::cc:;:ccc:;;c:;;:ccc;;:::::;:c;;:::c:,;:cc;;:ccc:::::ccccccllcccccccccc::;,'''',,'''''''''''.:KMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
31 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMKdllllllllccc:;:ccccc:ccccccccccccccccc;;:::::::c:;:cccc:;:ccc::c:;;:ccc:,;:cc;,:c:;;:::;;:ccccllc::::cccccc:;''''',,'''''''''''.:KMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
32 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMKollllllllccccclllllccccccccccccccc:ccc;;:cccccccc::ccccc::cc:::c:,;:ccc;,:ccc;,::;;:::c;,;ccccllc:::::c:ccc:;,'''',,''''''''''''cKMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
33 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMKdlllllllllccccccccccccccccccccccccccc::::cccccccccccccccccc::ccc:;:c:cc;;:cc:,;c:,,;::::;:ccc:clc:::::::cc::;,''''',,''''''''''':KMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
34 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMKdlllllllllcccccccccccccccccccccccccccccccccc:cccccccccccccccccccccccccc:::cc:;:c::;:cc::::ccc:clc:::::::::::;,','',,'''''''''.'.:KMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
35 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXxllclllllcccclllcllccccccccccccccccccccccccccccccccccccc:::cccccccccccccccccc::ccc::::;;:ccc::clc:::::::::::,',,',,,'''''''''.'.cKMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
36 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXxlcccllcccclllllccccccccclllccccccccccccccccccccccllcccccccccc:cc:cccc:ccccccccccc::::::cccc::clcc::::::::::,',,'',,,'''''''..'.cXMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
37 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWKdccccccccccllllllccccccclllccccccccccccccccccccccccccccccccccccccccccc:cccccccccccc::c:ccccc:clccc:::::::::,',,'',,''''''''....lXMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
38 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWNKOkxdollcccccccllccccclllllcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccclcc::::::::::,''''',,''''''''....lNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
39 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWNXXK0kxxdolccccccclllllcllcccccccccccccccccccccccccccccccccccccccccccclllcllcccccccccccllc:::::::::::;,,,',,''''''.......lNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
40 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWNXK0Okxdollccccccccccccccccccccccccccccccccccccccccccccccccccccccllllllllllllcllc::::c:::cc:;,,,',,''''''.......oNMWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
41 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWNXK0Okxdolcccccccccccccccccccccccccccccccccccccccccccccccccccccccccclcllcccccccccc::;,,,,',,'''.........oNWWWWWWWWWWMMMMMMMMMMMMMMMMMMMMMMMMMMMM
42 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWNXKOkxdollcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc::;,,,'','''..'.......oNWWWWWWWWWWWWWWWWWWWWWMMMMMMMMMMMMMMMMM
43 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWNXK0Oxdolcc:::ccccccccccccccccccccccccccccccccccccccccccccccccccccc:;,,,'',''''.........oNWWNNWWWWWWWWWWWWWWWWWWWWWWWWMMMMMMMMMM
44 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWNX0Okxdollc::::cccccccccccccccccccccccccccccccccccccccccccc:;,,,',,''''.........dNNNNNWWNNNWWWWWWWWWWWWWWWWWWWWWWWWWWWMM
45 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWNXKOkxdoolc:::::ccccccccccccccccccccccccccccccccccc:;,,,',,'''.........;ONNNNNNNNNWWWWWWWNNWWWWWWWWWWWWWWWWWWWWW
46 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWNXK0Okxdoolc::::ccccccccccccccccccccccccccc:;,,,,,,'''........;dKXXNNNNNNNNNNNNNNWWWWWWNWWWWWWWWWWWWWWWW
47 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWNXK0Okxdolcc::ccccccccccccccc:cccc:;',,,,,'''.....;cdkO0KKXXNNNNNNNNNNNWWWWWWWWWWWWWWWWWMMMMMMM
48 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWNXK0Okxdolc::::::::::::cc::;',,,,''...',cdkkOO00KKKXXXNNNNNWWWWWWWWWWWWMMMMMMMMMMMMMMMM
49 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWNXK0Okxdoc:;;;:::::;,,,'''.',cdxkOOO000KKXXXNNNWWWWWWMMMMMMMMMMMMMMMMMMMMMMMMMM
50 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWNXK0Oxxdolc;,,,'';cokOOO000KKXXNNNWWWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
51 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWNXKOkxxOKXXXXNNNNWWWWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
52 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
53 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
54 
55 
56 
57 
58 // File: @openzeppelin/contracts/utils/Counters.sol
59 
60 
61 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
62 
63 pragma solidity ^0.8.0;
64 
65 /**
66  * @title Counters
67  * @author Matt Condon (@shrugs)
68  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
69  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
70  *
71  * Include with `using Counters for Counters.Counter;`
72  */
73 library Counters {
74     struct Counter {
75         // This variable should never be directly accessed by users of the library: interactions must be restricted to
76         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
77         // this feature: see https://github.com/ethereum/solidity/issues/4637
78         uint256 _value; // default: 0
79     }
80 
81     function current(Counter storage counter) internal view returns (uint256) {
82         return counter._value;
83     }
84 
85     function increment(Counter storage counter) internal {
86         unchecked {
87             counter._value += 1;
88         }
89     }
90 
91     function decrement(Counter storage counter) internal {
92         uint256 value = counter._value;
93         require(value > 0, "Counter: decrement overflow");
94         unchecked {
95             counter._value = value - 1;
96         }
97     }
98 
99     function reset(Counter storage counter) internal {
100         counter._value = 0;
101     }
102 }
103 
104 // File: @openzeppelin/contracts/utils/Strings.sol
105 
106 
107 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
108 
109 pragma solidity ^0.8.0;
110 
111 /**
112  * @dev String operations.
113  */
114 library Strings {
115     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
116 
117     /**
118      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
119      */
120     function toString(uint256 value) internal pure returns (string memory) {
121         // Inspired by OraclizeAPI's implementation - MIT licence
122         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
123 
124         if (value == 0) {
125             return "0";
126         }
127         uint256 temp = value;
128         uint256 digits;
129         while (temp != 0) {
130             digits++;
131             temp /= 10;
132         }
133         bytes memory buffer = new bytes(digits);
134         while (value != 0) {
135             digits -= 1;
136             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
137             value /= 10;
138         }
139         return string(buffer);
140     }
141 
142     /**
143      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
144      */
145     function toHexString(uint256 value) internal pure returns (string memory) {
146         if (value == 0) {
147             return "0x00";
148         }
149         uint256 temp = value;
150         uint256 length = 0;
151         while (temp != 0) {
152             length++;
153             temp >>= 8;
154         }
155         return toHexString(value, length);
156     }
157 
158     /**
159      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
160      */
161     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
162         bytes memory buffer = new bytes(2 * length + 2);
163         buffer[0] = "0";
164         buffer[1] = "x";
165         for (uint256 i = 2 * length + 1; i > 1; --i) {
166             buffer[i] = _HEX_SYMBOLS[value & 0xf];
167             value >>= 4;
168         }
169         require(value == 0, "Strings: hex length insufficient");
170         return string(buffer);
171     }
172 }
173 
174 // File: @openzeppelin/contracts/utils/Context.sol
175 
176 
177 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
178 
179 pragma solidity ^0.8.0;
180 
181 /**
182  * @dev Provides information about the current execution context, including the
183  * sender of the transaction and its data. While these are generally available
184  * via msg.sender and msg.data, they should not be accessed in such a direct
185  * manner, since when dealing with meta-transactions the account sending and
186  * paying for execution may not be the actual sender (as far as an application
187  * is concerned).
188  *
189  * This contract is only required for intermediate, library-like contracts.
190  */
191 abstract contract Context {
192     function _msgSender() internal view virtual returns (address) {
193         return msg.sender;
194     }
195 
196     function _msgData() internal view virtual returns (bytes calldata) {
197         return msg.data;
198     }
199 }
200 
201 // File: @openzeppelin/contracts/access/Ownable.sol
202 
203 
204 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
205 
206 pragma solidity ^0.8.0;
207 
208 
209 /**
210  * @dev Contract module which provides a basic access control mechanism, where
211  * there is an account (an owner) that can be granted exclusive access to
212  * specific functions.
213  *
214  * By default, the owner account will be the one that deploys the contract. This
215  * can later be changed with {transferOwnership}.
216  *
217  * This module is used through inheritance. It will make available the modifier
218  * `onlyOwner`, which can be applied to your functions to restrict their use to
219  * the owner.
220  */
221 abstract contract Ownable is Context {
222     address private _owner;
223 
224     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
225 
226     /**
227      * @dev Initializes the contract setting the deployer as the initial owner.
228      */
229     constructor() {
230         _transferOwnership(_msgSender());
231     }
232 
233     /**
234      * @dev Returns the address of the current owner.
235      */
236     function owner() public view virtual returns (address) {
237         return _owner;
238     }
239 
240     /**
241      * @dev Throws if called by any account other than the owner.
242      */
243     modifier onlyOwner() {
244         require(owner() == _msgSender(), "Ownable: caller is not the owner");
245         _;
246     }
247 
248     /**
249      * @dev Leaves the contract without owner. It will not be possible to call
250      * `onlyOwner` functions anymore. Can only be called by the current owner.
251      *
252      * NOTE: Renouncing ownership will leave the contract without an owner,
253      * thereby removing any functionality that is only available to the owner.
254      */
255     function renounceOwnership() public virtual onlyOwner {
256         _transferOwnership(address(0));
257     }
258 
259     /**
260      * @dev Transfers ownership of the contract to a new account (`newOwner`).
261      * Can only be called by the current owner.
262      */
263     function transferOwnership(address newOwner) public virtual onlyOwner {
264         require(newOwner != address(0), "Ownable: new owner is the zero address");
265         _transferOwnership(newOwner);
266     }
267 
268     /**
269      * @dev Transfers ownership of the contract to a new account (`newOwner`).
270      * Internal function without access restriction.
271      */
272     function _transferOwnership(address newOwner) internal virtual {
273         address oldOwner = _owner;
274         _owner = newOwner;
275         emit OwnershipTransferred(oldOwner, newOwner);
276     }
277 }
278 
279 // File: @openzeppelin/contracts/utils/Address.sol
280 
281 
282 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
283 
284 pragma solidity ^0.8.1;
285 
286 /**
287  * @dev Collection of functions related to the address type
288  */
289 library Address {
290     /**
291      * @dev Returns true if `account` is a contract.
292      *
293      * [IMPORTANT]
294      * ====
295      * It is unsafe to assume that an address for which this function returns
296      * false is an externally-owned account (EOA) and not a contract.
297      *
298      * Among others, `isContract` will return false for the following
299      * types of addresses:
300      *
301      *  - an externally-owned account
302      *  - a contract in construction
303      *  - an address where a contract will be created
304      *  - an address where a contract lived, but was destroyed
305      * ====
306      *
307      * [IMPORTANT]
308      * ====
309      * You shouldn't rely on `isContract` to protect against flash loan attacks!
310      *
311      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
312      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
313      * constructor.
314      * ====
315      */
316     function isContract(address account) internal view returns (bool) {
317         // This method relies on extcodesize/address.code.length, which returns 0
318         // for contracts in construction, since the code is only stored at the end
319         // of the constructor execution.
320 
321         return account.code.length > 0;
322     }
323 
324     /**
325      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
326      * `recipient`, forwarding all available gas and reverting on errors.
327      *
328      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
329      * of certain opcodes, possibly making contracts go over the 2300 gas limit
330      * imposed by `transfer`, making them unable to receive funds via
331      * `transfer`. {sendValue} removes this limitation.
332      *
333      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
334      *
335      * IMPORTANT: because control is transferred to `recipient`, care must be
336      * taken to not create reentrancy vulnerabilities. Consider using
337      * {ReentrancyGuard} or the
338      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
339      */
340     function sendValue(address payable recipient, uint256 amount) internal {
341         require(address(this).balance >= amount, "Address: insufficient balance");
342 
343         (bool success, ) = recipient.call{value: amount}("");
344         require(success, "Address: unable to send value, recipient may have reverted");
345     }
346 
347     /**
348      * @dev Performs a Solidity function call using a low level `call`. A
349      * plain `call` is an unsafe replacement for a function call: use this
350      * function instead.
351      *
352      * If `target` reverts with a revert reason, it is bubbled up by this
353      * function (like regular Solidity function calls).
354      *
355      * Returns the raw returned data. To convert to the expected return value,
356      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
357      *
358      * Requirements:
359      *
360      * - `target` must be a contract.
361      * - calling `target` with `data` must not revert.
362      *
363      * _Available since v3.1._
364      */
365     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
366         return functionCall(target, data, "Address: low-level call failed");
367     }
368 
369     /**
370      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
371      * `errorMessage` as a fallback revert reason when `target` reverts.
372      *
373      * _Available since v3.1._
374      */
375     function functionCall(
376         address target,
377         bytes memory data,
378         string memory errorMessage
379     ) internal returns (bytes memory) {
380         return functionCallWithValue(target, data, 0, errorMessage);
381     }
382 
383     /**
384      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
385      * but also transferring `value` wei to `target`.
386      *
387      * Requirements:
388      *
389      * - the calling contract must have an ETH balance of at least `value`.
390      * - the called Solidity function must be `payable`.
391      *
392      * _Available since v3.1._
393      */
394     function functionCallWithValue(
395         address target,
396         bytes memory data,
397         uint256 value
398     ) internal returns (bytes memory) {
399         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
400     }
401 
402     /**
403      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
404      * with `errorMessage` as a fallback revert reason when `target` reverts.
405      *
406      * _Available since v3.1._
407      */
408     function functionCallWithValue(
409         address target,
410         bytes memory data,
411         uint256 value,
412         string memory errorMessage
413     ) internal returns (bytes memory) {
414         require(address(this).balance >= value, "Address: insufficient balance for call");
415         require(isContract(target), "Address: call to non-contract");
416 
417         (bool success, bytes memory returndata) = target.call{value: value}(data);
418         return verifyCallResult(success, returndata, errorMessage);
419     }
420 
421     /**
422      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
423      * but performing a static call.
424      *
425      * _Available since v3.3._
426      */
427     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
428         return functionStaticCall(target, data, "Address: low-level static call failed");
429     }
430 
431     /**
432      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
433      * but performing a static call.
434      *
435      * _Available since v3.3._
436      */
437     function functionStaticCall(
438         address target,
439         bytes memory data,
440         string memory errorMessage
441     ) internal view returns (bytes memory) {
442         require(isContract(target), "Address: static call to non-contract");
443 
444         (bool success, bytes memory returndata) = target.staticcall(data);
445         return verifyCallResult(success, returndata, errorMessage);
446     }
447 
448     /**
449      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
450      * but performing a delegate call.
451      *
452      * _Available since v3.4._
453      */
454     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
455         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
456     }
457 
458     /**
459      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
460      * but performing a delegate call.
461      *
462      * _Available since v3.4._
463      */
464     function functionDelegateCall(
465         address target,
466         bytes memory data,
467         string memory errorMessage
468     ) internal returns (bytes memory) {
469         require(isContract(target), "Address: delegate call to non-contract");
470 
471         (bool success, bytes memory returndata) = target.delegatecall(data);
472         return verifyCallResult(success, returndata, errorMessage);
473     }
474 
475     /**
476      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
477      * revert reason using the provided one.
478      *
479      * _Available since v4.3._
480      */
481     function verifyCallResult(
482         bool success,
483         bytes memory returndata,
484         string memory errorMessage
485     ) internal pure returns (bytes memory) {
486         if (success) {
487             return returndata;
488         } else {
489             // Look for revert reason and bubble it up if present
490             if (returndata.length > 0) {
491                 // The easiest way to bubble the revert reason is using memory via assembly
492 
493                 assembly {
494                     let returndata_size := mload(returndata)
495                     revert(add(32, returndata), returndata_size)
496                 }
497             } else {
498                 revert(errorMessage);
499             }
500         }
501     }
502 }
503 
504 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
505 
506 
507 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
508 
509 pragma solidity ^0.8.0;
510 
511 /**
512  * @title ERC721 token receiver interface
513  * @dev Interface for any contract that wants to support safeTransfers
514  * from ERC721 asset contracts.
515  */
516 interface IERC721Receiver {
517     /**
518      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
519      * by `operator` from `from`, this function is called.
520      *
521      * It must return its Solidity selector to confirm the token transfer.
522      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
523      *
524      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
525      */
526     function onERC721Received(
527         address operator,
528         address from,
529         uint256 tokenId,
530         bytes calldata data
531     ) external returns (bytes4);
532 }
533 
534 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
535 
536 
537 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
538 
539 pragma solidity ^0.8.0;
540 
541 /**
542  * @dev Interface of the ERC165 standard, as defined in the
543  * https://eips.ethereum.org/EIPS/eip-165[EIP].
544  *
545  * Implementers can declare support of contract interfaces, which can then be
546  * queried by others ({ERC165Checker}).
547  *
548  * For an implementation, see {ERC165}.
549  */
550 interface IERC165 {
551     /**
552      * @dev Returns true if this contract implements the interface defined by
553      * `interfaceId`. See the corresponding
554      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
555      * to learn more about how these ids are created.
556      *
557      * This function call must use less than 30 000 gas.
558      */
559     function supportsInterface(bytes4 interfaceId) external view returns (bool);
560 }
561 
562 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
563 
564 
565 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
566 
567 pragma solidity ^0.8.0;
568 
569 
570 /**
571  * @dev Implementation of the {IERC165} interface.
572  *
573  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
574  * for the additional interface id that will be supported. For example:
575  *
576  * ```solidity
577  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
578  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
579  * }
580  * ```
581  *
582  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
583  */
584 abstract contract ERC165 is IERC165 {
585     /**
586      * @dev See {IERC165-supportsInterface}.
587      */
588     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
589         return interfaceId == type(IERC165).interfaceId;
590     }
591 }
592 
593 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
594 
595 
596 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
597 
598 pragma solidity ^0.8.0;
599 
600 
601 /**
602  * @dev Required interface of an ERC721 compliant contract.
603  */
604 interface IERC721 is IERC165 {
605     /**
606      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
607      */
608     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
609 
610     /**
611      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
612      */
613     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
614 
615     /**
616      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
617      */
618     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
619 
620     /**
621      * @dev Returns the number of tokens in ``owner``'s account.
622      */
623     function balanceOf(address owner) external view returns (uint256 balance);
624 
625     /**
626      * @dev Returns the owner of the `tokenId` token.
627      *
628      * Requirements:
629      *
630      * - `tokenId` must exist.
631      */
632     function ownerOf(uint256 tokenId) external view returns (address owner);
633 
634     /**
635      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
636      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
637      *
638      * Requirements:
639      *
640      * - `from` cannot be the zero address.
641      * - `to` cannot be the zero address.
642      * - `tokenId` token must exist and be owned by `from`.
643      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
644      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
645      *
646      * Emits a {Transfer} event.
647      */
648     function safeTransferFrom(
649         address from,
650         address to,
651         uint256 tokenId
652     ) external;
653 
654     /**
655      * @dev Transfers `tokenId` token from `from` to `to`.
656      *
657      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
658      *
659      * Requirements:
660      *
661      * - `from` cannot be the zero address.
662      * - `to` cannot be the zero address.
663      * - `tokenId` token must be owned by `from`.
664      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
665      *
666      * Emits a {Transfer} event.
667      */
668     function transferFrom(
669         address from,
670         address to,
671         uint256 tokenId
672     ) external;
673 
674     /**
675      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
676      * The approval is cleared when the token is transferred.
677      *
678      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
679      *
680      * Requirements:
681      *
682      * - The caller must own the token or be an approved operator.
683      * - `tokenId` must exist.
684      *
685      * Emits an {Approval} event.
686      */
687     function approve(address to, uint256 tokenId) external;
688 
689     /**
690      * @dev Returns the account approved for `tokenId` token.
691      *
692      * Requirements:
693      *
694      * - `tokenId` must exist.
695      */
696     function getApproved(uint256 tokenId) external view returns (address operator);
697 
698     /**
699      * @dev Approve or remove `operator` as an operator for the caller.
700      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
701      *
702      * Requirements:
703      *
704      * - The `operator` cannot be the caller.
705      *
706      * Emits an {ApprovalForAll} event.
707      */
708     function setApprovalForAll(address operator, bool _approved) external;
709 
710     /**
711      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
712      *
713      * See {setApprovalForAll}
714      */
715     function isApprovedForAll(address owner, address operator) external view returns (bool);
716 
717     /**
718      * @dev Safely transfers `tokenId` token from `from` to `to`.
719      *
720      * Requirements:
721      *
722      * - `from` cannot be the zero address.
723      * - `to` cannot be the zero address.
724      * - `tokenId` token must exist and be owned by `from`.
725      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
726      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
727      *
728      * Emits a {Transfer} event.
729      */
730     function safeTransferFrom(
731         address from,
732         address to,
733         uint256 tokenId,
734         bytes calldata data
735     ) external;
736 }
737 
738 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
739 
740 
741 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
742 
743 pragma solidity ^0.8.0;
744 
745 
746 /**
747  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
748  * @dev See https://eips.ethereum.org/EIPS/eip-721
749  */
750 interface IERC721Metadata is IERC721 {
751     /**
752      * @dev Returns the token collection name.
753      */
754     function name() external view returns (string memory);
755 
756     /**
757      * @dev Returns the token collection symbol.
758      */
759     function symbol() external view returns (string memory);
760 
761     /**
762      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
763      */
764     function tokenURI(uint256 tokenId) external view returns (string memory);
765 }
766 
767 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
768 
769 
770 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
771 
772 pragma solidity ^0.8.0;
773 
774 
775 
776 
777 
778 
779 
780 
781 /**
782  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
783  * the Metadata extension, but not including the Enumerable extension, which is available separately as
784  * {ERC721Enumerable}.
785  */
786 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
787     using Address for address;
788     using Strings for uint256;
789 
790     // Token name
791     string private _name;
792 
793     // Token symbol
794     string private _symbol;
795 
796     // Mapping from token ID to owner address
797     mapping(uint256 => address) private _owners;
798 
799     // Mapping owner address to token count
800     mapping(address => uint256) private _balances;
801 
802     // Mapping from token ID to approved address
803     mapping(uint256 => address) private _tokenApprovals;
804 
805     // Mapping from owner to operator approvals
806     mapping(address => mapping(address => bool)) private _operatorApprovals;
807 
808     /**
809      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
810      */
811     constructor(string memory name_, string memory symbol_) {
812         _name = name_;
813         _symbol = symbol_;
814     }
815 
816     /**
817      * @dev See {IERC165-supportsInterface}.
818      */
819     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
820         return
821             interfaceId == type(IERC721).interfaceId ||
822             interfaceId == type(IERC721Metadata).interfaceId ||
823             super.supportsInterface(interfaceId);
824     }
825 
826     /**
827      * @dev See {IERC721-balanceOf}.
828      */
829     function balanceOf(address owner) public view virtual override returns (uint256) {
830         require(owner != address(0), "ERC721: balance query for the zero address");
831         return _balances[owner];
832     }
833 
834     /**
835      * @dev See {IERC721-ownerOf}.
836      */
837     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
838         address owner = _owners[tokenId];
839         require(owner != address(0), "ERC721: owner query for nonexistent token");
840         return owner;
841     }
842 
843     /**
844      * @dev See {IERC721Metadata-name}.
845      */
846     function name() public view virtual override returns (string memory) {
847         return _name;
848     }
849 
850     /**
851      * @dev See {IERC721Metadata-symbol}.
852      */
853     function symbol() public view virtual override returns (string memory) {
854         return _symbol;
855     }
856 
857     /**
858      * @dev See {IERC721Metadata-tokenURI}.
859      */
860     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
861         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
862 
863         string memory baseURI = _baseURI();
864         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
865     }
866 
867     /**
868      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
869      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
870      * by default, can be overriden in child contracts.
871      */
872     function _baseURI() internal view virtual returns (string memory) {
873         return "";
874     }
875 
876     /**
877      * @dev See {IERC721-approve}.
878      */
879     function approve(address to, uint256 tokenId) public virtual override {
880         address owner = ERC721.ownerOf(tokenId);
881         require(to != owner, "ERC721: approval to current owner");
882 
883         require(
884             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
885             "ERC721: approve caller is not owner nor approved for all"
886         );
887 
888         _approve(to, tokenId);
889     }
890 
891     /**
892      * @dev See {IERC721-getApproved}.
893      */
894     function getApproved(uint256 tokenId) public view virtual override returns (address) {
895         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
896 
897         return _tokenApprovals[tokenId];
898     }
899 
900     /**
901      * @dev See {IERC721-setApprovalForAll}.
902      */
903     function setApprovalForAll(address operator, bool approved) public virtual override {
904         _setApprovalForAll(_msgSender(), operator, approved);
905     }
906 
907     /**
908      * @dev See {IERC721-isApprovedForAll}.
909      */
910     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
911         return _operatorApprovals[owner][operator];
912     }
913 
914     /**
915      * @dev See {IERC721-transferFrom}.
916      */
917     function transferFrom(
918         address from,
919         address to,
920         uint256 tokenId
921     ) public virtual override {
922         //solhint-disable-next-line max-line-length
923         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
924 
925         _transfer(from, to, tokenId);
926     }
927 
928     /**
929      * @dev See {IERC721-safeTransferFrom}.
930      */
931     function safeTransferFrom(
932         address from,
933         address to,
934         uint256 tokenId
935     ) public virtual override {
936         safeTransferFrom(from, to, tokenId, "");
937     }
938 
939     /**
940      * @dev See {IERC721-safeTransferFrom}.
941      */
942     function safeTransferFrom(
943         address from,
944         address to,
945         uint256 tokenId,
946         bytes memory _data
947     ) public virtual override {
948         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
949         _safeTransfer(from, to, tokenId, _data);
950     }
951 
952     /**
953      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
954      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
955      *
956      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
957      *
958      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
959      * implement alternative mechanisms to perform token transfer, such as signature-based.
960      *
961      * Requirements:
962      *
963      * - `from` cannot be the zero address.
964      * - `to` cannot be the zero address.
965      * - `tokenId` token must exist and be owned by `from`.
966      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
967      *
968      * Emits a {Transfer} event.
969      */
970     function _safeTransfer(
971         address from,
972         address to,
973         uint256 tokenId,
974         bytes memory _data
975     ) internal virtual {
976         _transfer(from, to, tokenId);
977         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
978     }
979 
980     /**
981      * @dev Returns whether `tokenId` exists.
982      *
983      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
984      *
985      * Tokens start existing when they are minted (`_mint`),
986      * and stop existing when they are burned (`_burn`).
987      */
988     function _exists(uint256 tokenId) internal view virtual returns (bool) {
989         return _owners[tokenId] != address(0);
990     }
991 
992     /**
993      * @dev Returns whether `spender` is allowed to manage `tokenId`.
994      *
995      * Requirements:
996      *
997      * - `tokenId` must exist.
998      */
999     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1000         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1001         address owner = ERC721.ownerOf(tokenId);
1002         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1003     }
1004 
1005     /**
1006      * @dev Safely mints `tokenId` and transfers it to `to`.
1007      *
1008      * Requirements:
1009      *
1010      * - `tokenId` must not exist.
1011      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1012      *
1013      * Emits a {Transfer} event.
1014      */
1015     function _safeMint(address to, uint256 tokenId) internal virtual {
1016         _safeMint(to, tokenId, "");
1017     }
1018 
1019     /**
1020      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1021      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1022      */
1023     function _safeMint(
1024         address to,
1025         uint256 tokenId,
1026         bytes memory _data
1027     ) internal virtual {
1028         _mint(to, tokenId);
1029         require(
1030             _checkOnERC721Received(address(0), to, tokenId, _data),
1031             "ERC721: transfer to non ERC721Receiver implementer"
1032         );
1033     }
1034 
1035     /**
1036      * @dev Mints `tokenId` and transfers it to `to`.
1037      *
1038      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1039      *
1040      * Requirements:
1041      *
1042      * - `tokenId` must not exist.
1043      * - `to` cannot be the zero address.
1044      *
1045      * Emits a {Transfer} event.
1046      */
1047     function _mint(address to, uint256 tokenId) internal virtual {
1048         require(to != address(0), "ERC721: mint to the zero address");
1049         require(!_exists(tokenId), "ERC721: token already minted");
1050 
1051         _beforeTokenTransfer(address(0), to, tokenId);
1052 
1053         _balances[to] += 1;
1054         _owners[tokenId] = to;
1055 
1056         emit Transfer(address(0), to, tokenId);
1057 
1058         _afterTokenTransfer(address(0), to, tokenId);
1059     }
1060 
1061     /**
1062      * @dev Destroys `tokenId`.
1063      * The approval is cleared when the token is burned.
1064      *
1065      * Requirements:
1066      *
1067      * - `tokenId` must exist.
1068      *
1069      * Emits a {Transfer} event.
1070      */
1071     function _burn(uint256 tokenId) internal virtual {
1072         address owner = ERC721.ownerOf(tokenId);
1073 
1074         _beforeTokenTransfer(owner, address(0), tokenId);
1075 
1076         // Clear approvals
1077         _approve(address(0), tokenId);
1078 
1079         _balances[owner] -= 1;
1080         delete _owners[tokenId];
1081 
1082         emit Transfer(owner, address(0), tokenId);
1083 
1084         _afterTokenTransfer(owner, address(0), tokenId);
1085     }
1086 
1087     /**
1088      * @dev Transfers `tokenId` from `from` to `to`.
1089      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1090      *
1091      * Requirements:
1092      *
1093      * - `to` cannot be the zero address.
1094      * - `tokenId` token must be owned by `from`.
1095      *
1096      * Emits a {Transfer} event.
1097      */
1098     function _transfer(
1099         address from,
1100         address to,
1101         uint256 tokenId
1102     ) internal virtual {
1103         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1104         require(to != address(0), "ERC721: transfer to the zero address");
1105 
1106         _beforeTokenTransfer(from, to, tokenId);
1107 
1108         // Clear approvals from the previous owner
1109         _approve(address(0), tokenId);
1110 
1111         _balances[from] -= 1;
1112         _balances[to] += 1;
1113         _owners[tokenId] = to;
1114 
1115         emit Transfer(from, to, tokenId);
1116 
1117         _afterTokenTransfer(from, to, tokenId);
1118     }
1119 
1120     /**
1121      * @dev Approve `to` to operate on `tokenId`
1122      *
1123      * Emits a {Approval} event.
1124      */
1125     function _approve(address to, uint256 tokenId) internal virtual {
1126         _tokenApprovals[tokenId] = to;
1127         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1128     }
1129 
1130     /**
1131      * @dev Approve `operator` to operate on all of `owner` tokens
1132      *
1133      * Emits a {ApprovalForAll} event.
1134      */
1135     function _setApprovalForAll(
1136         address owner,
1137         address operator,
1138         bool approved
1139     ) internal virtual {
1140         require(owner != operator, "ERC721: approve to caller");
1141         _operatorApprovals[owner][operator] = approved;
1142         emit ApprovalForAll(owner, operator, approved);
1143     }
1144 
1145     /**
1146      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1147      * The call is not executed if the target address is not a contract.
1148      *
1149      * @param from address representing the previous owner of the given token ID
1150      * @param to target address that will receive the tokens
1151      * @param tokenId uint256 ID of the token to be transferred
1152      * @param _data bytes optional data to send along with the call
1153      * @return bool whether the call correctly returned the expected magic value
1154      */
1155     function _checkOnERC721Received(
1156         address from,
1157         address to,
1158         uint256 tokenId,
1159         bytes memory _data
1160     ) private returns (bool) {
1161         if (to.isContract()) {
1162             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1163                 return retval == IERC721Receiver.onERC721Received.selector;
1164             } catch (bytes memory reason) {
1165                 if (reason.length == 0) {
1166                     revert("ERC721: transfer to non ERC721Receiver implementer");
1167                 } else {
1168                     assembly {
1169                         revert(add(32, reason), mload(reason))
1170                     }
1171                 }
1172             }
1173         } else {
1174             return true;
1175         }
1176     }
1177 
1178     /**
1179      * @dev Hook that is called before any token transfer. This includes minting
1180      * and burning.
1181      *
1182      * Calling conditions:
1183      *
1184      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1185      * transferred to `to`.
1186      * - When `from` is zero, `tokenId` will be minted for `to`.
1187      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1188      * - `from` and `to` are never both zero.
1189      *
1190      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1191      */
1192     function _beforeTokenTransfer(
1193         address from,
1194         address to,
1195         uint256 tokenId
1196     ) internal virtual {}
1197 
1198     /**
1199      * @dev Hook that is called after any transfer of tokens. This includes
1200      * minting and burning.
1201      *
1202      * Calling conditions:
1203      *
1204      * - when `from` and `to` are both non-zero.
1205      * - `from` and `to` are never both zero.
1206      *
1207      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1208      */
1209     function _afterTokenTransfer(
1210         address from,
1211         address to,
1212         uint256 tokenId
1213     ) internal virtual {}
1214 }
1215 
1216 // File: Brickers NFT.sol
1217 
1218 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1219 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWWWWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1220 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWNX0OkxxxkkOO0KKXNWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1221 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWNXK0OkddoooooooooooooodxkkO00KXNNWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1222 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWNK0OxddooddddddddddoooooooooooooloodxxkOO0KKXNNWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1223 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMN0kxdoooooooodddoooooooooooooooooooooooooooooooooddxkkO00KXNNWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1224 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNklcclccllllloooooooooooooddooooooooooooooooooooooooooolllooddxkkOOKKXXXNWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1225 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXdllccccccccclclllllooooooooooooooooooooooooooooooooooooooooooooollooooddxkkOO0KXXNWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1226 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXxllccccccccccccccccccllclllllllloooooooooooooooooooooooooooooooooooooooooooollooodxxkkO00KXNWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1227 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXxllcllccccccccccccccccccccccccccclllllllllooooooooooooooooooooooooooooooooooooooooooollllooddxkOO00KXXNWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1228 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXxllllllclccccccccccccccccccccccccccccccccccccccllllllllloooooooooooooooooooooooooooooooooooooooolllooodxxkkO00KXXNWWMMWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1229 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXxllllllllllccccccccccccccccccccccccccccccccccccccccccccccccclllllooooooooooooooooooooooooooooooooooooooollllllloodxxkkOO0KXXNNWWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1230 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXxllllllllllcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccclllllllooooooooooooooooooooooooooooollllllllllllllllloddxxONMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1231 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXxllllllllllcccccccccccccccccccccccccccclllccccclcccccccccccccccccccccccccccccccllllooooooooooooooooooooooooooooollllllllllccc:;;,:OMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1232 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXxllllllllllcccccccccccccccccccccccccccclllllllllccccccccclllccccccccccccccccccccccccccllllllooooooooooooooooooooooooollcc:;;,,',,;kMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1233 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXxlllllllllllcc:::::::ccccccccccccccccccllccccccccccclllllllllccccccccccccccccccccccccccccccccccc:ccccllllllooooooollc:;,,,,,,,''';OMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1234 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNxllllllllllcc:;;::::::::::::::::ccccccccccccccccllllllllllllllccccccccccccccccccccccccccccccccccccccc:ccccccccccc::;,,,,,,,,,'''.;OMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1235 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNxlllllllllccc:;;ccccccccccc::::::::::::cccccccccllllllllllllllcccccccccccccccccccccccccccccccccccccccccccccc::;;;,,,,,,,,,''''''.,OMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1236 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNxlllllllllccc:,;ccccclllccccccccccccc:::::::::::::cccccccllllllccccccccccccccccccccccccccccccccccccccccccccc:;,''',;;,,,,'''''''.;OMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1237 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNxlllllllccccc:,;cccccll:;:::::ccccccccccccc::::::::::::::::ccccccccccccclccccccccccccccccccccccccccccccccccc:;,'',,;;,,,,'''''''.;OMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1238 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNklllllccclccc;,;ccccclc;;cccccccccccccccccccccccccccccc::::::::::::::ccccccccccccccccccccccccccccccccccccccc:;,,'',,,,,,''''''''.;OMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1239 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNkllllccllclcc;,;cccccccccccccccccccccccccccccccccccccccccccccccc::::::::::::::::::cccc:ccc:ccccccccccccccccc:;,,,,,,,,,,''''''''.;OMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1240 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWkllcccllccccc;,;ccccccccccc;:cc;;cccc::ccccccccccclcccclccccccccccccccccccc::::::::;;:::::::::::ccccccccccc::;'',,,,,,,,''''''''.;0MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1241 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWOllcclccccccc;,;ccccccccccc;,cc,;ccl:,:c:;::c:::cccccclccccccccccccccccccccccccccc::::::::::;;;::cccccccccc::;'',',,,,,,''''''''':0MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1242 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWOolllcccccccc;,:cccccc:cccc;;c:,;:cc:,:c;,;::c:,:cc::c::clccccccccccccccccccccccccccccccccc::::clccccccccccc:;',,'',,,,,''''''''.:0MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1243 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMW0ollllllclccc;,:ccccccccc::::c:;:ccc;;cc,;:::c:,;c:;:::cc:;::c::ccc:cccccccccccccccccccccccccc:clcccccccccc::,''''',,,,,''''''''.:0MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1244 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM0ollllllcllcc;,:cccccccc:::cccc:::::;:cc;;:ccc:,:c;;:ccl:,;:cc:,:c:;::cc:::ccc::cccccc:ccccccccclcccccccccc::,''''',,',,''''''''.:0MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1245 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM0ollllllclccc;,;cccccccccccccccccc:::cc:;:ccc:;;c:;;:ccc;;:::::;:c;;:::c:,;:cc;;:ccc:::::ccccccllcccccccccc::;,'''',,'''''''''''.:KMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1246 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMKdllllllllccc:;:ccccc:ccccccccccccccccc;;:::::::c:;:cccc:;:ccc::c:;;:ccc:,;:cc;,:c:;;:::;;:ccccllc::::cccccc:;''''',,'''''''''''.:KMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1247 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMKollllllllccccclllllccccccccccccccc:ccc;;:cccccccc::ccccc::cc:::c:,;:ccc;,:ccc;,::;;:::c;,;ccccllc:::::c:ccc:;,'''',,''''''''''''cKMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1248 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMKdlllllllllccccccccccccccccccccccccccc::::cccccccccccccccccc::ccc:;:c:cc;;:cc:,;c:,,;::::;:ccc:clc:::::::cc::;,''''',,''''''''''':KMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1249 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMKdlllllllllcccccccccccccccccccccccccccccccccc:cccccccccccccccccccccccccc:::cc:;:c::;:cc::::ccc:clc:::::::::::;,','',,'''''''''.'.:KMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1250 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXxllclllllcccclllcllccccccccccccccccccccccccccccccccccccc:::cccccccccccccccccc::ccc::::;;:ccc::clc:::::::::::,',,',,,'''''''''.'.cKMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1251 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXxlcccllcccclllllccccccccclllccccccccccccccccccccccllcccccccccc:cc:cccc:ccccccccccc::::::cccc::clcc::::::::::,',,'',,,'''''''..'.cXMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1252 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWKdccccccccccllllllccccccclllccccccccccccccccccccccccccccccccccccccccccc:cccccccccccc::c:ccccc:clccc:::::::::,',,'',,''''''''....lXMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1253 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWNKOkxdollcccccccllccccclllllcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccclcc::::::::::,''''',,''''''''....lNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1254 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWNXXK0kxxdolccccccclllllcllcccccccccccccccccccccccccccccccccccccccccccclllcllcccccccccccllc:::::::::::;,,,',,''''''.......lNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1255 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWNXK0Okxdollccccccccccccccccccccccccccccccccccccccccccccccccccccccllllllllllllcllc::::c:::cc:;,,,',,''''''.......oNMWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1256 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWNXK0Okxdolcccccccccccccccccccccccccccccccccccccccccccccccccccccccccclcllcccccccccc::;,,,,',,'''.........oNWWWWWWWWWWMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1257 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWNXKOkxdollcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc::;,,,'','''..'.......oNWWWWWWWWWWWWWWWWWWWWWMMMMMMMMMMMMMMMMM
1258 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWNXK0Oxdolcc:::ccccccccccccccccccccccccccccccccccccccccccccccccccccc:;,,,'',''''.........oNWWNNWWWWWWWWWWWWWWWWWWWWWWWWMMMMMMMMMM
1259 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWNX0Okxdollc::::cccccccccccccccccccccccccccccccccccccccccccc:;,,,',,''''.........dNNNNNWWNNNWWWWWWWWWWWWWWWWWWWWWWWWWWWMM
1260 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWNXKOkxdoolc:::::ccccccccccccccccccccccccccccccccccc:;,,,',,'''.........;ONNNNNNNNNWWWWWWWNNWWWWWWWWWWWWWWWWWWWWW
1261 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWNXK0Okxdoolc::::ccccccccccccccccccccccccccc:;,,,,,,'''........;dKXXNNNNNNNNNNNNNNWWWWWWNWWWWWWWWWWWWWWWW
1262 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWNXK0Okxdolcc::ccccccccccccccc:cccc:;',,,,,'''.....;cdkO0KKXXNNNNNNNNNNNWWWWWWWWWWWWWWWWWMMMMMMM
1263 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWNXK0Okxdolc::::::::::::cc::;',,,,''...',cdkkOO00KKKXXXNNNNNWWWWWWWWWWWWMMMMMMMMMMMMMMMM
1264 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWNXK0Okxdoc:;;;:::::;,,,'''.',cdxkOOO000KKXXXNNNWWWWWWMMMMMMMMMMMMMMMMMMMMMMMMMM
1265 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWNXK0Oxxdolc;,,,'';cokOOO000KKXXNNNWWWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1266 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWNXKOkxxOKXXXXNNNNWWWWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1267 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1268 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1269 
1270 
1271 pragma solidity ^0.8.2;
1272 
1273 
1274 
1275 
1276 
1277 contract TheBrickers is ERC721, Ownable {
1278 
1279     using Strings for uint256;
1280 
1281     using Counters for Counters.Counter;
1282 
1283     Counters.Counter private supply;
1284 
1285     string public uriPrefix = "ipfs://QmPhMAmZigHwt1uRsHajKpw5SUmyrzJQE5dTetZw9vKcAu/";
1286     string public uriSuffix = ".json";
1287     string public hiddenMetadataUri;
1288 
1289     uint256 public cost = 0 ether;
1290     uint256 public maxSupply = 420;
1291     uint256 public maxMintAmountPerTx = 2;
1292 
1293     bool public paused = false;
1294     bool public revealed = true;
1295 
1296     constructor() ERC721("The Brickers", "BRICKERS") {
1297         setHiddenMetadataUri("ipfs://QmPhMAmZigHwt1uRsHajKpw5SUmyrzJQE5dTetZw9vKcAu/");
1298     }
1299 
1300      modifier mintCompliance(uint256 _mintAmount) {
1301         require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1302         require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
1303         _;
1304     }
1305 
1306     function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1307         require(!paused, "The contract is paused!");
1308 
1309         if(supply.current() < 420) {
1310             require(total_nft(msg.sender) < 10,  "NFT Per Wallet Limit Exceeds!!");
1311             _mintLoop(msg.sender, _mintAmount);
1312         }
1313         else{
1314             require(total_nft(msg.sender) < 10,  "NFT Per Wallet Limit Exceeds!!");
1315             require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1316             _mintLoop(msg.sender, _mintAmount);
1317         }
1318     }
1319 
1320     
1321     function total_nft(address _buyer) public view returns (uint256) {
1322        uint256[] memory _num = walletOfOwner(_buyer);
1323        return _num.length;
1324     }
1325 
1326     function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1327         for (uint256 i = 0; i < _mintAmount; i++) {
1328             supply.increment();
1329             _safeMint(_receiver, supply.current());
1330         }
1331     }
1332 
1333     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory){
1334         require(
1335         _exists(_tokenId),
1336         "ERC721Metadata: URI query for nonexistent token"
1337         );
1338 
1339         if (revealed == false) {
1340             return hiddenMetadataUri;
1341         }
1342 
1343         string memory currentBaseURI = _baseURI();
1344         return bytes(currentBaseURI).length > 0
1345             ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1346             : "";
1347     }
1348 
1349     function walletOfOwner(address _owner) public view returns (uint256[] memory) {
1350         uint256 ownerTokenCount = balanceOf(_owner);
1351         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1352         uint256 currentTokenId = 1;
1353         uint256 ownedTokenIndex = 0;
1354 
1355         while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1356 
1357             address currentTokenOwner = ownerOf(currentTokenId);
1358 
1359             if (currentTokenOwner == _owner) {
1360                 ownedTokenIds[ownedTokenIndex] = currentTokenId;
1361 
1362                 ownedTokenIndex++;
1363             }
1364 
1365             currentTokenId++;
1366         }
1367 
1368         return ownedTokenIds;
1369     }
1370 
1371 
1372     function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1373         uriPrefix = _uriPrefix;
1374     }
1375 
1376     function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1377         uriSuffix = _uriSuffix;
1378     }
1379 
1380     function setPaused(bool _state) public onlyOwner {
1381         paused = _state;
1382     }
1383 
1384     function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1385 		hiddenMetadataUri = _hiddenMetadataUri;
1386 	}
1387 
1388     function setRevealed(bool _state) public onlyOwner {
1389         revealed = _state;
1390     }
1391 
1392     function setCost(uint256 _cost) public onlyOwner {
1393         cost = _cost;
1394     }
1395 
1396     function totalSupply() public view returns (uint256) {
1397         return supply.current();
1398     }
1399 
1400     function _baseURI() internal view virtual override returns (string memory) {
1401         return uriPrefix;
1402     }
1403 
1404     function withdraw() public onlyOwner {
1405         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1406         require(os);
1407     }    
1408    
1409 }