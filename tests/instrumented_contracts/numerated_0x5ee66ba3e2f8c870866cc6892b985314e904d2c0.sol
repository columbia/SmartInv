1 // File: contracts/interfaces/IERC173.sol
2 
3 pragma solidity ^0.5.7;
4 
5 
6 /// @title ERC-173 Contract Ownership Standard
7 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-173.md
8 ///  Note: the ERC-165 identifier for this interface is 0x7f5828d0
9 contract IERC173 {
10     /// @dev This emits when ownership of a contract changes.
11     event OwnershipTransferred(address indexed _previousOwner, address indexed _newOwner);
12 
13     /// @notice Get the address of the owner
14     /// @return The address of the owner.
15     //// function owner() external view returns (address);
16 
17     /// @notice Set the address of the new owner of the contract
18     /// @param _newOwner The address of the new owner of the contract
19     function transferOwnership(address _newOwner) external;
20 }
21 
22 // File: contracts/commons/Ownable.sol
23 
24 pragma solidity ^0.5.7;
25 
26 
27 
28 contract Ownable is IERC173 {
29     address internal _owner;
30 
31     modifier onlyOwner() {
32         require(msg.sender == _owner, "The owner should be the sender");
33         _;
34     }
35 
36     constructor() public {
37         _owner = msg.sender;
38         emit OwnershipTransferred(address(0x0), msg.sender);
39     }
40 
41     function owner() external view returns (address) {
42         return _owner;
43     }
44 
45     /**
46         @dev Transfers the ownership of the contract.
47 
48         @param _newOwner Address of the new owner
49     */
50     function transferOwnership(address _newOwner) external onlyOwner {
51         require(_newOwner != address(0), "0x0 Is not a valid owner");
52         emit OwnershipTransferred(_owner, _newOwner);
53         _owner = _newOwner;
54     }
55 }
56 
57 // File: contracts/interfaces/IERC165.sol
58 
59 pragma solidity ^0.5.7;
60 
61 
62 interface IERC165 {
63     /// @notice Query if a contract implements an interface
64     /// @param interfaceID The interface identifier, as specified in ERC-165
65     /// @dev Interface identification is specified in ERC-165. This function
66     ///  uses less than 30,000 gas.
67     /// @return `true` if the contract implements `interfaceID` and
68     ///  `interfaceID` is not 0xffffffff, `false` otherwise
69     function supportsInterface(bytes4 interfaceID) external view returns (bool);
70 }
71 
72 // File: contracts/core/diaspore/interfaces/RateOracle.sol
73 
74 pragma solidity ^0.5.7;
75 
76 
77 
78 /**
79     @dev Defines the interface of a standard Diaspore RCN Oracle,
80 
81     The contract should also implement it's ERC165 interface: 0xa265d8e0
82 
83     @notice Each oracle can only support one currency
84 
85     @author Agustin Aguilar
86 */
87 contract RateOracle is IERC165 {
88     uint256 public constant VERSION = 5;
89     bytes4 internal constant RATE_ORACLE_INTERFACE = 0xa265d8e0;
90 
91     constructor() internal {}
92 
93     /**
94         3 or 4 letters symbol of the currency, Ej: ETH
95     */
96     function symbol() external view returns (string memory);
97 
98     /**
99         Descriptive name of the currency, Ej: Ethereum
100     */
101     function name() external view returns (string memory);
102 
103     /**
104         The number of decimals of the currency represented by this Oracle,
105             it should be the most common number of decimal places
106     */
107     function decimals() external view returns (uint256);
108 
109     /**
110         The base token on which the sample is returned
111             should be the RCN Token address.
112     */
113     function token() external view returns (address);
114 
115     /**
116         The currency symbol encoded on a UTF-8 Hex
117     */
118     function currency() external view returns (bytes32);
119 
120     /**
121         The name of the Individual or Company in charge of this Oracle
122     */
123     function maintainer() external view returns (string memory);
124 
125     /**
126         Returns the url where the oracle exposes a valid "oracleData" if needed
127     */
128     function url() external view returns (string memory);
129 
130     /**
131         Returns a sample on how many token() are equals to how many currency()
132     */
133     function readSample(bytes calldata _data) external returns (uint256 _tokens, uint256 _equivalent);
134 }
135 
136 // File: contracts/commons/ERC165.sol
137 
138 pragma solidity ^0.5.7;
139 
140 
141 
142 /**
143  * @title ERC165
144  * @author Matt Condon (@shrugs)
145  * @dev Implements ERC165 using a lookup table.
146  */
147 contract ERC165 is IERC165 {
148     bytes4 private constant _InterfaceId_ERC165 = 0x01ffc9a7;
149     /**
150     * 0x01ffc9a7 ===
151     *   bytes4(keccak256('supportsInterface(bytes4)'))
152     */
153 
154     /**
155     * @dev a mapping of interface id to whether or not it's supported
156     */
157     mapping(bytes4 => bool) private _supportedInterfaces;
158 
159     /**
160     * @dev A contract implementing SupportsInterfaceWithLookup
161     * implement ERC165 itself
162     */
163     constructor()
164         internal
165     {
166         _registerInterface(_InterfaceId_ERC165);
167     }
168 
169     /**
170     * @dev implement supportsInterface(bytes4) using a lookup table
171     */
172     function supportsInterface(bytes4 interfaceId)
173         external
174         view
175         returns (bool)
176     {
177         return _supportedInterfaces[interfaceId];
178     }
179 
180     /**
181     * @dev internal method for registering an interface
182     */
183     function _registerInterface(bytes4 interfaceId)
184         internal
185     {
186         require(interfaceId != 0xffffffff, "Can't register 0xffffffff");
187         _supportedInterfaces[interfaceId] = true;
188     }
189 }
190 
191 // File: contracts/core/basalt/utils/OwnableBasalt.sol
192 
193 pragma solidity ^0.5.7;
194 
195 
196 contract OwnableBasalt {
197     address public owner;
198 
199     modifier onlyOwner() {
200         require(msg.sender == owner, "The owner should be the sender");
201         _;
202     }
203 
204     constructor() public {
205         owner = msg.sender;
206     }
207 
208     /**
209         @dev Transfers the ownership of the contract.
210 
211         @param _to Address of the new owner
212     */
213     function transferTo(address _to) public onlyOwner returns (bool) {
214         require(_to != address(0), "0x0 Is not a valid owner");
215         owner = _to;
216         return true;
217     }
218 }
219 
220 // File: contracts/core/basalt/interfaces/Oracle.sol
221 
222 pragma solidity ^0.5.7;
223 
224 
225 
226 /**
227     @dev Defines the interface of a standard RCN oracle.
228 
229     The oracle is an agent in the RCN network that supplies a convertion rate between RCN and any other currency,
230     it's primarily used by the exchange but could be used by any other agent.
231 */
232 contract Oracle is OwnableBasalt {
233     uint256 public constant VERSION = 4;
234 
235     event NewSymbol(bytes32 _currency);
236 
237     mapping(bytes32 => bool) public supported;
238     bytes32[] public currencies;
239 
240     /**
241         @dev Returns the url where the oracle exposes a valid "oracleData" if needed
242     */
243     function url() public view returns (string memory);
244 
245     /**
246         @dev Returns a valid convertion rate from the currency given to RCN
247 
248         @param symbol Symbol of the currency
249         @param data Generic data field, could be used for off-chain signing
250     */
251     function getRate(bytes32 symbol, bytes memory data) public returns (uint256 rate, uint256 decimals);
252 
253     /**
254         @dev Adds a currency to the oracle, once added it cannot be removed
255 
256         @param ticker Symbol of the currency
257 
258         @return if the creation was done successfully
259     */
260     function addCurrency(string memory ticker) public onlyOwner returns (bool) {
261         bytes32 currency = encodeCurrency(ticker);
262         emit NewSymbol(currency);
263         supported[currency] = true;
264         currencies.push(currency);
265         return true;
266     }
267 
268     /**
269         @return the currency encoded as a bytes32
270     */
271     function encodeCurrency(string memory currency) public pure returns (bytes32 o) {
272         require(bytes(currency).length <= 32);
273         assembly {
274             o := mload(add(currency, 32))
275         }
276     }
277 
278     /**
279         @return the currency string from a encoded bytes32
280     */
281     function decodeCurrency(bytes32 b) public pure returns (string memory o) {
282         uint256 ns = 256;
283         while (true) {
284             if (ns == 0 || (b<<ns-8) != 0)
285                 break;
286             ns -= 8;
287         }
288         assembly {
289             ns := div(ns, 8)
290             o := mload(0x40)
291             mstore(0x40, add(o, and(add(add(ns, 0x20), 0x1f), not(0x1f))))
292             mstore(o, ns)
293             mstore(add(o, 32), b)
294         }
295     }
296 
297 }
298 
299 // File: contracts/core/diaspore/utils/OracleAdapter.sol
300 
301 pragma solidity ^0.5.7;
302 
303 
304 
305 
306 
307 contract OracleAdapter is Ownable, RateOracle, ERC165 {
308     Oracle public legacyOracle;
309 
310     string private isymbol;
311     string private iname;
312     string private imaintainer;
313 
314     uint256 private idecimals;
315     bytes32 private icurrency;
316 
317     address private itoken;
318 
319     constructor(
320         Oracle _legacyOracle,
321         string memory _symbol,
322         string memory _name,
323         string memory _maintainer,
324         uint256 _decimals,
325         bytes32 _currency,
326         address _token
327     ) public {
328         legacyOracle = _legacyOracle;
329         isymbol = _symbol;
330         iname = _name;
331         imaintainer = _maintainer;
332         idecimals = _decimals;
333         icurrency = _currency;
334         itoken = _token;
335 
336         _registerInterface(RATE_ORACLE_INTERFACE);
337     }
338 
339     function symbol() external view returns (string memory) { return isymbol; }
340 
341     function name() external view returns (string memory) { return iname; }
342 
343     function decimals() external view returns (uint256) { return idecimals; }
344 
345     function token() external view returns (address) { return itoken; }
346 
347     function currency() external view returns (bytes32) { return icurrency; }
348 
349     function maintainer() external view returns (string memory) { return imaintainer; }
350 
351     function url() external view returns (string memory) {
352         return legacyOracle.url();
353     }
354     
355     function setMaintainer(string calldata _maintainer) external onlyOwner {
356         imaintainer = _maintainer;
357     }
358     
359     function setName(string calldata _name) external onlyOwner {
360         iname = _name;
361     }
362     
363     function setLegacyOracle(Oracle _legacyOracle) external onlyOwner {
364         legacyOracle = _legacyOracle;
365     }
366 
367     function readSample(bytes calldata _data) external returns (uint256 _tokens, uint256 _equivalent) {
368         (_tokens, _equivalent) = legacyOracle.getRate(icurrency, _data);
369         _equivalent = 10 ** _equivalent;
370     }
371 }