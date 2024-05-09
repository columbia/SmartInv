1 // File: contracts/IFeed.sol
2 
3 pragma solidity ^0.4.18;
4 
5 interface IFeed {
6     function get(address base, address quote) external view returns (uint128 xrt, uint64 when);
7 }
8 
9 // File: contracts/open-zeppelin/ECRecovery.sol
10 
11 pragma solidity 0.4.24;
12 
13 // Using ECRecovery from open-zeppelin@ad12381549c4c0711c2f3310e9fb1f65d51c299c + added personalRecover function
14 // See https://github.com/OpenZeppelin/openzeppelin-solidity/blob/ad12381549c4c0711c2f3310e9fb1f65d51c299c/contracts/ECRecovery.sol
15 
16 library ECRecovery {
17   /**
18    * @dev Recover signer address from a personal signed message by using his signature
19    * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
20    * @param sig bytes signature, the signature is generated using web3.personal.sign()
21    */
22   function personalRecover(bytes32 hash, bytes sig) internal pure returns (address) {
23     return recover(toEthSignedMessageHash(hash), sig);
24   }
25 
26   /**
27    * @dev Recover signer address from a message by using his signature
28    * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
29    * @param sig bytes signature, the signature is generated using web3.eth.sign()
30    */
31   function recover(bytes32 hash, bytes sig) internal pure returns (address) {
32     bytes32 r;
33     bytes32 s;
34     uint8 v;
35 
36     //Check the signature length
37     if (sig.length != 65) {
38       return (address(0));
39     }
40 
41     // Divide the signature in r, s and v variables
42     assembly {
43       r := mload(add(sig, 32))
44       s := mload(add(sig, 64))
45       v := byte(0, mload(add(sig, 96)))
46     }
47 
48     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
49     if (v < 27) {
50       v += 27;
51     }
52 
53     // If the version is correct return the signer address
54     if (v != 27 && v != 28) {
55       return (address(0));
56     } else {
57       return ecrecover(hash, v, r, s);
58     }
59   }
60 
61   /**
62    * toEthSignedMessageHash
63    * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
64    * @dev and hash the result
65    */
66   function toEthSignedMessageHash(bytes32 hash)
67     internal
68     pure
69     returns (bytes32)
70   {
71     // 32 is the length in bytes of hash,
72     // enforced by the type signature above
73     return keccak256(abi.encodePacked(
74       "\x19Ethereum Signed Message:\n32",
75       hash
76     ));
77   }
78 }
79 
80 // File: @aragon/os/contracts/common/Uint256Helpers.sol
81 
82 pragma solidity ^0.4.24;
83 
84 
85 library Uint256Helpers {
86     uint256 private constant MAX_UINT64 = uint64(-1);
87 
88     string private constant ERROR_NUMBER_TOO_BIG = "UINT64_NUMBER_TOO_BIG";
89 
90     function toUint64(uint256 a) internal pure returns (uint64) {
91         require(a <= MAX_UINT64, ERROR_NUMBER_TOO_BIG);
92         return uint64(a);
93     }
94 }
95 
96 // File: @aragon/os/contracts/common/TimeHelpers.sol
97 
98 /*
99  * SPDX-License-Identitifer:    MIT
100  */
101 
102 pragma solidity ^0.4.24;
103 
104 
105 
106 contract TimeHelpers {
107     using Uint256Helpers for uint256;
108 
109     /**
110     * @dev Returns the current block number.
111     *      Using a function rather than `block.number` allows us to easily mock the block number in
112     *      tests.
113     */
114     function getBlockNumber() internal view returns (uint256) {
115         return block.number;
116     }
117 
118     /**
119     * @dev Returns the current block number, converted to uint64.
120     *      Using a function rather than `block.number` allows us to easily mock the block number in
121     *      tests.
122     */
123     function getBlockNumber64() internal view returns (uint64) {
124         return getBlockNumber().toUint64();
125     }
126 
127     /**
128     * @dev Returns the current timestamp.
129     *      Using a function rather than `block.timestamp` allows us to easily mock it in
130     *      tests.
131     */
132     function getTimestamp() internal view returns (uint256) {
133         return block.timestamp; // solium-disable-line security/no-block-members
134     }
135 
136     /**
137     * @dev Returns the current timestamp, converted to uint64.
138     *      Using a function rather than `block.timestamp` allows us to easily mock it in
139     *      tests.
140     */
141     function getTimestamp64() internal view returns (uint64) {
142         return getTimestamp().toUint64();
143     }
144 }
145 
146 // File: contracts/PPF.sol
147 
148 pragma solidity 0.4.24;
149 
150 
151 
152 
153 
154 contract PPF is IFeed, TimeHelpers {
155     using ECRecovery for bytes32;
156 
157     uint256 constant public ONE = 10 ** 18; // 10^18 is considered 1 in the price feed to allow for decimal calculations
158     bytes32 constant public PPF_v1_ID = 0x33a8ba7202230fa1cee2aac7bac322939edc7ba0a48b0989335a5f87a5770369; // keccak256("PPF-v1");
159 
160     string private constant ERROR_BAD_SIGNATURE = "PPF_BAD_SIGNATURE";
161     string private constant ERROR_BAD_RATE_TIMESTAMP = "PPF_BAD_RATE_TIMESTAMP";
162     string private constant ERROR_INVALID_RATE_VALUE = "PPF_INVALID_RATE_VALUE";
163     string private constant ERROR_EQUAL_BASE_QUOTE_ADDRESSES = "PPF_EQUAL_BASE_QUOTE_ADDRESSES";
164     string private constant ERROR_BASE_ADDRESSES_LENGTH_ZERO = "PPF_BASE_ADDRESSES_LEN_ZERO";
165     string private constant ERROR_QUOTE_ADDRESSES_LENGTH_MISMATCH = "PPF_QUOTE_ADDRESSES_LEN_MISMATCH";
166     string private constant ERROR_RATE_VALUES_LENGTH_MISMATCH = "PPF_RATE_VALUES_LEN_MISMATCH";
167     string private constant ERROR_RATE_TIMESTAMPS_LENGTH_MISMATCH = "PPF_RATE_TIMESTAMPS_LEN_MISMATCH";
168     string private constant ERROR_SIGNATURES_LENGTH_MISMATCH = "PPF_SIGNATURES_LEN_MISMATCH";
169     string private constant ERROR_CAN_NOT_SET_OPERATOR = "PPF_CAN_NOT_SET_OPERATOR";
170     string private constant ERROR_CAN_NOT_SET_OPERATOR_OWNER = "PPF_CAN_NOT_SET_OPERATOR_OWNER";
171     string private constant ERROR_OPERATOR_ADDRESS_ZERO = "PPF_OPERATOR_ADDRESS_ZERO";
172     string private constant ERROR_OPERATOR_OWNER_ADDRESS_ZERO = "PPF_OPERATOR_OWNER_ADDRESS_ZERO";
173 
174     struct Price {
175         uint128 xrt;
176         uint64 when;
177     }
178 
179     mapping (bytes32 => Price) internal feed;
180     address public operator;
181     address public operatorOwner;
182 
183     event SetRate(address indexed base, address indexed quote, uint256 xrt, uint64 when);
184     event SetOperator(address indexed operator);
185     event SetOperatorOwner(address indexed operatorOwner);
186 
187     /**
188     * @param _operator Public key allowed to sign messages to update the pricefeed
189     * @param _operatorOwner Address of an account that can change the operator
190     */
191     constructor (address _operator, address _operatorOwner) public {
192         _setOperator(_operator);
193         _setOperatorOwner(_operatorOwner);
194     }
195 
196     /**
197     * @notice Update the price for the `base + ':' + quote` feed with an exchange rate of `xrt / ONE` for time `when`
198     * @dev If the number representation of base is lower than the one for quote, and update is cheaper, as less manipulation is required.
199     * @param base Address for the base token in the feed
200     * @param quote Address for the quote token the base is denominated in
201     * @param xrt Exchange rate for base denominated in quote. 10^18 is considered 1 to allow for decimal calculations
202     * @param when Timestamp for the exchange rate value
203     * @param sig Signature payload (EIP191) from operator, concatenated [  r  ][  s  ][v]. See setHash function for the hash calculation.
204     */
205     function update(address base, address quote, uint128 xrt, uint64 when, bytes sig) public {
206         bytes32 pair = pairId(base, quote);
207 
208         // Ensure it is more recent than the current value (implicit check for > 0) and not a future date
209         require(when > feed[pair].when && when <= getTimestamp(), ERROR_BAD_RATE_TIMESTAMP);
210         require(xrt > 0, ERROR_INVALID_RATE_VALUE); // Make sure xrt is not 0, as the math would break (Dividing by 0 sucks big time)
211         require(base != quote, ERROR_EQUAL_BASE_QUOTE_ADDRESSES); // Assumption that currency units are fungible and xrt should always be 1
212 
213         bytes32 h = setHash(base, quote, xrt, when);
214         require(h.personalRecover(sig) == operator, ERROR_BAD_SIGNATURE); // Make sure the update was signed by the operator
215 
216         feed[pair] = Price(pairXRT(base, quote, xrt), when);
217 
218         emit SetRate(base, quote, xrt, when);
219     }
220 
221     /**
222     * @notice Update the price for many pairs
223     * @dev If the number representation of bases is lower than the one for quotes, and update is cheaper, as less manipulation is required.
224     * @param bases Array of addresses for the base tokens in the feed
225     * @param quotes Array of addresses for the quote tokens bases are denominated in
226     * @param xrts Array of the exchange rates for bases denominated in quotes. 10^18 is considered 1 to allow for decimal calculations
227     * @param whens Array of timestamps for the exchange rate value
228     * @param sigs Bytes array with the ordered concatenated signatures for the updates
229     */
230     function updateMany(address[] bases, address[] quotes, uint128[] xrts, uint64[] whens, bytes sigs) public {
231         require(bases.length != 0, ERROR_BASE_ADDRESSES_LENGTH_ZERO);
232         require(bases.length == quotes.length, ERROR_QUOTE_ADDRESSES_LENGTH_MISMATCH);
233         require(bases.length == xrts.length, ERROR_RATE_VALUES_LENGTH_MISMATCH);
234         require(bases.length == whens.length, ERROR_RATE_TIMESTAMPS_LENGTH_MISMATCH);
235         require(bases.length == sigs.length / 65, ERROR_SIGNATURES_LENGTH_MISMATCH);
236         require(sigs.length % 65 == 0, ERROR_SIGNATURES_LENGTH_MISMATCH);
237 
238         for (uint256 i = 0; i < bases.length; i++) {
239             // Extract the signature for the update from the concatenated sigs
240             bytes memory sig = new bytes(65);
241             uint256 needle = 32 + 65 * i; // where to start copying from sigs
242             assembly {
243                 // copy 32 bytes at a time and just the last byte at the end
244                 mstore(add(sig, 0x20), mload(add(sigs, needle)))
245                 mstore(add(sig, 0x40), mload(add(sigs, add(needle, 0x20))))
246                 // we have to mload the last 32 bytes of the sig, and mstore8 just gets the LSB for the word
247                 mstore8(add(sig, 0x60), mload(add(sigs, add(needle, 0x21))))
248             }
249 
250             update(bases[i], quotes[i], xrts[i], whens[i], sig);
251         }
252     }
253 
254     /**
255     * @param base Address for the base token in the feed
256     * @param quote Address for the quote token the base is denominated in
257     * @return XRT for base:quote and the timestamp when it was updated
258     */
259     function get(address base, address quote) public view returns (uint128, uint64) {
260         if (base == quote) {
261             return (uint128(ONE), getTimestamp64());
262         }
263 
264         Price storage price = feed[pairId(base, quote)];
265 
266         // if never set, return 0.
267         if (price.when == 0) {
268             return (0, 0);
269         }
270 
271         return (pairXRT(base, quote, price.xrt), price.when);
272     }
273 
274     /**
275     * @notice Set operator public key to `_operator`
276     * @param _operator Public key allowed to sign messages to update the pricefeed
277     */
278     function setOperator(address _operator) external {
279         // Allow the current operator to change the operator to avoid having to hassle the
280         // operatorOwner in cases where a node just wants to rotate its public key
281         require(msg.sender == operator || msg.sender == operatorOwner, ERROR_CAN_NOT_SET_OPERATOR);
282         _setOperator(_operator);
283     }
284 
285     /**
286     * @notice Set operator owner to `_operatorOwner`
287     * @param _operatorOwner Address of an account that can change the operator
288     */
289     function setOperatorOwner(address _operatorOwner) external {
290         require(msg.sender == operatorOwner, ERROR_CAN_NOT_SET_OPERATOR_OWNER);
291         _setOperatorOwner(_operatorOwner);
292     }
293 
294     function _setOperator(address _operator) internal {
295         require(_operator != address(0), ERROR_OPERATOR_ADDRESS_ZERO);
296         operator = _operator;
297         emit SetOperator(_operator);
298     }
299 
300     function _setOperatorOwner(address _operatorOwner) internal {
301         require(_operatorOwner != address(0), ERROR_OPERATOR_OWNER_ADDRESS_ZERO);
302         operatorOwner = _operatorOwner;
303         emit SetOperatorOwner(_operatorOwner);
304     }
305 
306     /**
307     * @dev pairId returns a unique id for each pair, regardless of the order of base and quote
308     */
309     function pairId(address base, address quote) internal pure returns (bytes32) {
310         bool pairOrdered = isPairOrdered(base, quote);
311         address orderedBase = pairOrdered ? base : quote;
312         address orderedQuote = pairOrdered ? quote : base;
313 
314         return keccak256(abi.encodePacked(orderedBase, orderedQuote));
315     }
316 
317     /**
318     * @dev Compute xrt depending on base and quote order.
319     */
320     function pairXRT(address base, address quote, uint128 xrt) internal pure returns (uint128) {
321         bool pairOrdered = isPairOrdered(base, quote);
322 
323         return pairOrdered ? xrt : uint128((ONE**2 / uint256(xrt))); // If pair is not ordered, return the inverse
324     }
325 
326     function setHash(address base, address quote, uint128 xrt, uint64 when) internal pure returns (bytes32) {
327         return keccak256(abi.encodePacked(PPF_v1_ID, base, quote, xrt, when));
328     }
329 
330     function isPairOrdered(address base, address quote) private pure returns (bool) {
331         return base < quote;
332     }
333 }