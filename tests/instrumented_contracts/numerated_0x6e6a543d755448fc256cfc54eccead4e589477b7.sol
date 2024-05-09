1 // Dependency file: @openzeppelin/contracts/math/SafeMath.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 // pragma solidity ^0.6.0;
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
163 
164 // Dependency file: @openzeppelin/contracts/utils/ReentrancyGuard.sol
165 
166 // pragma solidity ^0.6.0;
167 
168 /**
169  * @dev Contract module that helps prevent reentrant calls to a function.
170  *
171  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
172  * available, which can be applied to functions to make sure there are no nested
173  * (reentrant) calls to them.
174  *
175  * Note that because there is a single `nonReentrant` guard, functions marked as
176  * `nonReentrant` may not call one another. This can be worked around by making
177  * those functions `private`, and then adding `external` `nonReentrant` entry
178  * points to them.
179  *
180  * TIP: If you would like to learn more about reentrancy and alternative ways
181  * to protect against it, check out our blog post
182  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
183  */
184 contract ReentrancyGuard {
185     // Booleans are more expensive than uint256 or any type that takes up a full
186     // word because each write operation emits an extra SLOAD to first read the
187     // slot's contents, replace the bits taken up by the boolean, and then write
188     // back. This is the compiler's defense against contract upgrades and
189     // pointer aliasing, and it cannot be disabled.
190 
191     // The values being non-zero value makes deployment a bit more expensive,
192     // but in exchange the refund on every call to nonReentrant will be lower in
193     // amount. Since refunds are capped to a percentage of the total
194     // transaction's gas, it is best to keep them low in cases like this one, to
195     // increase the likelihood of the full refund coming into effect.
196     uint256 private constant _NOT_ENTERED = 1;
197     uint256 private constant _ENTERED = 2;
198 
199     uint256 private _status;
200 
201     constructor () internal {
202         _status = _NOT_ENTERED;
203     }
204 
205     /**
206      * @dev Prevents a contract from calling itself, directly or indirectly.
207      * Calling a `nonReentrant` function from another `nonReentrant`
208      * function is not supported. It is possible to prevent this from happening
209      * by making the `nonReentrant` function external, and make it call a
210      * `private` function that does the actual work.
211      */
212     modifier nonReentrant() {
213         // On the first call to nonReentrant, _notEntered will be true
214         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
215 
216         // Any calls to nonReentrant after this point will fail
217         _status = _ENTERED;
218 
219         _;
220 
221         // By storing the original value once again, a refund is triggered (see
222         // https://eips.ethereum.org/EIPS/eip-2200)
223         _status = _NOT_ENTERED;
224     }
225 }
226 
227 
228 // Dependency file: @uniswap/lib/contracts/libraries/TransferHelper.sol
229 
230 // pragma solidity >=0.6.0;
231 
232 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
233 library TransferHelper {
234     function safeApprove(address token, address to, uint value) internal {
235         // bytes4(keccak256(bytes('approve(address,uint256)')));
236         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
237         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
238     }
239 
240     function safeTransfer(address token, address to, uint value) internal {
241         // bytes4(keccak256(bytes('transfer(address,uint256)')));
242         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
243         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
244     }
245 
246     function safeTransferFrom(address token, address from, address to, uint value) internal {
247         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
248         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
249         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
250     }
251 
252     function safeTransferETH(address to, uint value) internal {
253         (bool success,) = to.call{value:value}(new bytes(0));
254         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
255     }
256 }
257 
258 
259 // Dependency file: contracts/IUniTradeStaker.sol
260 
261 // pragma solidity ^0.6.6;
262 
263 interface IUniTradeStaker
264 {
265     function deposit() external payable;
266 }
267 
268 
269 // Root file: contracts/UniTradeStaker01.sol
270 
271 pragma solidity ^0.6.6;
272 
273 // import "@openzeppelin/contracts/math/SafeMath.sol";
274 // import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
275 // import "@uniswap/lib/contracts/libraries/TransferHelper.sol";
276 // import "contracts/IUniTradeStaker.sol";
277 
278 contract UniTradeStaker01 is IUniTradeStaker, ReentrancyGuard {
279     using SafeMath for uint256;
280 
281     address immutable unitrade;
282 
283     uint256 constant DEFAULT_STAKE_PERIOD = 30 days;
284     uint256 public totalStake;
285     uint256 totalWeight;
286     uint256 public totalEthReceived;
287     mapping(address => uint256) public staked;
288     mapping(address => uint256) public timelock;
289     mapping(address => uint256) weighted;
290     mapping(address => uint256) accumulated;
291 
292     event Stake(address indexed staker, uint256 unitradeIn);
293     event Withdraw(address indexed staker, uint256 unitradeOut, uint256 reward);
294     event Deposit(address indexed depositor, uint256 amount);
295 
296     constructor(address _unitrade) public {
297         unitrade = _unitrade;
298     }
299 
300     function stake(uint256 unitradeIn) nonReentrant public {
301         require(unitradeIn > 0, "Nothing to stake");
302 
303         _stake(unitradeIn);
304         timelock[msg.sender] = block.timestamp.add(DEFAULT_STAKE_PERIOD);
305 
306         TransferHelper.safeTransferFrom(
307             unitrade,
308             msg.sender,
309             address(this),
310             unitradeIn
311         );
312     }
313 
314     function withdraw() nonReentrant public returns (uint256 unitradeOut, uint256 reward) {
315         require(block.timestamp >= timelock[msg.sender], "Stake is locked");
316 
317         (unitradeOut, reward) = _applyReward();
318         emit Withdraw(msg.sender, unitradeOut, reward);
319 
320         timelock[msg.sender] = 0;
321 
322         TransferHelper.safeTransfer(unitrade, msg.sender, unitradeOut);
323         if (reward > 0) {
324             TransferHelper.safeTransferETH(msg.sender, reward);
325         }
326     }
327 
328     function payout() nonReentrant public returns (uint256 reward) {
329         (uint256 unitradeOut, uint256 _reward) = _applyReward();
330         emit Withdraw(msg.sender, unitradeOut, _reward);
331         reward = _reward;
332 
333         require(reward > 0, "Nothing to pay out");
334         TransferHelper.safeTransferETH(msg.sender, reward);
335 
336         // restake after withdrawal
337         _stake(unitradeOut);
338         timelock[msg.sender] = block.timestamp.add(DEFAULT_STAKE_PERIOD);
339     }
340 
341     function deposit() nonReentrant public override payable {
342         require(msg.value > 0, "Nothing to deposit");
343         require(totalStake > 0, "Nothing staked");
344 
345         totalEthReceived = totalEthReceived.add(msg.value);
346 
347         emit Deposit(msg.sender, msg.value);
348 
349         _distribute(msg.value, totalStake);
350     }
351 
352     function _stake(uint256 unitradeIn) private {
353         uint256 addBack;
354         if (staked[msg.sender] > 0) {
355             (uint256 unitradeOut, uint256 reward) = _applyReward();
356             addBack = unitradeOut;
357             accumulated[msg.sender] = reward;
358             staked[msg.sender] = unitradeOut;
359         }
360 
361         staked[msg.sender] = staked[msg.sender].add(unitradeIn);
362         weighted[msg.sender] = totalWeight;
363         totalStake = totalStake.add(unitradeIn);
364 
365         if (addBack > 0) {
366             totalStake = totalStake.add(addBack);
367         }
368 
369         emit Stake(msg.sender, unitradeIn);
370     }
371 
372     function _applyReward() private returns (uint256 unitradeOut, uint256 reward) {
373         require(staked[msg.sender] > 0, "Nothing staked");
374 
375         unitradeOut = staked[msg.sender];
376         reward = unitradeOut
377             .mul(totalWeight.sub(weighted[msg.sender]))
378             .div(10**18)
379             .add(accumulated[msg.sender]);
380         totalStake = totalStake.sub(unitradeOut);
381         accumulated[msg.sender] = 0;
382         staked[msg.sender] = 0;
383     }
384 
385     function _distribute(uint256 _value, uint256 _totalStake) private {
386         totalWeight = totalWeight.add(_value.mul(10**18).div(_totalStake));
387     }
388 }