1 /*
2 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
3 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@------------ @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
4 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@---.            .--.@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
5 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@---..   ..+@@@#+..  .---@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
6 @@@@@@@@@@@@:-----------------:@@@----     .=@@@@@@@@#.   .--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
7 @@@@@@@@@@---.                ...--.    .:#@@@@@@@@@@#.   .--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
8 @@@@@@@@@--.   .=@@@@@@@#=-....      .-#@@@@@@@@@@@@@#.   .--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
9 @@@@@@@@@--.   -@@@@@@@@@@@@@@@@@@@##@@@@@@@#: #@@@@@#.   .--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
10 @@@@@@@@@@--    .*@@@@@@@@@@@@@@@@@@@@@@@#:    #@@@@@#.   .---@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
11 @@@@@@@@@@@--.   .-#@@@@@@=    .-=+#@#*-       #@@@@@#.      ..----:@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
12 @@@@@@@@@@@@---.   .+@@@@@@#.                  *@@@@@@@@#*...      ..----@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
13 @@@@@@@@@@@@@@--.   .-@@@@@@@=                  .*#@@@@@@@@@@@#+-..     .---@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
14 @@@@@@@@@@@@@@:--.   ..#@@@@@@:                       -#@@@@@@@@@@@@#=.   .--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
15 @@@@@@@@@@@@---.   ..#@@@@@@@-                          .-:*@@@@@@@@@@:.   --@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
16 @@@@@@@@@@---.   ..#@@@@@@#-                    =##@@@@@@@@@@@@@@@@@#..   ---@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
17 @@@@@@@@@--.   ..#@@@@@@#- ..-:=+*#+.         =@@@@@@@@@@@@@#*=....     .---@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
18 @@@@@@@@--.  ..#@@@@@@@@@@@@@@@@@@@@@@#:     .#@@@@@@@@@@@@#-.     ..----:@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
19 @@@@@@@#--   .=@@@@@@@@@@@@@@@@@##@@@@@@@*.  +@@@@@@:*@@@@@@@@#:.    .---@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
20 @@@@@@@@---    ...-......         .=@@@@@@@@+@@@@@@*. ..=@@@@@@@@*..   .---@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
21 @@@@@@@@@@---..        ......---    ..#@@@@@@@@@@@@-.     .+@@@@@@@#..   .--:@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
22 @@@@@@@@@@@@@@@-----:--@@@@@@@@---.    .:@@@@@@@@@+.   .    .:@@@@@@@#.    ---@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
23 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@---.   ..*@@@@@*.   .---.   .-#@@@@@@:.   ---:-----#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
24 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@---.     ...     .--@---.   .#@@@@@@=.            .....----- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
25 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@----.......----..         .#@@@@@@-..............        ----@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
26 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@---.        .....:+**#@@@@@@@@@@@@@@@@@@@@@@@@@#=..   .---@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
27 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@---.    ..+@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#-.   ---@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
28 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--.   .-#@@@@@@@@@@@@##=:.                      -@@@@@@@:.   --@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
29 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--.   .+@@@@@@#=                                   #@@@@@#.   .--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
30 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--   .=@@@@@@*                                     *@@@@@@=.   .-------@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
31 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@-.   .*@@@@@@-                   .-:++*##@@@@@##**+=#@@@@@#...         ..----:@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
32 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--.   .#@@@@@#     .:+#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#+:...       .-----@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
33 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@---.   .#@@@@@##@@@@@@@@@@@@@@@@@@@@#+=--........--=+*#@@@@@@@@@@@@@@@@@@@##:..      .---- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
34 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@:---..     ..#@@@@@@@@@@@@@#*=-..-::::::-.                           .:+#@@@@@@@@@@@@@*-.      .----@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
35 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@----.    ..:#@@@@@@@@@@@*..-:::::::::-.                                         .=#@@@@@@@@@@#+..     .---@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
36 @@@@@@@@@@@@@@@@@@@@@@@@@@---.     .:#@@@@@@@@@#=.-:::::::::::-                                                    -*#@@@@@@@@@=..    .----@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
37 @@@@@@@@@@@@@@@@@@@@@@@---.    ..*#@@@@@@@@*.-::::::::::::-                                                            .=#@@@@@@@@#-.    .--- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
38 @@@@@@@@@@@@@@@@@@@@----    ..*@@@@@@@@*--:::::::::::::.                                                                   .+@@@@@@@@#-.    .---@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
39 @@@@@@@@@@@@@@@@@@---.    .+#@@@@@@@+.::::::::::::::-                                                                          :#@@@@@@@*..   .---@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
40 @@@@@@@@@@@@@@@@---.   ..#@@@@@@@*.-::::::::::::::.                                                                               =#@@@@@@#:.    ---@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
41 @@@@@@@@@@@@@@---.   .-#@@@@@@#--::::::::::::::-                                                                                    .*@@@@@@@=.    ---@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
42 @@@@@@@@@@@@ --.   .-@@@@@@@#.-::::::::::::::-.                                                                                        +@@@@@@@=.   .--:@@@@@@-----------@@@@@@@@@@
43 @@@@@@@@@@@---    .#@@@@@@#.::::::::::::::::.                                                                                            +@@@@@@#-.   .--@@@@--.       .--@@@@@@@@@
44 @@@@@@@@@@--.   .:@@@@@@#--:::::::::::::::-                                                                                                *@@@@@@*.    ------.   .*-.   .-------@@
45 @@@@@@@@@--.   .#@@@@@@=.::::::::::::::::.                                                                                                  .#@@@@@#-.           .*@#-.        .--@
46 @@@@@@@:--   ..#@@@@@#.-::::::::::::::::.                                            =+                                                       *@@@@@@:.    .-#@@@@@@@@@@@#+..  .--@
47 @@@@@@---.  ..#@@@@@#.:::::::::::::::::.                                            :@@+                                                       +@@@@@@=.      ..#@@@@@@-.     .---@
48 @@@@@@--.   .#@@@@@#.-::::::::::::::::.                                         *#@@@@@@@@@#.                                                   +@@@@@@-.     .*@#-..*#@-.   --@@@@
49 @@@@@--.   .#@@@@@@--::::::::::::::::-                                            :@@@@@@*                                                       #@@@@@@-     ..       ...   --@@@@
50 @@@@@--   .:@@@@@@:-:::::::::::::::::.                                           =#+    :#+                                                      .#@@@@@*.       .---..   ..---@@@@
51 @@@@--.   .#@@@@@#.:::::::::::::::::-                                                                                                             +@@@@@@:.  .--@@@@@@@@@@@@@@@@@@@
52 @@@@--   .:@@@@@@=.:::::::::::::::::-                                                                                                 .#@#-       .@@@@@@+.   --@@@@@@@@@@@@@@@@@@@
53 @@@@--   .=@@@@@@.-:::::::::::::::::-                                                                       .=*=.                    +@@@#.        #@@@@@*.   .--@@@@@@@@@@@@@@@@@@
54 @@@@--   .+@@@@@#.-:::::::::::::::::-                                                                       .#@@@@@#=              *@@@@-          *@@@@@#.   .--@@@@@@@@@@@@@@@@@@
55 @@@@--   .+@@@@@@.-:::::::::::::::::-                                                                           .=#@@@@@@@#####@@@@@@*.            *@@@@@#.   .--@@@@@@@@@@@@@@@@@@
56 @@@@--   .=@@@@@@.-::::::::::::::::::.                                                                                .-+#@@@@@#*-.                #@@@@@*.   .-@@@@@@@@@@@@@@@@@@@
57 @@@@--.   -@@@@@@+.::::::::::::::::::-                                                                                                            -@@@@@@=.   --@@@@@@@@@@@@@@@@@@@
58 @@@@--.   .*@@@@@#.-::::::::::::::::::.                                                                                                           #@@@@@@-   .--@@@@@@@@@@@@@@@@@@@
59 @@@@@--   .-@@@@@@+.:::::::::::::::::::.                                                                                                         -@@@@@@=.   ---@@@@@@@@@@@@@@@@@@@
60 @@@@@---   .+@@@@@@:.:::::::::::::::::::.                                                                                                       .@@@@@@#.   .--@@@@@@@@@@@@@@@@@@@@
61 @@@@@@--.   .#@@@@@@:.:::::::::::::::::::.                                                                                                     .#@@@@@#.   .--@@@@@@@@@@@@@@@@@@@@@
62 @@@@@@@--.   .*@@@@@@:.:::::::::::::::::::-                                                                                                   .#@@@@@#..  .--:@@@@@@@@@@@@@@@@@@@@@
63 @@@@@@@@--.   .+@@@@@@+.::::::::::::::::::::.                                                                                                -#@@@@@#.   .--:@@@@@@@@@@@@@@@@@@@@@@
64 @@@@@@@@@--.   .:@@@@@@#.-:::::::::::::::::::-.                                                                                            .*@@@@@@+.   .--@@@@@@@@@@@@@@@@@@@@@@@@
65 @@@@@@@@@@---    .#@@@@@@+.-:::::::::::::::::::-.                                                                                         :@@@@@@#-.   .--@@@@@@@@@@@@@@@@@@@@@@@@@
66 @@@@@@@@@@@:--.   .:@@@@@@#+.-::::::::::::::::::::.                                                                                     -#@@@@@@+.   .---@@@@@@@@@@@@@@@@@@@@@@@@@@
67 @@@@@@@@@@@@@---    .=@@@@@@@+.-::::::::::::::::::::-                                                                                 -@@@@@@@*.    .--@@@@@@@@@@@@@@@@@@@@@@@@@@@@
68 @@@@@@@@@@@@@@@---    .=@@@@@@@#..:::::::::::::::::::::-                                                                            +@@@@@@@*.    .--:@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
69 @@@@@@@@@@@@@@@@@---    .-#@@@@@@@*.-:::::::::::::::::::::-.                                                                     :@@@@@@@@=.    .--:@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
70 @@@@@@@@@@@@@@@@@@@---.    .+@@@@@@@#*.-::::::::::::::::::::::-.                                                              =#@@@@@@@#..    ---@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
71 @@@@@@@@@@@@@@@@@@@@@---.    ..*@@@@@@@@#-.-::::::::::::::::::::::-.                                                      .*@@@@@@@@#-.    .---@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
72 @@@@@@@@@@@@@@@@@@@@@@@@---.    ..+#@@@@@@@@#:.-::::::::::::::::::::::::-.                                            -*@@@@@@@@@*..    .---@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
73 @@@@@@@@@@@@@@@@@@@@@@@@@@@---.     ..#@@@@@@@@@@#- .-:::::::::::::::::::::::::--.                               .*#@@@@@@@@@@:..    .---#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
74 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@----.     .-+@@@@@@@@@@@@*:...-::::::::::::::::::::::::::::::::--------..    -+#@@@@@@@@@@@*:.     ..---@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
75 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@----.     ...*@@@@@@@@@@@@@@##+-   ...---:::::::::::::--...     .=##@@@@@@@@@@@@@@#-..      ----#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
76 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@:----.      ..-+#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#*:..      ..----@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
77 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@-----..       ...-=#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#+-...        .-----#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
78 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@------...          .......-::===++===::--......           ..------@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
79 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@---------...                           ..--------- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
80 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@:---------------------@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
81 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
82 */
83 
84 pragma solidity ^0.8.0;
85 
86 /**
87  * @title Counters
88  * @author Matt Condon (@shrugs)
89  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
90  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
91  *
92  * Include with `using Counters for Counters.Counter;`
93  */
94 library Counters {
95     struct Counter {
96         // This variable should never be directly accessed by users of the library: interactions must be restricted to
97         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
98         // this feature: see https://github.com/ethereum/solidity/issues/4637
99         uint256 _value; // default: 0
100     }
101 
102     function current(Counter storage counter) internal view returns (uint256) {
103         return counter._value;
104     }
105 
106     function increment(Counter storage counter) internal {
107         unchecked {
108             counter._value += 1;
109         }
110     }
111 
112     function decrement(Counter storage counter) internal {
113         uint256 value = counter._value;
114         require(value > 0, "Counter: decrement overflow");
115         unchecked {
116             counter._value = value - 1;
117         }
118     }
119 
120     function reset(Counter storage counter) internal {
121         counter._value = 0;
122     }
123 }
124 
125 // File: @openzeppelin/contracts/utils/Strings.sol
126 
127 
128 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
129 
130 pragma solidity ^0.8.0;
131 
132 /**
133  * @dev String operations.
134  */
135 library Strings {
136     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
137 
138     /**
139      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
140      */
141     function toString(uint256 value) internal pure returns (string memory) {
142         // Inspired by OraclizeAPI's implementation - MIT licence
143         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
144 
145         if (value == 0) {
146             return "0";
147         }
148         uint256 temp = value;
149         uint256 digits;
150         while (temp != 0) {
151             digits++;
152             temp /= 10;
153         }
154         bytes memory buffer = new bytes(digits);
155         while (value != 0) {
156             digits -= 1;
157             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
158             value /= 10;
159         }
160         return string(buffer);
161     }
162 
163     /**
164      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
165      */
166     function toHexString(uint256 value) internal pure returns (string memory) {
167         if (value == 0) {
168             return "0x00";
169         }
170         uint256 temp = value;
171         uint256 length = 0;
172         while (temp != 0) {
173             length++;
174             temp >>= 8;
175         }
176         return toHexString(value, length);
177     }
178 
179     /**
180      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
181      */
182     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
183         bytes memory buffer = new bytes(2 * length + 2);
184         buffer[0] = "0";
185         buffer[1] = "x";
186         for (uint256 i = 2 * length + 1; i > 1; --i) {
187             buffer[i] = _HEX_SYMBOLS[value & 0xf];
188             value >>= 4;
189         }
190         require(value == 0, "Strings: hex length insufficient");
191         return string(buffer);
192     }
193 }
194 
195 // File: @openzeppelin/contracts/utils/Context.sol
196 
197 
198 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
199 
200 pragma solidity ^0.8.0;
201 
202 /**
203  * @dev Provides information about the current execution context, including the
204  * sender of the transaction and its data. While these are generally available
205  * via msg.sender and msg.data, they should not be accessed in such a direct
206  * manner, since when dealing with meta-transactions the account sending and
207  * paying for execution may not be the actual sender (as far as an application
208  * is concerned).
209  *
210  * This contract is only required for intermediate, library-like contracts.
211  */
212 abstract contract Context {
213     function _msgSender() internal view virtual returns (address) {
214         return msg.sender;
215     }
216 
217     function _msgData() internal view virtual returns (bytes calldata) {
218         return msg.data;
219     }
220 }
221 
222 // File: @openzeppelin/contracts/access/Ownable.sol
223 
224 
225 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
226 
227 pragma solidity ^0.8.0;
228 
229 
230 /**
231  * @dev Contract module which provides a basic access control mechanism, where
232  * there is an account (an owner) that can be granted exclusive access to
233  * specific functions.
234  *
235  * By default, the owner account will be the one that deploys the contract. This
236  * can later be changed with {transferOwnership}.
237  *
238  * This module is used through inheritance. It will make available the modifier
239  * `onlyOwner`, which can be applied to your functions to restrict their use to
240  * the owner.
241  */
242 abstract contract Ownable is Context {
243     address private _owner;
244 
245     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
246 
247     /**
248      * @dev Initializes the contract setting the deployer as the initial owner.
249      */
250     constructor() {
251         _transferOwnership(_msgSender());
252     }
253 
254     /**
255      * @dev Returns the address of the current owner.
256      */
257     function owner() public view virtual returns (address) {
258         return _owner;
259     }
260 
261     /**
262      * @dev Throws if called by any account other than the owner.
263      */
264     modifier onlyOwner() {
265         require(owner() == _msgSender(), "Ownable: caller is not the owner");
266         _;
267     }
268 
269     /**
270      * @dev Leaves the contract without owner. It will not be possible to call
271      * `onlyOwner` functions anymore. Can only be called by the current owner.
272      *
273      * NOTE: Renouncing ownership will leave the contract without an owner,
274      * thereby removing any functionality that is only available to the owner.
275      */
276     function renounceOwnership() public virtual onlyOwner {
277         _transferOwnership(address(0));
278     }
279 
280     /**
281      * @dev Transfers ownership of the contract to a new account (`newOwner`).
282      * Can only be called by the current owner.
283      */
284     function transferOwnership(address newOwner) public virtual onlyOwner {
285         require(newOwner != address(0), "Ownable: new owner is the zero address");
286         _transferOwnership(newOwner);
287     }
288 
289     /**
290      * @dev Transfers ownership of the contract to a new account (`newOwner`).
291      * Internal function without access restriction.
292      */
293     function _transferOwnership(address newOwner) internal virtual {
294         address oldOwner = _owner;
295         _owner = newOwner;
296         emit OwnershipTransferred(oldOwner, newOwner);
297     }
298 }
299 
300 // File: @openzeppelin/contracts/utils/Address.sol
301 
302 
303 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
304 
305 pragma solidity ^0.8.0;
306 
307 /**
308  * @dev Collection of functions related to the address type
309  */
310 library Address {
311     /**
312      * @dev Returns true if `account` is a contract.
313      *
314      * [IMPORTANT]
315      * ====
316      * It is unsafe to assume that an address for which this function returns
317      * false is an externally-owned account (EOA) and not a contract.
318      *
319      * Among others, `isContract` will return false for the following
320      * types of addresses:
321      *
322      *  - an externally-owned account
323      *  - a contract in construction
324      *  - an address where a contract will be created
325      *  - an address where a contract lived, but was destroyed
326      * ====
327      */
328     function isContract(address account) internal view returns (bool) {
329         // This method relies on extcodesize, which returns 0 for contracts in
330         // construction, since the code is only stored at the end of the
331         // constructor execution.
332 
333         uint256 size;
334         assembly {
335             size := extcodesize(account)
336         }
337         return size > 0;
338     }
339 
340     /**
341      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
342      * `recipient`, forwarding all available gas and reverting on errors.
343      *
344      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
345      * of certain opcodes, possibly making contracts go over the 2300 gas limit
346      * imposed by `transfer`, making them unable to receive funds via
347      * `transfer`. {sendValue} removes this limitation.
348      *
349      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
350      *
351      * IMPORTANT: because control is transferred to `recipient`, care must be
352      * taken to not create reentrancy vulnerabilities. Consider using
353      * {ReentrancyGuard} or the
354      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
355      */
356     function sendValue(address payable recipient, uint256 amount) internal {
357         require(address(this).balance >= amount, "Address: insufficient balance");
358 
359         (bool success, ) = recipient.call{value: amount}("");
360         require(success, "Address: unable to send value, recipient may have reverted");
361     }
362 
363     /**
364      * @dev Performs a Solidity function call using a low level `call`. A
365      * plain `call` is an unsafe replacement for a function call: use this
366      * function instead.
367      *
368      * If `target` reverts with a revert reason, it is bubbled up by this
369      * function (like regular Solidity function calls).
370      *
371      * Returns the raw returned data. To convert to the expected return value,
372      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
373      *
374      * Requirements:
375      *
376      * - `target` must be a contract.
377      * - calling `target` with `data` must not revert.
378      *
379      * _Available since v3.1._
380      */
381     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
382         return functionCall(target, data, "Address: low-level call failed");
383     }
384 
385     /**
386      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
387      * `errorMessage` as a fallback revert reason when `target` reverts.
388      *
389      * _Available since v3.1._
390      */
391     function functionCall(
392         address target,
393         bytes memory data,
394         string memory errorMessage
395     ) internal returns (bytes memory) {
396         return functionCallWithValue(target, data, 0, errorMessage);
397     }
398 
399     /**
400      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
401      * but also transferring `value` wei to `target`.
402      *
403      * Requirements:
404      *
405      * - the calling contract must have an ETH balance of at least `value`.
406      * - the called Solidity function must be `payable`.
407      *
408      * _Available since v3.1._
409      */
410     function functionCallWithValue(
411         address target,
412         bytes memory data,
413         uint256 value
414     ) internal returns (bytes memory) {
415         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
416     }
417 
418     /**
419      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
420      * with `errorMessage` as a fallback revert reason when `target` reverts.
421      *
422      * _Available since v3.1._
423      */
424     function functionCallWithValue(
425         address target,
426         bytes memory data,
427         uint256 value,
428         string memory errorMessage
429     ) internal returns (bytes memory) {
430         require(address(this).balance >= value, "Address: insufficient balance for call");
431         require(isContract(target), "Address: call to non-contract");
432 
433         (bool success, bytes memory returndata) = target.call{value: value}(data);
434         return verifyCallResult(success, returndata, errorMessage);
435     }
436 
437     /**
438      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
439      * but performing a static call.
440      *
441      * _Available since v3.3._
442      */
443     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
444         return functionStaticCall(target, data, "Address: low-level static call failed");
445     }
446 
447     /**
448      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
449      * but performing a static call.
450      *
451      * _Available since v3.3._
452      */
453     function functionStaticCall(
454         address target,
455         bytes memory data,
456         string memory errorMessage
457     ) internal view returns (bytes memory) {
458         require(isContract(target), "Address: static call to non-contract");
459 
460         (bool success, bytes memory returndata) = target.staticcall(data);
461         return verifyCallResult(success, returndata, errorMessage);
462     }
463 
464     /**
465      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
466      * but performing a delegate call.
467      *
468      * _Available since v3.4._
469      */
470     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
471         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
472     }
473 
474     /**
475      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
476      * but performing a delegate call.
477      *
478      * _Available since v3.4._
479      */
480     function functionDelegateCall(
481         address target,
482         bytes memory data,
483         string memory errorMessage
484     ) internal returns (bytes memory) {
485         require(isContract(target), "Address: delegate call to non-contract");
486 
487         (bool success, bytes memory returndata) = target.delegatecall(data);
488         return verifyCallResult(success, returndata, errorMessage);
489     }
490 
491     /**
492      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
493      * revert reason using the provided one.
494      *
495      * _Available since v4.3._
496      */
497     function verifyCallResult(
498         bool success,
499         bytes memory returndata,
500         string memory errorMessage
501     ) internal pure returns (bytes memory) {
502         if (success) {
503             return returndata;
504         } else {
505             // Look for revert reason and bubble it up if present
506             if (returndata.length > 0) {
507                 // The easiest way to bubble the revert reason is using memory via assembly
508 
509                 assembly {
510                     let returndata_size := mload(returndata)
511                     revert(add(32, returndata), returndata_size)
512                 }
513             } else {
514                 revert(errorMessage);
515             }
516         }
517     }
518 }
519 
520 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
521 
522 
523 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
524 
525 pragma solidity ^0.8.0;
526 
527 /**
528  * @title ERC721 token receiver interface
529  * @dev Interface for any contract that wants to support safeTransfers
530  * from ERC721 asset contracts.
531  */
532 interface IERC721Receiver {
533     /**
534      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
535      * by `operator` from `from`, this function is called.
536      *
537      * It must return its Solidity selector to confirm the token transfer.
538      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
539      *
540      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
541      */
542     function onERC721Received(
543         address operator,
544         address from,
545         uint256 tokenId,
546         bytes calldata data
547     ) external returns (bytes4);
548 }
549 
550 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
551 
552 
553 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
554 
555 pragma solidity ^0.8.0;
556 
557 /**
558  * @dev Interface of the ERC165 standard, as defined in the
559  * https://eips.ethereum.org/EIPS/eip-165[EIP].
560  *
561  * Implementers can declare support of contract interfaces, which can then be
562  * queried by others ({ERC165Checker}).
563  *
564  * For an implementation, see {ERC165}.
565  */
566 interface IERC165 {
567     /**
568      * @dev Returns true if this contract implements the interface defined by
569      * `interfaceId`. See the corresponding
570      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
571      * to learn more about how these ids are created.
572      *
573      * This function call must use less than 30 000 gas.
574      */
575     function supportsInterface(bytes4 interfaceId) external view returns (bool);
576 }
577 
578 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
579 
580 
581 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
582 
583 pragma solidity ^0.8.0;
584 
585 
586 /**
587  * @dev Implementation of the {IERC165} interface.
588  *
589  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
590  * for the additional interface id that will be supported. For example:
591  *
592  * ```solidity
593  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
594  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
595  * }
596  * ```
597  *
598  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
599  */
600 abstract contract ERC165 is IERC165 {
601     /**
602      * @dev See {IERC165-supportsInterface}.
603      */
604     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
605         return interfaceId == type(IERC165).interfaceId;
606     }
607 }
608 
609 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
610 
611 
612 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
613 
614 pragma solidity ^0.8.0;
615 
616 
617 /**
618  * @dev Required interface of an ERC721 compliant contract.
619  */
620 interface IERC721 is IERC165 {
621     /**
622      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
623      */
624     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
625 
626     /**
627      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
628      */
629     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
630 
631     /**
632      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
633      */
634     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
635 
636     /**
637      * @dev Returns the number of tokens in ``owner``'s account.
638      */
639     function balanceOf(address owner) external view returns (uint256 balance);
640 
641     /**
642      * @dev Returns the owner of the `tokenId` token.
643      *
644      * Requirements:
645      *
646      * - `tokenId` must exist.
647      */
648     function ownerOf(uint256 tokenId) external view returns (address owner);
649 
650     /**
651      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
652      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
653      *
654      * Requirements:
655      *
656      * - `from` cannot be the zero address.
657      * - `to` cannot be the zero address.
658      * - `tokenId` token must exist and be owned by `from`.
659      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
660      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
661      *
662      * Emits a {Transfer} event.
663      */
664     function safeTransferFrom(
665         address from,
666         address to,
667         uint256 tokenId
668     ) external;
669 
670     /**
671      * @dev Transfers `tokenId` token from `from` to `to`.
672      *
673      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
674      *
675      * Requirements:
676      *
677      * - `from` cannot be the zero address.
678      * - `to` cannot be the zero address.
679      * - `tokenId` token must be owned by `from`.
680      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
681      *
682      * Emits a {Transfer} event.
683      */
684     function transferFrom(
685         address from,
686         address to,
687         uint256 tokenId
688     ) external;
689 
690     /**
691      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
692      * The approval is cleared when the token is transferred.
693      *
694      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
695      *
696      * Requirements:
697      *
698      * - The caller must own the token or be an approved operator.
699      * - `tokenId` must exist.
700      *
701      * Emits an {Approval} event.
702      */
703     function approve(address to, uint256 tokenId) external;
704 
705     /**
706      * @dev Returns the account approved for `tokenId` token.
707      *
708      * Requirements:
709      *
710      * - `tokenId` must exist.
711      */
712     function getApproved(uint256 tokenId) external view returns (address operator);
713 
714     /**
715      * @dev Approve or remove `operator` as an operator for the caller.
716      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
717      *
718      * Requirements:
719      *
720      * - The `operator` cannot be the caller.
721      *
722      * Emits an {ApprovalForAll} event.
723      */
724     function setApprovalForAll(address operator, bool _approved) external;
725 
726     /**
727      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
728      *
729      * See {setApprovalForAll}
730      */
731     function isApprovedForAll(address owner, address operator) external view returns (bool);
732 
733     /**
734      * @dev Safely transfers `tokenId` token from `from` to `to`.
735      *
736      * Requirements:
737      *
738      * - `from` cannot be the zero address.
739      * - `to` cannot be the zero address.
740      * - `tokenId` token must exist and be owned by `from`.
741      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
742      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
743      *
744      * Emits a {Transfer} event.
745      */
746     function safeTransferFrom(
747         address from,
748         address to,
749         uint256 tokenId,
750         bytes calldata data
751     ) external;
752 }
753 
754 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
755 
756 
757 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
758 
759 pragma solidity ^0.8.0;
760 
761 
762 /**
763  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
764  * @dev See https://eips.ethereum.org/EIPS/eip-721
765  */
766 interface IERC721Metadata is IERC721 {
767     /**
768      * @dev Returns the token collection name.
769      */
770     function name() external view returns (string memory);
771 
772     /**
773      * @dev Returns the token collection symbol.
774      */
775     function symbol() external view returns (string memory);
776 
777     /**
778      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
779      */
780     function tokenURI(uint256 tokenId) external view returns (string memory);
781 }
782 
783 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
784 
785 
786 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
787 
788 pragma solidity ^0.8.0;
789 
790 
791 
792 
793 
794 
795 
796 
797 /**
798  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
799  * the Metadata extension, but not including the Enumerable extension, which is available separately as
800  * {ERC721Enumerable}.
801  */
802 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
803     using Address for address;
804     using Strings for uint256;
805 
806     // Token name
807     string private _name;
808 
809     // Token symbol
810     string private _symbol;
811 
812     // Mapping from token ID to owner address
813     mapping(uint256 => address) private _owners;
814 
815     // Mapping owner address to token count
816     mapping(address => uint256) private _balances;
817 
818     // Mapping from token ID to approved address
819     mapping(uint256 => address) private _tokenApprovals;
820 
821     // Mapping from owner to operator approvals
822     mapping(address => mapping(address => bool)) private _operatorApprovals;
823 
824     /**
825      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
826      */
827     constructor(string memory name_, string memory symbol_) {
828         _name = name_;
829         _symbol = symbol_;
830     }
831 
832     /**
833      * @dev See {IERC165-supportsInterface}.
834      */
835     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
836         return
837             interfaceId == type(IERC721).interfaceId ||
838             interfaceId == type(IERC721Metadata).interfaceId ||
839             super.supportsInterface(interfaceId);
840     }
841 
842     /**
843      * @dev See {IERC721-balanceOf}.
844      */
845     function balanceOf(address owner) public view virtual override returns (uint256) {
846         require(owner != address(0), "ERC721: balance query for the zero address");
847         return _balances[owner];
848     }
849 
850     /**
851      * @dev See {IERC721-ownerOf}.
852      */
853     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
854         address owner = _owners[tokenId];
855         require(owner != address(0), "ERC721: owner query for nonexistent token");
856         return owner;
857     }
858 
859     /**
860      * @dev See {IERC721Metadata-name}.
861      */
862     function name() public view virtual override returns (string memory) {
863         return _name;
864     }
865 
866     /**
867      * @dev See {IERC721Metadata-symbol}.
868      */
869     function symbol() public view virtual override returns (string memory) {
870         return _symbol;
871     }
872 
873     /**
874      * @dev See {IERC721Metadata-tokenURI}.
875      */
876     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
877         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
878 
879         string memory baseURI = _baseURI();
880         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
881     }
882 
883     /**
884      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
885      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
886      * by default, can be overriden in child contracts.
887      */
888     function _baseURI() internal view virtual returns (string memory) {
889         return "";
890     }
891 
892     /**
893      * @dev See {IERC721-approve}.
894      */
895     function approve(address to, uint256 tokenId) public virtual override {
896         address owner = ERC721.ownerOf(tokenId);
897         require(to != owner, "ERC721: approval to current owner");
898 
899         require(
900             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
901             "ERC721: approve caller is not owner nor approved for all"
902         );
903 
904         _approve(to, tokenId);
905     }
906 
907     /**
908      * @dev See {IERC721-getApproved}.
909      */
910     function getApproved(uint256 tokenId) public view virtual override returns (address) {
911         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
912 
913         return _tokenApprovals[tokenId];
914     }
915 
916     /**
917      * @dev See {IERC721-setApprovalForAll}.
918      */
919     function setApprovalForAll(address operator, bool approved) public virtual override {
920         _setApprovalForAll(_msgSender(), operator, approved);
921     }
922 
923     /**
924      * @dev See {IERC721-isApprovedForAll}.
925      */
926     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
927         return _operatorApprovals[owner][operator];
928     }
929 
930     /**
931      * @dev See {IERC721-transferFrom}.
932      */
933     function transferFrom(
934         address from,
935         address to,
936         uint256 tokenId
937     ) public virtual override {
938         //solhint-disable-next-line max-line-length
939         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
940 
941         _transfer(from, to, tokenId);
942     }
943 
944     /**
945      * @dev See {IERC721-safeTransferFrom}.
946      */
947     function safeTransferFrom(
948         address from,
949         address to,
950         uint256 tokenId
951     ) public virtual override {
952         safeTransferFrom(from, to, tokenId, "");
953     }
954 
955     /**
956      * @dev See {IERC721-safeTransferFrom}.
957      */
958     function safeTransferFrom(
959         address from,
960         address to,
961         uint256 tokenId,
962         bytes memory _data
963     ) public virtual override {
964         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
965         _safeTransfer(from, to, tokenId, _data);
966     }
967 
968     /**
969      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
970      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
971      *
972      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
973      *
974      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
975      * implement alternative mechanisms to perform token transfer, such as signature-based.
976      *
977      * Requirements:
978      *
979      * - `from` cannot be the zero address.
980      * - `to` cannot be the zero address.
981      * - `tokenId` token must exist and be owned by `from`.
982      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
983      *
984      * Emits a {Transfer} event.
985      */
986     function _safeTransfer(
987         address from,
988         address to,
989         uint256 tokenId,
990         bytes memory _data
991     ) internal virtual {
992         _transfer(from, to, tokenId);
993         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
994     }
995 
996     /**
997      * @dev Returns whether `tokenId` exists.
998      *
999      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1000      *
1001      * Tokens start existing when they are minted (`_mint`),
1002      * and stop existing when they are burned (`_burn`).
1003      */
1004     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1005         return _owners[tokenId] != address(0);
1006     }
1007 
1008     /**
1009      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1010      *
1011      * Requirements:
1012      *
1013      * - `tokenId` must exist.
1014      */
1015     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1016         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1017         address owner = ERC721.ownerOf(tokenId);
1018         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1019     }
1020 
1021     /**
1022      * @dev Safely mints `tokenId` and transfers it to `to`.
1023      *
1024      * Requirements:
1025      *
1026      * - `tokenId` must not exist.
1027      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1028      *
1029      * Emits a {Transfer} event.
1030      */
1031     function _safeMint(address to, uint256 tokenId) internal virtual {
1032         _safeMint(to, tokenId, "");
1033     }
1034 
1035     /**
1036      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1037      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1038      */
1039     function _safeMint(
1040         address to,
1041         uint256 tokenId,
1042         bytes memory _data
1043     ) internal virtual {
1044         _mint(to, tokenId);
1045         require(
1046             _checkOnERC721Received(address(0), to, tokenId, _data),
1047             "ERC721: transfer to non ERC721Receiver implementer"
1048         );
1049     }
1050 
1051     /**
1052      * @dev Mints `tokenId` and transfers it to `to`.
1053      *
1054      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1055      *
1056      * Requirements:
1057      *
1058      * - `tokenId` must not exist.
1059      * - `to` cannot be the zero address.
1060      *
1061      * Emits a {Transfer} event.
1062      */
1063     function _mint(address to, uint256 tokenId) internal virtual {
1064         require(to != address(0), "ERC721: mint to the zero address");
1065         require(!_exists(tokenId), "ERC721: token already minted");
1066 
1067         _beforeTokenTransfer(address(0), to, tokenId);
1068 
1069         _balances[to] += 1;
1070         _owners[tokenId] = to;
1071 
1072         emit Transfer(address(0), to, tokenId);
1073     }
1074 
1075     /**
1076      * @dev Destroys `tokenId`.
1077      * The approval is cleared when the token is burned.
1078      *
1079      * Requirements:
1080      *
1081      * - `tokenId` must exist.
1082      *
1083      * Emits a {Transfer} event.
1084      */
1085     function _burn(uint256 tokenId) internal virtual {
1086         address owner = ERC721.ownerOf(tokenId);
1087 
1088         _beforeTokenTransfer(owner, address(0), tokenId);
1089 
1090         // Clear approvals
1091         _approve(address(0), tokenId);
1092 
1093         _balances[owner] -= 1;
1094         delete _owners[tokenId];
1095 
1096         emit Transfer(owner, address(0), tokenId);
1097     }
1098 
1099     /**
1100      * @dev Transfers `tokenId` from `from` to `to`.
1101      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1102      *
1103      * Requirements:
1104      *
1105      * - `to` cannot be the zero address.
1106      * - `tokenId` token must be owned by `from`.
1107      *
1108      * Emits a {Transfer} event.
1109      */
1110     function _transfer(
1111         address from,
1112         address to,
1113         uint256 tokenId
1114     ) internal virtual {
1115         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1116         require(to != address(0), "ERC721: transfer to the zero address");
1117 
1118         _beforeTokenTransfer(from, to, tokenId);
1119 
1120         // Clear approvals from the previous owner
1121         _approve(address(0), tokenId);
1122 
1123         _balances[from] -= 1;
1124         _balances[to] += 1;
1125         _owners[tokenId] = to;
1126 
1127         emit Transfer(from, to, tokenId);
1128     }
1129 
1130     /**
1131      * @dev Approve `to` to operate on `tokenId`
1132      *
1133      * Emits a {Approval} event.
1134      */
1135     function _approve(address to, uint256 tokenId) internal virtual {
1136         _tokenApprovals[tokenId] = to;
1137         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1138     }
1139 
1140     /**
1141      * @dev Approve `operator` to operate on all of `owner` tokens
1142      *
1143      * Emits a {ApprovalForAll} event.
1144      */
1145     function _setApprovalForAll(
1146         address owner,
1147         address operator,
1148         bool approved
1149     ) internal virtual {
1150         require(owner != operator, "ERC721: approve to caller");
1151         _operatorApprovals[owner][operator] = approved;
1152         emit ApprovalForAll(owner, operator, approved);
1153     }
1154 
1155     /**
1156      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1157      * The call is not executed if the target address is not a contract.
1158      *
1159      * @param from address representing the previous owner of the given token ID
1160      * @param to target address that will receive the tokens
1161      * @param tokenId uint256 ID of the token to be transferred
1162      * @param _data bytes optional data to send along with the call
1163      * @return bool whether the call correctly returned the expected magic value
1164      */
1165     function _checkOnERC721Received(
1166         address from,
1167         address to,
1168         uint256 tokenId,
1169         bytes memory _data
1170     ) private returns (bool) {
1171         if (to.isContract()) {
1172             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1173                 return retval == IERC721Receiver.onERC721Received.selector;
1174             } catch (bytes memory reason) {
1175                 if (reason.length == 0) {
1176                     revert("ERC721: transfer to non ERC721Receiver implementer");
1177                 } else {
1178                     assembly {
1179                         revert(add(32, reason), mload(reason))
1180                     }
1181                 }
1182             }
1183         } else {
1184             return true;
1185         }
1186     }
1187 
1188     /**
1189      * @dev Hook that is called before any token transfer. This includes minting
1190      * and burning.
1191      *
1192      * Calling conditions:
1193      *
1194      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1195      * transferred to `to`.
1196      * - When `from` is zero, `tokenId` will be minted for `to`.
1197      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1198      * - `from` and `to` are never both zero.
1199      *
1200      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1201      */
1202     function _beforeTokenTransfer(
1203         address from,
1204         address to,
1205         uint256 tokenId
1206     ) internal virtual {}
1207 }
1208 
1209 
1210 pragma solidity >=0.7.0 <0.9.0;
1211 
1212 contract Boombaz is ERC721, Ownable {
1213   using Strings for uint256;
1214   using Counters for Counters.Counter;
1215 
1216   Counters.Counter private supply;
1217 
1218   string public uriPrefix = "";
1219   string public uriSuffix = ".json";
1220   string public hiddenMetadataUri;
1221   
1222   uint256 public cost = 0.038 ether;
1223   uint256 public maxSupply = 3600;
1224   uint256 public maxPreMintAmountPerTx = 3;
1225   uint256 public maxMintAmountPerTx = 5;
1226   uint256 public maxPrePerWallet = 3;
1227   uint256 public maxPerWallet = 5;
1228 
1229   bool public paused = true;
1230   bool public prepaused = true;
1231   bool public revealed = false;
1232   
1233   mapping(address => uint256) public mintsPerWallet;
1234   mapping(address => bool) public whitelisted;
1235 
1236   constructor() ERC721("Boombaz", "BOOMB") {
1237     setHiddenMetadataUri("https://www.boombaz.com/boombaz/hidden.json");
1238   }
1239 
1240   modifier mintCompliance(uint256 _mintAmount) {
1241     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1242     require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
1243     _;
1244   }
1245 
1246   modifier preMintCompliance(uint256 _preMintAmount) {
1247     require(_preMintAmount > 0 && _preMintAmount <= maxPreMintAmountPerTx, "Invalid mint amount!");
1248     require(supply.current() + _preMintAmount <= maxSupply, "Max supply exceeded!");
1249     _;
1250   }
1251 
1252   function totalSupply() public view returns (uint256) {
1253     return supply.current();
1254   }
1255 
1256   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1257     require(!paused, "The contract is paused!");
1258     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1259 
1260     uint256 walletCount = mintsPerWallet[_msgSender()];
1261     require(_mintAmount + walletCount <= maxPerWallet, "Exceeds max allowed per wallet!");
1262     mintsPerWallet[_msgSender()] = mintsPerWallet[_msgSender()] + _mintAmount;
1263 
1264     _mintLoop(msg.sender, _mintAmount);
1265   }
1266 
1267   function presaleMint(uint256 _preMintAmount) public payable preMintCompliance(_preMintAmount) {
1268     require(!prepaused, "The Presale is paused!");
1269     require(msg.value >= cost * _preMintAmount, "Insufficient funds!");
1270     require(whitelisted[msg.sender] == true, "You are not Whitelisted!");
1271 
1272     uint256 preWalletCount = mintsPerWallet[_msgSender()];
1273     require(_preMintAmount + preWalletCount <= maxPrePerWallet, "Exceeds max allowed in Presale per wallet!");
1274     mintsPerWallet[_msgSender()] = mintsPerWallet[_msgSender()] + _preMintAmount;
1275 
1276     _preMintLoop(msg.sender, _preMintAmount);
1277   }
1278   
1279   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1280     _mintLoop(_receiver, _mintAmount);
1281   }
1282 
1283   function walletOfOwner(address _owner)
1284     public
1285     view
1286     returns (uint256[] memory)
1287   {
1288     uint256 ownerTokenCount = balanceOf(_owner);
1289     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1290     uint256 currentTokenId = 1;
1291     uint256 ownedTokenIndex = 0;
1292 
1293     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1294       address currentTokenOwner = ownerOf(currentTokenId);
1295 
1296       if (currentTokenOwner == _owner) {
1297         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1298 
1299         ownedTokenIndex++;
1300       }
1301 
1302       currentTokenId++;
1303     }
1304 
1305     return ownedTokenIds;
1306   }
1307 
1308   function tokenURI(uint256 _tokenId)
1309     public
1310     view
1311     virtual
1312     override
1313     returns (string memory)
1314   {
1315     require(
1316       _exists(_tokenId),
1317       "ERC721Metadata: URI query for nonexistent token"
1318     );
1319 
1320     if (revealed == false) {
1321       return hiddenMetadataUri;
1322     }
1323 
1324     string memory currentBaseURI = _baseURI();
1325     return bytes(currentBaseURI).length > 0
1326         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1327         : "";
1328   }
1329 
1330   function setRevealed(bool _state) public onlyOwner {
1331     revealed = _state;
1332   }
1333 
1334   function setCost(uint256 _cost) public onlyOwner {
1335     cost = _cost;
1336   }
1337 
1338   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1339     maxMintAmountPerTx = _maxMintAmountPerTx;
1340   }
1341 
1342   function setMaxPreMintAmountPerTx(uint256 _maxPreMintAmountPerTx) public onlyOwner {
1343     maxPreMintAmountPerTx = _maxPreMintAmountPerTx;
1344   }
1345 
1346   function setMaxPerWallet(uint256 _maxValue) external onlyOwner {
1347     maxPerWallet = _maxValue;
1348   }
1349 
1350   function setMaxPrePerWallet(uint256 _maxPreValue) external onlyOwner {
1351     maxPrePerWallet = _maxPreValue;
1352   }
1353 
1354   function whitelistUser(address _user) public onlyOwner {
1355     whitelisted[_user] = true;
1356   }
1357 
1358   function removeWhitelistUser(address _user) public onlyOwner {
1359     whitelisted[_user] = false;
1360   }
1361 
1362   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1363     hiddenMetadataUri = _hiddenMetadataUri;
1364   }
1365 
1366   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1367     uriPrefix = _uriPrefix;
1368   }
1369 
1370   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1371     uriSuffix = _uriSuffix;
1372   }
1373 
1374   function setPaused(bool _state) public onlyOwner {
1375     paused = _state;
1376   }
1377 
1378   function setPrePaused(bool _state) public onlyOwner {
1379     prepaused = _state;
1380   }
1381 
1382   function withdraw() public onlyOwner {
1383     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1384     require(os);
1385   }
1386 
1387   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1388     for (uint256 i = 0; i < _mintAmount; i++) {
1389       supply.increment();
1390       _safeMint(_receiver, supply.current());
1391     }
1392   }
1393   function _preMintLoop(address _receiver, uint256 _preMintAmount) internal {
1394     for (uint256 i = 0; i < _preMintAmount; i++) {
1395       supply.increment();
1396       _safeMint(_receiver, supply.current());
1397     }
1398   }
1399 
1400   function _baseURI() internal view virtual override returns (string memory) {
1401     return uriPrefix;
1402   }
1403 }