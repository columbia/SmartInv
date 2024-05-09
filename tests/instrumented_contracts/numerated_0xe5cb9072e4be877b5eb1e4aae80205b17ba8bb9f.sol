1 // File: @openzeppelin/contracts/math/SafeMath.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity >=0.6.0 <0.8.0;
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
28      *
29      * - Addition cannot overflow.
30      */
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         require(c >= a, "SafeMath: addition overflow");
34 
35         return c;
36     }
37 
38     /**
39      * @dev Returns the subtraction of two unsigned integers, reverting on
40      * overflow (when the result is negative).
41      *
42      * Counterpart to Solidity's `-` operator.
43      *
44      * Requirements:
45      *
46      * - Subtraction cannot overflow.
47      */
48     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49         return sub(a, b, "SafeMath: subtraction overflow");
50     }
51 
52     /**
53      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
54      * overflow (when the result is negative).
55      *
56      * Counterpart to Solidity's `-` operator.
57      *
58      * Requirements:
59      *
60      * - Subtraction cannot overflow.
61      */
62     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
63         require(b <= a, errorMessage);
64         uint256 c = a - b;
65 
66         return c;
67     }
68 
69     /**
70      * @dev Returns the multiplication of two unsigned integers, reverting on
71      * overflow.
72      *
73      * Counterpart to Solidity's `*` operator.
74      *
75      * Requirements:
76      *
77      * - Multiplication cannot overflow.
78      */
79     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
80         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
81         // benefit is lost if 'b' is also tested.
82         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
83         if (a == 0) {
84             return 0;
85         }
86 
87         uint256 c = a * b;
88         require(c / a == b, "SafeMath: multiplication overflow");
89 
90         return c;
91     }
92 
93     /**
94      * @dev Returns the integer division of two unsigned integers. Reverts on
95      * division by zero. The result is rounded towards zero.
96      *
97      * Counterpart to Solidity's `/` operator. Note: this function uses a
98      * `revert` opcode (which leaves remaining gas untouched) while Solidity
99      * uses an invalid opcode to revert (consuming all remaining gas).
100      *
101      * Requirements:
102      *
103      * - The divisor cannot be zero.
104      */
105     function div(uint256 a, uint256 b) internal pure returns (uint256) {
106         return div(a, b, "SafeMath: division by zero");
107     }
108 
109     /**
110      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
111      * division by zero. The result is rounded towards zero.
112      *
113      * Counterpart to Solidity's `/` operator. Note: this function uses a
114      * `revert` opcode (which leaves remaining gas untouched) while Solidity
115      * uses an invalid opcode to revert (consuming all remaining gas).
116      *
117      * Requirements:
118      *
119      * - The divisor cannot be zero.
120      */
121     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
122         require(b > 0, errorMessage);
123         uint256 c = a / b;
124         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
125 
126         return c;
127     }
128 
129     /**
130      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
131      * Reverts when dividing by zero.
132      *
133      * Counterpart to Solidity's `%` operator. This function uses a `revert`
134      * opcode (which leaves remaining gas untouched) while Solidity uses an
135      * invalid opcode to revert (consuming all remaining gas).
136      *
137      * Requirements:
138      *
139      * - The divisor cannot be zero.
140      */
141     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
142         return mod(a, b, "SafeMath: modulo by zero");
143     }
144 
145     /**
146      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
147      * Reverts with custom message when dividing by zero.
148      *
149      * Counterpart to Solidity's `%` operator. This function uses a `revert`
150      * opcode (which leaves remaining gas untouched) while Solidity uses an
151      * invalid opcode to revert (consuming all remaining gas).
152      *
153      * Requirements:
154      *
155      * - The divisor cannot be zero.
156      */
157     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
158         require(b != 0, errorMessage);
159         return a % b;
160     }
161 }
162 
163 // File: @openzeppelin/contracts/GSN/Context.sol
164 
165 // -
166 
167 pragma solidity >=0.6.0 <0.8.0;
168 
169 /*
170  * @dev Provides information about the current execution context, including the
171  * sender of the transaction and its data. While these are generally available
172  * via msg.sender and msg.data, they should not be accessed in such a direct
173  * manner, since when dealing with GSN meta-transactions the account sending and
174  * paying for execution may not be the actual sender (as far as an application
175  * is concerned).
176  *
177  * This contract is only required for intermediate, library-like contracts.
178  */
179 abstract contract Context {
180     function _msgSender() internal view virtual returns (address payable) {
181         return msg.sender;
182     }
183 
184     function _msgData() internal view virtual returns (bytes memory) {
185         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
186         return msg.data;
187     }
188 }
189 
190 // File: @openzeppelin/contracts/access/Ownable.sol
191 
192 // -
193 
194 pragma solidity >=0.6.0 <0.8.0;
195 
196 /**
197  * @dev Contract module which provides a basic access control mechanism, where
198  * there is an account (an owner) that can be granted exclusive access to
199  * specific functions.
200  *
201  * By default, the owner account will be the one that deploys the contract. This
202  * can later be changed with {transferOwnership}.
203  *
204  * This module is used through inheritance. It will make available the modifier
205  * `onlyOwner`, which can be applied to your functions to restrict their use to
206  * the owner.
207  */
208 abstract contract Ownable is Context {
209     address private _owner;
210 
211     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
212 
213     /**
214      * @dev Initializes the contract setting the deployer as the initial owner.
215      */
216     constructor () internal {
217         address msgSender = _msgSender();
218         _owner = msgSender;
219         emit OwnershipTransferred(address(0), msgSender);
220     }
221 
222     /**
223      * @dev Returns the address of the current owner.
224      */
225     function owner() public view returns (address) {
226         return _owner;
227     }
228 
229     /**
230      * @dev Throws if called by any account other than the owner.
231      */
232     modifier onlyOwner() {
233         require(_owner == _msgSender(), "Ownable: caller is not the owner");
234         _;
235     }
236 
237     /**
238      * @dev Leaves the contract without owner. It will not be possible to call
239      * `onlyOwner` functions anymore. Can only be called by the current owner.
240      *
241      * NOTE: Renouncing ownership will leave the contract without an owner,
242      * thereby removing any functionality that is only available to the owner.
243      */
244     function renounceOwnership() public virtual onlyOwner {
245         emit OwnershipTransferred(_owner, address(0));
246         _owner = address(0);
247     }
248 
249     /**
250      * @dev Transfers ownership of the contract to a new account (`newOwner`).
251      * Can only be called by the current owner.
252      */
253     function transferOwnership(address newOwner) public virtual onlyOwner {
254         require(newOwner != address(0), "Ownable: new owner is the zero address");
255         emit OwnershipTransferred(_owner, newOwner);
256         _owner = newOwner;
257     }
258 }
259 
260 // File: contracts/Priceable.sol
261 
262 // -
263 pragma solidity 0.7.0;
264 
265 
266 
267 /// @title Priceable
268 /// @notice Contract allows to handle ETH resources of the contract
269 contract Priceable is Ownable {
270 
271   using SafeMath for uint256;
272 
273    /// @notice Emits when owner take ETH out of contract
274    /// @param balance Amount of ETh sent out from contract
275   event Withdraw(uint256 balance);
276 
277   /// @notice Checks minimal amount, that was sent to function call
278   /// @param _minimalAmount Minimal amount neccessary to  continue function call
279   modifier minimalPrice(uint256 _minimalAmount) 
280   {
281     require(msg.value >= _minimalAmount, "Not enough Ether provided.");
282     _;
283   }
284 
285   /// @notice Associete fee with a function call. If the caller sent too much, then is refunded, but only after the function body
286   /// @dev This was dangerous before Solidity version 0.4.0, where it was possible to skip the part after `_;`.
287   /// @param _amount Ether needed to call the function
288   modifier price(uint256 _amount) 
289   {
290     require(msg.value >= _amount, "Not enough Ether provided.");
291     _;
292     if (msg.value > _amount) 
293     {
294       msg.sender.transfer(msg.value.sub(_amount));
295     }
296   }
297 
298   /// @notice Remove all Ether from the contract, and transfer it to account of owner
299   function withdrawBalance()
300     external
301     onlyOwner
302   {
303     uint256 balance = address(this).balance;
304     msg.sender.transfer(balance);
305 
306     // Tell everyone !!!!!!!!!!!!!!!!!!!!!!
307     emit Withdraw(balance);
308   }
309 
310   // fallback functions that allows contract to accept ETH
311   fallback() external payable {}
312   receive() external payable {}
313 
314 }
315 
316 // File: contracts/RmbcSeller.sol
317 
318 // -
319 pragma solidity 0.7.0;
320 
321 
322 
323 /// @title Refined MarbleCoin seller
324 /// @notice This contract is tracked by Marble.Card backend, and if someone transfers MBC to it, or chain currency via the payChainCurrency call, it will move equivalent number of MBC to MarbleBank to the user's account.
325 contract RmbcSeller is Priceable
326 {
327 
328   /// @notice Event emited when a user paid this account chain currency to get RMBC
329   /// @param fromAddress Address of the paying user
330   /// @param paidAmount Amount paid
331   /// @param expectedRmbcAmount Expected amount of received RMBC
332   event ChainCurrencyPaid(address fromAddress, uint256 paidAmount, uint256 expectedRmbcAmount);
333 
334   /// @dev Minimal accepted amount of chain currency (to prevent draining resources). This initial value is 0.001
335   uint256 minimalPaidAmount = 1000000000000000;
336 
337   /// @notice Sets the minimal required amount of paid chain currency
338   /// @dev Can be called only by the owner
339   /// @param _minimalPaidAmount The minimal required chain currency amount
340   function setMinimalPaidAmount(uint256 _minimalPaidAmount)
341     external
342     onlyOwner
343   {
344     minimalPaidAmount = _minimalPaidAmount;
345   }
346 
347   /// @notice Pay chain currency to receive MBC from Marble.Cards backend
348   /// @dev If the rate of RMBC received for the given chain currency changes, we may return the payment back to the user.
349   /// @param expectedRmbcAmount Expected amount of received RMBC. 
350   function payChainCurrency(uint256 expectedRmbcAmount) 
351     payable 
352     external 
353     minimalPrice(minimalPaidAmount)
354   {
355     emit ChainCurrencyPaid(msg.sender, msg.value, expectedRmbcAmount);
356   }
357 
358 }