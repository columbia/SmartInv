1 // File: @openzeppelin/contracts/math/SafeMath.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.6.0;
6 
7 /**
8  * @dev Wrappers over Solidity's arithmetic operations with added overflow
9  * checks.
10  *
11  * Arithmetic operations in Solidity wrap on overflow. This can easily result
12  * in bugs, because programmers usually assume that an overflow raises an
13  * error, which is the standard behavior in high level programming languages.
14  * `SafeMath` restores this intuition by reverting the transaction when an
15  * operation overflows.
16  *
17  * Using this library instead of the unchecked operations eliminates an entire
18  * class of bugs, so it's recommended to use it always.
19  */
20 library SafeMath {
21     /**
22      * @dev Returns the addition of two unsigned integers, reverting on
23      * overflow.
24      *
25      * Counterpart to Solidity's `+` operator.
26      *
27      * Requirements:
28      * - Addition cannot overflow.
29      */
30     function add(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a + b;
32         require(c >= a, "SafeMath: addition overflow");
33 
34         return c;
35     }
36 
37     /**
38      * @dev Returns the subtraction of two unsigned integers, reverting on
39      * overflow (when the result is negative).
40      *
41      * Counterpart to Solidity's `-` operator.
42      *
43      * Requirements:
44      * - Subtraction cannot overflow.
45      */
46     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47         return sub(a, b, "SafeMath: subtraction overflow");
48     }
49 
50     /**
51      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
52      * overflow (when the result is negative).
53      *
54      * Counterpart to Solidity's `-` operator.
55      *
56      * Requirements:
57      * - Subtraction cannot overflow.
58      */
59     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
60         require(b <= a, errorMessage);
61         uint256 c = a - b;
62 
63         return c;
64     }
65 
66     /**
67      * @dev Returns the multiplication of two unsigned integers, reverting on
68      * overflow.
69      *
70      * Counterpart to Solidity's `*` operator.
71      *
72      * Requirements:
73      * - Multiplication cannot overflow.
74      */
75     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
76         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
77         // benefit is lost if 'b' is also tested.
78         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
79         if (a == 0) {
80             return 0;
81         }
82 
83         uint256 c = a * b;
84         require(c / a == b, "SafeMath: multiplication overflow");
85 
86         return c;
87     }
88 
89     /**
90      * @dev Returns the integer division of two unsigned integers. Reverts on
91      * division by zero. The result is rounded towards zero.
92      *
93      * Counterpart to Solidity's `/` operator. Note: this function uses a
94      * `revert` opcode (which leaves remaining gas untouched) while Solidity
95      * uses an invalid opcode to revert (consuming all remaining gas).
96      *
97      * Requirements:
98      * - The divisor cannot be zero.
99      */
100     function div(uint256 a, uint256 b) internal pure returns (uint256) {
101         return div(a, b, "SafeMath: division by zero");
102     }
103 
104     /**
105      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
106      * division by zero. The result is rounded towards zero.
107      *
108      * Counterpart to Solidity's `/` operator. Note: this function uses a
109      * `revert` opcode (which leaves remaining gas untouched) while Solidity
110      * uses an invalid opcode to revert (consuming all remaining gas).
111      *
112      * Requirements:
113      * - The divisor cannot be zero.
114      */
115     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
116         // Solidity only automatically asserts when dividing by 0
117         require(b > 0, errorMessage);
118         uint256 c = a / b;
119         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
120 
121         return c;
122     }
123 
124     /**
125      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
126      * Reverts when dividing by zero.
127      *
128      * Counterpart to Solidity's `%` operator. This function uses a `revert`
129      * opcode (which leaves remaining gas untouched) while Solidity uses an
130      * invalid opcode to revert (consuming all remaining gas).
131      *
132      * Requirements:
133      * - The divisor cannot be zero.
134      */
135     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
136         return mod(a, b, "SafeMath: modulo by zero");
137     }
138 
139     /**
140      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
141      * Reverts with custom message when dividing by zero.
142      *
143      * Counterpart to Solidity's `%` operator. This function uses a `revert`
144      * opcode (which leaves remaining gas untouched) while Solidity uses an
145      * invalid opcode to revert (consuming all remaining gas).
146      *
147      * Requirements:
148      * - The divisor cannot be zero.
149      */
150     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
151         require(b != 0, errorMessage);
152         return a % b;
153     }
154 }
155 
156 // File: @openzeppelin/contracts/GSN/Context.sol
157 
158 // SPDX-License-Identifier: MIT
159 
160 pragma solidity ^0.6.0;
161 
162 /*
163  * @dev Provides information about the current execution context, including the
164  * sender of the transaction and its data. While these are generally available
165  * via msg.sender and msg.data, they should not be accessed in such a direct
166  * manner, since when dealing with GSN meta-transactions the account sending and
167  * paying for execution may not be the actual sender (as far as an application
168  * is concerned).
169  *
170  * This contract is only required for intermediate, library-like contracts.
171  */
172 contract Context {
173     // Empty internal constructor, to prevent people from mistakenly deploying
174     // an instance of this contract, which should be used via inheritance.
175     constructor () internal { }
176 
177     function _msgSender() internal view virtual returns (address payable) {
178         return msg.sender;
179     }
180 
181     function _msgData() internal view virtual returns (bytes memory) {
182         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
183         return msg.data;
184     }
185 }
186 
187 // File: @openzeppelin/contracts/access/Ownable.sol
188 
189 // SPDX-License-Identifier: MIT
190 
191 pragma solidity ^0.6.0;
192 
193 /**
194  * @dev Contract module which provides a basic access control mechanism, where
195  * there is an account (an owner) that can be granted exclusive access to
196  * specific functions.
197  *
198  * By default, the owner account will be the one that deploys the contract. This
199  * can later be changed with {transferOwnership}.
200  *
201  * This module is used through inheritance. It will make available the modifier
202  * `onlyOwner`, which can be applied to your functions to restrict their use to
203  * the owner.
204  */
205 contract Ownable is Context {
206     address private _owner;
207 
208     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
209 
210     /**
211      * @dev Initializes the contract setting the deployer as the initial owner.
212      */
213     constructor () internal {
214         address msgSender = _msgSender();
215         _owner = msgSender;
216         emit OwnershipTransferred(address(0), msgSender);
217     }
218 
219     /**
220      * @dev Returns the address of the current owner.
221      */
222     function owner() public view returns (address) {
223         return _owner;
224     }
225 
226     /**
227      * @dev Throws if called by any account other than the owner.
228      */
229     modifier onlyOwner() {
230         require(_owner == _msgSender(), "Ownable: caller is not the owner");
231         _;
232     }
233 
234     /**
235      * @dev Leaves the contract without owner. It will not be possible to call
236      * `onlyOwner` functions anymore. Can only be called by the current owner.
237      *
238      * NOTE: Renouncing ownership will leave the contract without an owner,
239      * thereby removing any functionality that is only available to the owner.
240      */
241     function renounceOwnership() public virtual onlyOwner {
242         emit OwnershipTransferred(_owner, address(0));
243         _owner = address(0);
244     }
245 
246     /**
247      * @dev Transfers ownership of the contract to a new account (`newOwner`).
248      * Can only be called by the current owner.
249      */
250     function transferOwnership(address newOwner) public virtual onlyOwner {
251         require(newOwner != address(0), "Ownable: new owner is the zero address");
252         emit OwnershipTransferred(_owner, newOwner);
253         _owner = newOwner;
254     }
255 }
256 
257 // File: contracts/interfaces/PriceOracleInterface.sol
258 
259 pragma solidity 0.6.6;
260 
261 /**
262  * @dev Interface of the price oracle.
263  */
264 interface PriceOracleInterface {
265     /**
266      * @dev Returns `true`if oracle is working.
267      */
268     function isWorking() external returns (bool);
269 
270     /**
271      * @dev Returns the latest id. The id start from 1 and increments by 1.
272      */
273     function latestId() external returns (uint256);
274 
275     /**
276      * @dev Returns the last updated price. Decimals is 8.
277      **/
278     function latestPrice() external returns (uint256);
279 
280     /**
281      * @dev Returns the timestamp of the last updated price.
282      */
283     function latestTimestamp() external returns (uint256);
284 
285     /**
286      * @dev Returns the historical price specified by `id`. Decimals is 8.
287      */
288     function getPrice(uint256 id) external returns (uint256);
289 
290     /**
291      * @dev Returns the timestamp of historical price specified by `id`.
292      */
293     function getTimestamp(uint256 id) external returns (uint256);
294 }
295 
296 // File: contracts/TrustedPriceOracle.sol
297 
298 pragma solidity 0.6.6;
299 
300 
301 
302 
303 /**
304  * @notice Sub oracle for Recovery phase.
305  * If and only if in an emergent situation, users need to trust the owner of the contract.
306  *
307  * CAUTION: NEVER use this contract as a price oracle.
308  * @dev Only owner can update the price.
309  */
310 contract TrustedPriceOracle is Ownable, PriceOracleInterface {
311     using SafeMath for uint256;
312 
313     uint256 private constant SECONDS_IN_DAY = 60 * 60 * 24;
314     // The first id is 1.
315     uint256 private _latestId;
316 
317     struct Record {
318         uint128 price;
319         uint128 timestamp;
320     }
321 
322     // id => record.
323     mapping(uint256 => Record) private records;
324 
325     event PriceRegistered(
326         uint256 indexed id,
327         uint128 timestamp,
328         uint128 price
329     );
330 
331     /**
332      * @dev Checks if `id` is larger than 0, and equals to or smaller than latestId.
333      */
334     modifier validId(uint256 id) {
335         require(id != 0 && id <= _latestId, "invalid id");
336         _;
337     }
338 
339     /**
340      * @dev Checks if any records are registered.
341      */
342     modifier hasRecord() {
343         require(_latestId != 0, "no records found");
344         _;
345     }
346 
347     /**
348      * @notice Registers `price` as the value on the timestamp in the block.
349      * @param price Decimals of this value must be 8.
350      * For example, if real price is `1.05`, param value is `105000000`.
351      */
352     function registerPrice(uint128 price) external onlyOwner {
353         uint256 latestId = _latestId;
354         require(
355             now > records[latestId].timestamp,
356             "multiple registration in one block"
357         );
358         require(price != 0, "0 is invalid as price");
359         uint256 newId = latestId + 1;
360         uint128 timestamp = uint128(now);
361         _latestId = newId;
362         records[newId] = Record(price, timestamp);
363         emit PriceRegistered(newId, timestamp, price);
364     }
365 
366     // Implementation of price oracle interface
367 
368     /**
369      * @notice Returns `true` if the price was updated correctly within last 24 hours.
370      */
371     function isWorking() external override returns (bool) {
372         return now.sub(_latestTimestamp()) < SECONDS_IN_DAY;
373     }
374 
375     /**
376      * @dev See {PriceOracleInterface-latestId}.
377      */
378     function latestId() external override hasRecord returns (uint256) {
379         return _latestId;
380     }
381 
382     /**
383      * @dev See {PriceOracleInterface-latestPrice}.
384      */
385     function latestPrice() external override hasRecord returns (uint256) {
386         return records[_latestId].price;
387     }
388 
389     /**
390      * @dev See {PriceOracleInterface-latestTimestamp}.
391      */
392     function latestTimestamp() external override returns (uint256) {
393         return _latestTimestamp();
394     }
395 
396     /**
397      * @dev See {PriceOracleInterface-getPrice}.
398      */
399     function getPrice(uint256 id)
400         external
401         override
402         validId(id)
403         returns (uint256)
404     {
405         return records[id].price;
406     }
407 
408     /**
409      * @dev See {PriceOracleInterface-getTimestamp}.
410      */
411     function getTimestamp(uint256 id)
412         external
413         override
414         validId(id)
415         returns (uint256)
416     {
417         return records[id].timestamp;
418     }
419 
420     function _latestTimestamp() private view hasRecord returns (uint256) {
421         return records[_latestId].timestamp;
422     }
423 }