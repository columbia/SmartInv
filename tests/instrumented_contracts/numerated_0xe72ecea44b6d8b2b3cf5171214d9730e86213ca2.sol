1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.5.0;
3 
4 
5 /**
6  * @dev Wrappers over Solidity's arithmetic operations with added overflow
7  * checks.
8  *
9  * Arithmetic operations in Solidity wrap on overflow. This can easily result
10  * in bugs, because programmers usually assume that an overflow raises an
11  * error, which is the standard behavior in high level programming languages.
12  * `SafeMath` restores this intuition by reverting the transaction when an
13  * operation overflows.
14  *
15  * Using this library instead of the unchecked operations eliminates an entire
16  * class of bugs, so it's recommended to use it always.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, reverting on
21      * overflow.
22      *
23      * Counterpart to Solidity's `+` operator.
24      *
25      * Requirements:
26      *
27      * - Addition cannot overflow.
28      */
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         require(c >= a, "SafeMath: addition overflow");
32 
33         return c;
34     }
35 
36     /**
37      * @dev Returns the subtraction of two unsigned integers, reverting on
38      * overflow (when the result is negative).
39      *
40      * Counterpart to Solidity's `-` operator.
41      *
42      * Requirements:
43      *
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
57      *
58      * - Subtraction cannot overflow.
59      */
60     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
61         require(b <= a, errorMessage);
62         uint256 c = a - b;
63 
64         return c;
65     }
66 
67     /**
68      * @dev Returns the multiplication of two unsigned integers, reverting on
69      * overflow.
70      *
71      * Counterpart to Solidity's `*` operator.
72      *
73      * Requirements:
74      *
75      * - Multiplication cannot overflow.
76      */
77     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
78         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
79         // benefit is lost if 'b' is also tested.
80         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
81         if (a == 0) {
82             return 0;
83         }
84 
85         uint256 c = a * b;
86         require(c / a == b, "SafeMath: multiplication overflow");
87 
88         return c;
89     }
90 
91     /**
92      * @dev Returns the integer division of two unsigned integers. Reverts on
93      * division by zero. The result is rounded towards zero.
94      *
95      * Counterpart to Solidity's `/` operator. Note: this function uses a
96      * `revert` opcode (which leaves remaining gas untouched) while Solidity
97      * uses an invalid opcode to revert (consuming all remaining gas).
98      *
99      * Requirements:
100      *
101      * - The divisor cannot be zero.
102      */
103     function div(uint256 a, uint256 b) internal pure returns (uint256) {
104         return div(a, b, "SafeMath: division by zero");
105     }
106 
107     /**
108      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
109      * division by zero. The result is rounded towards zero.
110      *
111      * Counterpart to Solidity's `/` operator. Note: this function uses a
112      * `revert` opcode (which leaves remaining gas untouched) while Solidity
113      * uses an invalid opcode to revert (consuming all remaining gas).
114      *
115      * Requirements:
116      *
117      * - The divisor cannot be zero.
118      */
119     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
120         require(b > 0, errorMessage);
121         uint256 c = a / b;
122         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
123 
124         return c;
125     }
126 
127     /**
128      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
129      * Reverts when dividing by zero.
130      *
131      * Counterpart to Solidity's `%` operator. This function uses a `revert`
132      * opcode (which leaves remaining gas untouched) while Solidity uses an
133      * invalid opcode to revert (consuming all remaining gas).
134      *
135      * Requirements:
136      *
137      * - The divisor cannot be zero.
138      */
139     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
140         return mod(a, b, "SafeMath: modulo by zero");
141     }
142 
143     /**
144      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
145      * Reverts with custom message when dividing by zero.
146      *
147      * Counterpart to Solidity's `%` operator. This function uses a `revert`
148      * opcode (which leaves remaining gas untouched) while Solidity uses an
149      * invalid opcode to revert (consuming all remaining gas).
150      *
151      * Requirements:
152      *
153      * - The divisor cannot be zero.
154      */
155     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
156         require(b != 0, errorMessage);
157         return a % b;
158     }
159 }
160 
161 /**
162  * @title Roles
163  * @dev Library for managing addresses assigned to a Role.
164  */
165 library Roles {
166     struct Role {
167         mapping (address => bool) bearer;
168     }
169 
170     /**
171      * @dev give an account access to this role
172      */
173     function add(Role storage role, address account) internal {
174         require(account != address(0));
175         require(!has(role, account));
176 
177         role.bearer[account] = true;
178     }
179 
180     /**
181      * @dev remove an account's access to this role
182      */
183     function remove(Role storage role, address account) internal {
184         require(account != address(0));
185         require(has(role, account));
186 
187         role.bearer[account] = false;
188     }
189 
190     /**
191      * @dev check if an account has this role
192      * @return bool
193      */
194     function has(Role storage role, address account) internal view returns (bool) {
195         require(account != address(0));
196         return role.bearer[account];
197     }
198 }
199 
200 /**
201  * @title ChainlinkConversionPath
202  *
203  * @notice ChainlinkConversionPath is a contract allowing to compute conversion rate from a Chainlink aggretators
204  */
205 interface ChainlinkConversionPath {
206 
207 
208   /**
209   * @notice Computes the rate from a list of conversion
210   * @param _path List of addresses representing the currencies for the conversions
211   * @return rate the rate
212   * @return oldestRateTimestamp he oldest timestamp of the path
213   * @return decimals of the conversion rate
214   */
215   function getRate(
216     address[] calldata _path
217   )
218     external
219     view
220     returns (uint256 rate, uint256 oldestRateTimestamp, uint256 decimals);
221 }
222 
223 interface IERC20FeeProxy {
224   event TransferWithReferenceAndFee(
225     address tokenAddress,
226     address to,
227     uint256 amount,
228     bytes indexed paymentReference,
229     uint256 feeAmount,
230     address feeAddress
231   );
232 
233   function transferFromWithReferenceAndFee(
234     address _tokenAddress,
235     address _to,
236     uint256 _amount,
237     bytes calldata _paymentReference,
238     uint256 _feeAmount,
239     address _feeAddress
240     ) external;
241 }
242 
243 
244 /**
245  * @title ERC20ConversionProxy
246  */
247 contract ERC20ConversionProxy {
248   using SafeMath for uint256;
249 
250   address public paymentProxy;
251   ChainlinkConversionPath public chainlinkConversionPath;
252 
253   constructor(address _paymentProxyAddress, address _chainlinkConversionPathAddress) public {
254     paymentProxy = _paymentProxyAddress;
255     chainlinkConversionPath = ChainlinkConversionPath(_chainlinkConversionPathAddress);
256   }
257 
258   // Event to declare a transfer with a reference
259   event TransferWithConversionAndReference(
260     uint256 amount,
261     address currency,
262     bytes indexed paymentReference,
263     uint256 feeAmount,
264     uint256 maxRateTimespan
265   );
266 
267   /**
268    * @notice Performs an ERC20 token transfer with a reference computing the amount based on a fiat amount
269    * @param _to Transfer recipient
270    * @param _requestAmount request amount
271    * @param _path conversion path
272    * @param _paymentReference Reference of the payment related
273    * @param _feeAmount The amount of the payment fee
274    * @param _feeAddress The fee recipient
275    * @param _maxToSpend amount max that we can spend on the behalf of the user
276    * @param _maxRateTimespan max time span with the oldestrate, ignored if zero
277    */
278   function transferFromWithReferenceAndFee(
279     address _to,
280     uint256 _requestAmount,
281     address[] calldata _path,
282     bytes calldata _paymentReference,
283     uint256 _feeAmount,
284     address _feeAddress,
285     uint256 _maxToSpend,
286     uint256 _maxRateTimespan
287   ) external
288   {
289     (uint256 amountToPay, uint256 amountToPayInFees) = getConversions(_path, _requestAmount, _feeAmount, _maxRateTimespan);
290 
291     require(amountToPay.add(amountToPayInFees) <= _maxToSpend, "Amount to pay is over the user limit");
292 
293     // Pay the request and fees
294     (bool status, ) = paymentProxy.delegatecall(
295       abi.encodeWithSignature(
296         "transferFromWithReferenceAndFee(address,address,uint256,bytes,uint256,address)",
297         // payment currency
298         _path[_path.length - 1],
299         _to,
300         amountToPay,
301         _paymentReference,
302         amountToPayInFees,
303         _feeAddress
304       )
305     );
306     require(status, "transferFromWithReferenceAndFee failed");
307 
308     // Event to declare a transfer with a reference
309     emit TransferWithConversionAndReference(
310       _requestAmount,
311       // request currency
312       _path[0],
313       _paymentReference,
314       _feeAmount,
315       _maxRateTimespan
316     );
317   }
318 
319   function getConversions(
320     address[] memory _path,
321     uint256 _requestAmount,
322     uint256 _feeAmount,
323     uint256 _maxRateTimespan
324   ) internal
325     view
326     returns (uint256 amountToPay, uint256 amountToPayInFees)
327   {
328     (uint256 rate, uint256 oldestTimestampRate, uint256 decimals) = chainlinkConversionPath.getRate(_path);
329 
330     // Check rate timespan
331     require(_maxRateTimespan == 0 || block.timestamp.sub(oldestTimestampRate) <= _maxRateTimespan, "aggregator rate is outdated");
332     
333     // Get the amount to pay in the crypto currency chosen
334     amountToPay = _requestAmount.mul(rate).div(decimals);
335     amountToPayInFees = _feeAmount.mul(rate).div(decimals);
336   }
337 }