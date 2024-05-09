1 pragma solidity ^0.5.0;
2 
3 /// https://eips.ethereum.org/EIPS/eip-165
4 interface ERC165 {
5   /// @notice Query if a contract implements an interface
6   /// @param interfaceID The interface identifier, as specified in ERC-165
7   /// @dev Interface identification is specified in ERC-165. This function
8   ///  uses less than 30,000 gas.
9   /// @return `true` if the contract implements `interfaceID` and
10   ///  `interfaceID` is not 0xffffffff, `false` otherwise
11   function supportsInterface(bytes4 interfaceID) external view returns (bool);
12 }
13 
14 /// https://eips.ethereum.org/EIPS/eip-900
15 /// @notice Interface with external methods
16 interface ISimpleStaking {
17 
18   event Staked(address indexed user, uint256 amount, uint256 total, bytes data);
19   event Unstaked(address indexed user, uint256 amount, uint256 total, bytes data);
20 
21   function stake(uint256 amount, bytes calldata data) external;
22   function stakeFor(address user, uint256 amount, bytes calldata data) external;
23   function unstake(uint256 amount, bytes calldata data) external;
24   function totalStakedFor(address addr) external view returns (uint256);
25   function totalStaked() external view returns (uint256);
26   function token() external view returns (address);
27   function supportsHistory() external pure returns (bool);
28 
29   // optional. Commented out until we have valid reason to implement these methods
30   // function lastStakedFor(address addr) public view returns (uint256);
31   // function totalStakedForAt(address addr, uint256 blockNumber) public view returns (uint256);
32   // function totalStakedAt(uint256 blockNumber) public view returns (uint256);
33 }
34 
35 /**
36  * @title SafeMath
37  * Courtesy of https://github.com/OpenZeppelin/openzeppelin-solidity/blob/9be0f100c48e4726bee73829fbb10f7d85b6ef54/contracts/math/SafeMath.sol
38  * @dev Math operations with safety checks that revert on error
39  */
40 library SafeMath {
41 
42   /**
43   * @dev Multiplies two numbers, reverts on overflow.
44   */
45   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
46     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
47     // benefit is lost if 'b' is also tested.
48     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
49     if (a == 0) {
50       return 0;
51     }
52 
53     uint256 c = a * b;
54     require(c / a == b);
55 
56     return c;
57   }
58 
59   /**
60   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
61   */
62   function div(uint256 a, uint256 b) internal pure returns (uint256) {
63     require(b > 0); // Solidity only automatically asserts when dividing by 0
64     uint256 c = a / b;
65     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
66 
67     return c;
68   }
69 
70   /**
71   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
72   */
73   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
74     require(b <= a);
75     uint256 c = a - b;
76 
77     return c;
78   }
79 
80   /**
81   * @dev Adds two numbers, reverts on overflow.
82   */
83   function add(uint256 a, uint256 b) internal pure returns (uint256) {
84     uint256 c = a + b;
85     require(c >= a);
86 
87     return c;
88   }
89 
90   /**
91   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
92   * reverts when dividing by zero.
93   */
94   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
95     require(b != 0);
96     return a % b;
97   }
98 }
99 
100 contract ERC20 {
101 
102   /// @return The total amount of tokens
103   function totalSupply() public view returns (uint256 supply);
104 
105   /// @param _owner The address from which the balance will be retrieved
106   /// @return The balance
107   function balanceOf(address _owner) public view returns (uint256 balance);
108 
109   /// @notice send `_value` token to `_to` from `msg.sender`
110   /// @param _to The address of the recipient
111   /// @param _value The amount of token to be transferred
112   /// @return Whether the transfer was successful or not
113   function transfer(address _to, uint256 _value) public returns (bool success);
114 
115   /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
116   /// @param _from The address of the sender
117   /// @param _to The address of the recipient
118   /// @param _value The amount of token to be transferred
119   /// @return Whether the transfer was successful or not
120   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
121 
122   /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
123   /// @param _spender The address of the account able to transfer the tokens
124   /// @param _value The amount of tokens to be approved for transfer
125   /// @return Whether the approval was successful or not
126   function approve(address _spender, uint256 _value) public returns (bool success);
127 
128   /// @param _owner The address of the account owning tokens
129   /// @param _spender The address of the account able to transfer the tokens
130   /// @return Amount of remaining tokens allowed to spent
131   function allowance(address _owner, address _spender) public view returns (uint256 remaining);
132 
133   event Transfer(address indexed from, address indexed to, uint256 value);
134   event Approval(address indexed owner, address indexed spender, uint256 value);
135 }
136 
137 
138 /**
139 * Smart contract to stake ERC20 and optionally lock it in for a period of time.
140 * Users can add stake any time as long as the emergency status is false
141 * Maximum locked-in time is 365 days from now.
142 *
143 * It also keeps track of the effective start time which is recorded on the very
144 * first stake. Think of it as the "member since" attribute.
145 * If user unstakes (full or partial) at any point, the effective start time is reset.
146 *
147 */
148 contract TimeLockedStaking is ERC165, ISimpleStaking {
149   using SafeMath for uint256;
150 
151   struct StakeRecord {
152     uint256 amount;
153     uint256 unlockedAt;
154   }
155 
156   struct StakeInfo {
157     /// total tokens this user stakes.
158     uint256 totalAmount;
159     /// "member since" in unix timestamp. Reset when user unstakes.
160     uint256 effectiveAt;
161     /// storing staking data for unstaking later.
162     /// recordId i.e. key of mapping is the keccak256 of the 'data' parameter in the stake method.
163     mapping (bytes32 => StakeRecord) stakeRecords;
164   }
165 
166   /// @dev When emergency is true,
167   /// block staking action and
168   /// allow to unstake without verifying the record.unlockedAt
169   bool public emergency;
170 
171   /// @dev Owner of this contract, who can activate the emergency.
172   address public owner;
173 
174   /// @dev Address of the ERC20 token contract used for staking.
175   ERC20 internal erc20Token;
176 
177   /// @dev https://solidity.readthedocs.io/en/v0.4.25/style-guide.html#avoiding-naming-collisions
178   uint256 internal totalStaked_ = 0;
179 
180   /// Keep track of all stakers
181   mapping (address => StakeInfo) public stakers;
182 
183   modifier greaterThanZero(uint256 num) {
184     require(num > 0, "Must be greater than 0.");
185     _;
186   }
187 
188   /// @dev Better to manually validate these params after deployment.
189   /// @param token_ ERC0 token's address. Required.
190   /// @param owner_ Who can set emergency status. Default: msg.sender.
191   constructor(address token_, address owner_) public {
192     erc20Token = ERC20(token_);
193     owner = owner_;
194     emergency = false;
195   }
196 
197   /// @dev Implement ERC165
198   /// With three or more supported interfaces (including ERC165 itself as a required supported interface),
199   /// the mapping approach (in every case) costs less gas than the pure approach (at worst case).
200   function supportsInterface(bytes4 interfaceID) external view returns (bool) {
201     return
202       interfaceID == this.supportsInterface.selector ||
203       interfaceID == this.stake.selector ^ this.stakeFor.selector ^ this.unstake.selector ^ this.totalStakedFor.selector ^ this.totalStaked.selector ^ this.token.selector ^ this.supportsHistory.selector;
204   }
205 
206   /// @dev msg.sender stakes for him/her self.
207   /// @param amount Number of ERC20 to be staked. Amount must be > 0.
208   /// @param data Used for signaling the unlocked time.
209   function stake(uint256 amount, bytes calldata data) external {
210     registerStake(msg.sender, amount, data);
211   }
212 
213   /// @dev msg.sender stakes for someone else.
214   /// @param amount Number of ERC20 to be staked. Must be > 0.
215   /// @param data Used for signaling the unlocked time.
216   function stakeFor(address user, uint256 amount, bytes calldata data) external {
217     registerStake(user, amount, data);
218   }
219 
220   /// @dev msg.sender can unstake full amount or partial if unlockedAt =< now
221   /// @notice as a result, the "member since" attribute is reset.
222   /// @param amount Number of ERC20 to be unstaked. Must be > 0 and =< staked amount.
223   /// @param data The payload that was used when staking.
224   function unstake(uint256 amount, bytes calldata data)
225     external
226     greaterThanZero(stakers[msg.sender].effectiveAt) // must be a member
227     greaterThanZero(amount)
228   {
229     address user = msg.sender;
230 
231     bytes32 recordId = keccak256(data);
232 
233     StakeRecord storage record = stakers[user].stakeRecords[recordId];
234 
235     require(amount <= record.amount, "Amount must be equal or smaller than the record.");
236 
237     // Validate unlockedAt if there's no emergency.
238     // Otherwise, ignore the lockdown period.
239     if (!emergency) {
240       require(block.timestamp >= record.unlockedAt, "This stake is still locked.");
241     }
242 
243     record.amount = record.amount.sub(amount);
244 
245     stakers[user].totalAmount = stakers[user].totalAmount.sub(amount);
246     stakers[user].effectiveAt = block.timestamp;
247 
248     totalStaked_ = totalStaked_.sub(amount);
249 
250     require(erc20Token.transfer(user, amount), "Transfer failed.");
251     emit Unstaked(user, amount, stakers[user].totalAmount, data);
252   }
253 
254   /// @return The staked amount of an address.
255   function totalStakedFor(address addr) external view returns (uint256) {
256     return stakers[addr].totalAmount;
257   }
258 
259   /// @return Total number of tokens this smart contract hold.
260   function totalStaked() external view returns (uint256) {
261     return totalStaked_;
262   }
263 
264   /// @return Address of the ERC20 used for staking.
265   function token() external view returns (address) {
266     return address(erc20Token);
267   }
268 
269   /// @dev This smart contract does not store staking activities on chain.
270   /// @return false History is processed off-chain via event logs.
271   function supportsHistory() external pure returns (bool) {
272     return false;
273   }
274 
275 
276   /// Escape hatch
277   function setEmergency(bool status) external {
278     require(msg.sender == owner, "msg.sender must be owner.");
279     emergency = status;
280   }
281 
282   /// Helpers
283   ///
284 
285   function max(uint256 a, uint256 b) public pure returns (uint256) {
286     return a > b ? a : b;
287   }
288 
289   function min(uint256 a, uint256 b) public pure returns (uint256) {
290     return a > b ? b : a;
291   }
292 
293   function getStakeRecordUnlockedAt(address user, bytes memory data) public view returns (uint256) {
294     return stakers[user].stakeRecords[keccak256(data)].unlockedAt;
295   }
296 
297   function getStakeRecordAmount(address user, bytes memory data) public view returns (uint256) {
298     return stakers[user].stakeRecords[keccak256(data)].amount;
299   }
300 
301   /// @dev Get the unlockedAt in the data field.
302   /// Maximum of 365 days from now.
303   /// Minimum of 1. Default value if data.length < 32.
304   /// @param data The left-most 256 bits are unix timestamp in seconds.
305   /// @return The unlockedAt in the data. Range [1, 365 days from now].
306   function getUnlockedAtSignal(bytes memory data) public view returns (uint256) {
307     uint256 unlockedAt;
308 
309     if (data.length >= 32) {
310       assembly {
311         let d := add(data, 32) // first 32 bytes are the padded length of data
312         unlockedAt := mload(d)
313       }
314     }
315 
316     // Maximum 365 days from now
317     uint256 oneYearFromNow = block.timestamp + 365 days;
318     uint256 capped = min(unlockedAt, oneYearFromNow);
319 
320     return max(1, capped);
321   }
322 
323   /// @dev Register a stake by updating the StakeInfo struct
324   function registerStake(address user, uint256 amount, bytes memory data) private greaterThanZero(amount) {
325     require(!emergency, "Cannot stake due to emergency.");
326     require(erc20Token.transferFrom(msg.sender, address(this), amount), "Transfer failed.");
327 
328     StakeInfo storage info = stakers[user];
329 
330     // Update effective at
331     info.effectiveAt = info.effectiveAt == 0 ? block.timestamp : info.effectiveAt;
332 
333     // Update stake record
334     bytes32 recordId = keccak256(data);
335     StakeRecord storage record = info.stakeRecords[recordId];
336     record.amount = amount.add(record.amount);
337     record.unlockedAt = record.unlockedAt == 0 ? getUnlockedAtSignal(data) : record.unlockedAt;
338 
339     // Update total amounts
340     info.totalAmount = amount.add(info.totalAmount);
341     totalStaked_ = totalStaked_.add(amount);
342 
343     emit Staked(user, amount, stakers[user].totalAmount, data);
344   }
345 }