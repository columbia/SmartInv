1 // File: SafeMath.sol
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
163 // File: browser/TimeLock.sol
164 
165 // COPIED FROM https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/GovernorAlpha.sol
166 // Copyright 2020 Compound Labs, Inc.
167 // Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
168 // 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
169 // 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
170 // 3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
171 // THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
172 //
173 // Ctrl+f for XXX to see all the modifications.
174 
175 // XXX: pragma solidity ^0.5.16;
176 pragma solidity 0.6.12;
177 
178 // XXX: import "./SafeMath.sol";
179 
180 
181 contract Timelock {
182     using SafeMath for uint;
183 
184     event NewAdmin(address indexed newAdmin);
185     event NewPendingAdmin(address indexed newPendingAdmin);
186     event NewDelay(uint indexed newDelay);
187     event CancelTransaction(bytes32 indexed txHash, address indexed target, uint value, string signature,  bytes data, uint eta);
188     event ExecuteTransaction(bytes32 indexed txHash, address indexed target, uint value, string signature,  bytes data, uint eta);
189     event QueueTransaction(bytes32 indexed txHash, address indexed target, uint value, string signature, bytes data, uint eta);
190 
191     uint public constant GRACE_PERIOD = 14 days;
192     uint public constant MINIMUM_DELAY = 2 days;
193     uint public constant MAXIMUM_DELAY = 30 days;
194 
195     address public admin;
196     address public pendingAdmin;
197     uint public delay;
198     bool public admin_initialized;
199 
200     mapping (bytes32 => bool) public queuedTransactions;
201 
202 
203     constructor(address admin_, uint delay_) public {
204         require(delay_ >= MINIMUM_DELAY, "Timelock::constructor: Delay must exceed minimum delay.");
205         require(delay_ <= MAXIMUM_DELAY, "Timelock::constructor: Delay must not exceed maximum delay.");
206 
207         admin = admin_;
208         delay = delay_;
209         admin_initialized = false;
210     }
211 
212     // XXX: function() external payable { }
213     receive() external payable { }
214 
215     function setDelay(uint delay_) public {
216         require(msg.sender == address(this), "Timelock::setDelay: Call must come from Timelock.");
217         require(delay_ >= MINIMUM_DELAY, "Timelock::setDelay: Delay must exceed minimum delay.");
218         require(delay_ <= MAXIMUM_DELAY, "Timelock::setDelay: Delay must not exceed maximum delay.");
219         delay = delay_;
220 
221         emit NewDelay(delay);
222     }
223 
224     function acceptAdmin() public {
225         require(msg.sender == pendingAdmin, "Timelock::acceptAdmin: Call must come from pendingAdmin.");
226         admin = msg.sender;
227         pendingAdmin = address(0);
228 
229         emit NewAdmin(admin);
230     }
231 
232     function setPendingAdmin(address pendingAdmin_) public {
233         // allows one time setting of admin for deployment purposes
234         if (admin_initialized) {
235             require(msg.sender == address(this), "Timelock::setPendingAdmin: Call must come from Timelock.");
236         } else {
237             require(msg.sender == admin, "Timelock::setPendingAdmin: First call must come from admin.");
238             admin_initialized = true;
239         }
240         pendingAdmin = pendingAdmin_;
241 
242         emit NewPendingAdmin(pendingAdmin);
243     }
244 
245     function queueTransaction(address target, uint value, string memory signature, bytes memory data, uint eta) public returns (bytes32) {
246         require(msg.sender == admin, "Timelock::queueTransaction: Call must come from admin.");
247         require(eta >= getBlockTimestamp().add(delay), "Timelock::queueTransaction: Estimated execution block must satisfy delay.");
248 
249         bytes32 txHash = keccak256(abi.encode(target, value, signature, data, eta));
250         queuedTransactions[txHash] = true;
251 
252         emit QueueTransaction(txHash, target, value, signature, data, eta);
253         return txHash;
254     }
255 
256     function cancelTransaction(address target, uint value, string memory signature, bytes memory data, uint eta) public {
257         require(msg.sender == admin, "Timelock::cancelTransaction: Call must come from admin.");
258 
259         bytes32 txHash = keccak256(abi.encode(target, value, signature, data, eta));
260         queuedTransactions[txHash] = false;
261 
262         emit CancelTransaction(txHash, target, value, signature, data, eta);
263     }
264 
265     function executeTransaction(address target, uint value, string memory signature, bytes memory data, uint eta) public payable returns (bytes memory) {
266         require(msg.sender == admin, "Timelock::executeTransaction: Call must come from admin.");
267 
268         bytes32 txHash = keccak256(abi.encode(target, value, signature, data, eta));
269         require(queuedTransactions[txHash], "Timelock::executeTransaction: Transaction hasn't been queued.");
270         require(getBlockTimestamp() >= eta, "Timelock::executeTransaction: Transaction hasn't surpassed time lock.");
271         require(getBlockTimestamp() <= eta.add(GRACE_PERIOD), "Timelock::executeTransaction: Transaction is stale.");
272 
273         queuedTransactions[txHash] = false;
274 
275         bytes memory callData;
276 
277         if (bytes(signature).length == 0) {
278             callData = data;
279         } else {
280             callData = abi.encodePacked(bytes4(keccak256(bytes(signature))), data);
281         }
282 
283         // solium-disable-next-line security/no-call-value
284         (bool success, bytes memory returnData) = target.call.value(value)(callData);
285         require(success, "Timelock::executeTransaction: Transaction execution reverted.");
286 
287         emit ExecuteTransaction(txHash, target, value, signature, data, eta);
288 
289         return returnData;
290     }
291 
292     function getBlockTimestamp() internal view returns (uint) {
293         // solium-disable-next-line security/no-block-members
294         return block.timestamp;
295     }
296 }