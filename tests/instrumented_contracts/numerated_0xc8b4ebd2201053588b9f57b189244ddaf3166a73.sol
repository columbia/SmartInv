1 // File: contracts/helpers/Owned.sol
2 
3 pragma solidity >=0.4.0 <0.6.0;
4 
5 contract Owned {
6   address payable public owner;
7 
8   constructor() public {
9     owner = msg.sender;
10   }
11 
12   modifier onlyOwner {
13     require(msg.sender == owner, "Sender not owner");
14     _;
15   }
16 
17   function transferOwnership(address payable newOwner) public onlyOwner {
18     owner = newOwner;
19   }
20 }
21 
22 // File: @openzeppelin/contracts/math/SafeMath.sol
23 
24 pragma solidity ^0.5.0;
25 
26 /**
27  * @dev Wrappers over Solidity's arithmetic operations with added overflow
28  * checks.
29  *
30  * Arithmetic operations in Solidity wrap on overflow. This can easily result
31  * in bugs, because programmers usually assume that an overflow raises an
32  * error, which is the standard behavior in high level programming languages.
33  * `SafeMath` restores this intuition by reverting the transaction when an
34  * operation overflows.
35  *
36  * Using this library instead of the unchecked operations eliminates an entire
37  * class of bugs, so it's recommended to use it always.
38  */
39 library SafeMath {
40     /**
41      * @dev Returns the addition of two unsigned integers, reverting on
42      * overflow.
43      *
44      * Counterpart to Solidity's `+` operator.
45      *
46      * Requirements:
47      * - Addition cannot overflow.
48      */
49     function add(uint256 a, uint256 b) internal pure returns (uint256) {
50         uint256 c = a + b;
51         require(c >= a, "SafeMath: addition overflow");
52 
53         return c;
54     }
55 
56     /**
57      * @dev Returns the subtraction of two unsigned integers, reverting on
58      * overflow (when the result is negative).
59      *
60      * Counterpart to Solidity's `-` operator.
61      *
62      * Requirements:
63      * - Subtraction cannot overflow.
64      */
65     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
66         return sub(a, b, "SafeMath: subtraction overflow");
67     }
68 
69     /**
70      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
71      * overflow (when the result is negative).
72      *
73      * Counterpart to Solidity's `-` operator.
74      *
75      * Requirements:
76      * - Subtraction cannot overflow.
77      *
78      * _Available since v2.4.0._
79      */
80     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
81         require(b <= a, errorMessage);
82         uint256 c = a - b;
83 
84         return c;
85     }
86 
87     /**
88      * @dev Returns the multiplication of two unsigned integers, reverting on
89      * overflow.
90      *
91      * Counterpart to Solidity's `*` operator.
92      *
93      * Requirements:
94      * - Multiplication cannot overflow.
95      */
96     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
97         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
98         // benefit is lost if 'b' is also tested.
99         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
100         if (a == 0) {
101             return 0;
102         }
103 
104         uint256 c = a * b;
105         require(c / a == b, "SafeMath: multiplication overflow");
106 
107         return c;
108     }
109 
110     /**
111      * @dev Returns the integer division of two unsigned integers. Reverts on
112      * division by zero. The result is rounded towards zero.
113      *
114      * Counterpart to Solidity's `/` operator. Note: this function uses a
115      * `revert` opcode (which leaves remaining gas untouched) while Solidity
116      * uses an invalid opcode to revert (consuming all remaining gas).
117      *
118      * Requirements:
119      * - The divisor cannot be zero.
120      */
121     function div(uint256 a, uint256 b) internal pure returns (uint256) {
122         return div(a, b, "SafeMath: division by zero");
123     }
124 
125     /**
126      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
127      * division by zero. The result is rounded towards zero.
128      *
129      * Counterpart to Solidity's `/` operator. Note: this function uses a
130      * `revert` opcode (which leaves remaining gas untouched) while Solidity
131      * uses an invalid opcode to revert (consuming all remaining gas).
132      *
133      * Requirements:
134      * - The divisor cannot be zero.
135      *
136      * _Available since v2.4.0._
137      */
138     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
139         // Solidity only automatically asserts when dividing by 0
140         require(b > 0, errorMessage);
141         uint256 c = a / b;
142         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
143 
144         return c;
145     }
146 
147     /**
148      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
149      * Reverts when dividing by zero.
150      *
151      * Counterpart to Solidity's `%` operator. This function uses a `revert`
152      * opcode (which leaves remaining gas untouched) while Solidity uses an
153      * invalid opcode to revert (consuming all remaining gas).
154      *
155      * Requirements:
156      * - The divisor cannot be zero.
157      */
158     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
159         return mod(a, b, "SafeMath: modulo by zero");
160     }
161 
162     /**
163      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
164      * Reverts with custom message when dividing by zero.
165      *
166      * Counterpart to Solidity's `%` operator. This function uses a `revert`
167      * opcode (which leaves remaining gas untouched) while Solidity uses an
168      * invalid opcode to revert (consuming all remaining gas).
169      *
170      * Requirements:
171      * - The divisor cannot be zero.
172      *
173      * _Available since v2.4.0._
174      */
175     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
176         require(b != 0, errorMessage);
177         return a % b;
178     }
179 }
180 
181 // File: contracts/Gems/Staking.sol
182 
183 pragma solidity ^0.5.10;
184 
185 
186 
187 interface IStakingErc20 {
188   function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
189   // This only applies to Cargo Credits 
190   function increaseBalance(address user, uint balance) external;
191   function transfer(address to, uint256 value) external returns (bool success);
192 }
193 
194 interface IStakingCargoData {
195   function verifySigAndUuid(bytes32 hash, bytes calldata signature, bytes32 uuid) external;
196   function verifyContract(address contractAddress) external returns (bool);
197 }
198 
199 interface IStakingErc721 {
200   function ownerOf(uint256 tokenId) external view returns (address);
201   function supportsInterface(bytes4 interfaceId)
202     external
203     view
204     returns (bool);
205 }
206 
207 contract CargoGemsStaking is Owned {
208   using SafeMath for uint256;
209 
210   event TotalStakeUpdated(uint totalStakedAmount);
211   event TokenStakeUpdated(
212     address indexed tokenContract, 
213     uint256 indexed tokenId, 
214     uint256 stakedAmount, 
215     bool genesis
216   );
217   event Claim(
218     address indexed claimant, 
219     address indexed tokenContractAddress, 
220     uint256 indexed tokenId, 
221     uint256 gemsReward, 
222     uint256 creditsReward
223   );
224 
225   IStakingCargoData cargoData;
226   IStakingErc20 cargoGems;
227   IStakingErc20 cargoCredits;
228 
229   struct Stake {
230     uint amount;
231     uint lastBlockClaimed;
232     uint genesisBlock;
233     bool exists;
234   }
235 
236   uint256 public totalStaked = 0;
237   mapping(string => bool) config;
238 
239   // Token Contract Address => Token ID => Staked Amount
240   mapping(address => mapping(uint256 => Stake)) tokenStakes;
241   mapping(address => bool) public whiteList;
242   mapping(address => bool) public blackList;
243 
244   constructor(address cargoDataAddress, address cargoGemsAddress, address cargoCreditsAddress) public {
245     cargoData = IStakingCargoData(cargoDataAddress);
246     cargoGems = IStakingErc20(cargoGemsAddress);
247     cargoCredits = IStakingErc20(cargoCreditsAddress);
248     config["enabled"] = true;
249     config["onlyCargoContracts"] = true;
250   }
251 
252   modifier onlyEnabled() {
253     require(config["enabled"] == true, "Staking: Not enabled"); 
254     _;
255   }
256 
257   modifier onlyExists(address contractAddress, uint tokenId) {
258     require(tokenStakes[contractAddress][tokenId].exists, "Staking: Token ID at address not staked");
259     _;
260   }
261 
262   function updateBlacklist(address contractAddress, bool val) external onlyOwner {
263     blackList[contractAddress] = val;
264   }
265 
266   function updateWhitelist(address contractAddress, bool val) external onlyOwner {
267     whiteList[contractAddress] = val;
268   }
269 
270   function updateConfig(string calldata key, bool value) external onlyOwner {
271     config[key] = value;
272   }
273 
274   function getStakedAmount(address contractAddress, uint tokenId) onlyExists(contractAddress, tokenId) external view returns (uint) {
275     return tokenStakes[contractAddress][tokenId].amount;
276   }
277 
278   function getLastBlockClaimed(address contractAddress, uint tokenId) onlyExists(contractAddress, tokenId) external view returns (uint) {
279     return tokenStakes[contractAddress][tokenId].lastBlockClaimed;
280   }
281 
282   function getStakeGenesis(address contractAddress, uint tokenId) onlyExists(contractAddress, tokenId) external view returns (uint) {
283     return tokenStakes[contractAddress][tokenId].genesisBlock;
284   }
285 
286   /** @notice Function to claim rewards. Rewards are calculated off-chain by using on-chain data */
287   function claim(
288     address tokenContractAddress, 
289     uint tokenId, 
290     uint gemsReward,
291     uint creditsReward,
292     uint blockNumber,
293     uint amountToWithdraw,
294     bytes32 uuid,
295     bytes calldata signature
296   ) external onlyEnabled {
297     cargoData.verifySigAndUuid(keccak256(
298       abi.encodePacked(
299         "CLAIM",
300         tokenContractAddress,
301         tokenId,
302         gemsReward,
303         creditsReward,
304         amountToWithdraw,
305         blockNumber,
306         uuid
307       )
308     ), signature, uuid);
309 
310     IStakingErc721 erc721 = IStakingErc721(tokenContractAddress);
311     require(erc721.ownerOf(tokenId) == msg.sender, "Staking: Sender not owner");
312     require(tokenStakes[tokenContractAddress][tokenId].lastBlockClaimed < blockNumber, "Staking: block number invalid");
313 
314     tokenStakes[tokenContractAddress][tokenId].amount = tokenStakes[tokenContractAddress][tokenId].amount.add(gemsReward);
315     totalStaked = totalStaked.add(gemsReward);
316 
317     if(amountToWithdraw > 0) {
318       require(amountToWithdraw <= tokenStakes[tokenContractAddress][tokenId].amount, "Staking: Withdrawl amount must be lte staked amount");
319 
320       // transfer rewards to sender
321       cargoGems.transfer(msg.sender, amountToWithdraw);
322       
323       // Decrease staked amount
324       tokenStakes[tokenContractAddress][tokenId].amount = tokenStakes[tokenContractAddress][tokenId].amount.sub(amountToWithdraw);
325       totalStaked = totalStaked.sub(amountToWithdraw);
326     }
327 
328     // Regardless of whether its a withdrawl the user will still be rewarded credits.
329     cargoCredits.increaseBalance(msg.sender, creditsReward);
330 
331     // Save block number 
332     tokenStakes[tokenContractAddress][tokenId].lastBlockClaimed = block.number;
333 
334     emit Claim(msg.sender, tokenContractAddress, tokenId, gemsReward, creditsReward);
335     emit TotalStakeUpdated(totalStaked);
336     emit TokenStakeUpdated(
337       tokenContractAddress, 
338       tokenId, 
339       tokenStakes[tokenContractAddress][tokenId].amount, 
340       !tokenStakes[tokenContractAddress][tokenId].exists
341     );
342   }
343 
344   /**
345     @notice function to stake 
346     @param tokenContractAddress Address of ERC721 contract
347     @param tokenId ID of token
348     @param amountToStake Amount of Cargo gems, must account for decimals when sending this
349    */
350   function stake(address tokenContractAddress, uint tokenId, uint amountToStake) external onlyEnabled {
351     require(amountToStake > 0, "Staking: Amount must be gt 0");
352     if(config["onlyCargoContracts"]) {
353       require(cargoData.verifyContract(tokenContractAddress), "Staking: Must be a cargo contract");
354     }
355     IStakingErc721 erc721 = IStakingErc721(tokenContractAddress);
356     require(
357       (erc721.supportsInterface(0x80ac58cd) || whiteList[tokenContractAddress]) 
358       && !blackList[tokenContractAddress], 
359       "Staking: 721 not supported"
360     );
361     require(erc721.ownerOf(tokenId) == msg.sender, "Staking: Sender not owner");
362     // User must approve this contract to transfer the given amount
363     cargoGems.transferFrom(msg.sender, address(this), amountToStake);
364 
365     // Increase token's staked amount
366     tokenStakes[tokenContractAddress][tokenId].amount = tokenStakes[tokenContractAddress][tokenId].amount.add(amountToStake);
367 
368     // Increase the total staked amount
369     totalStaked = totalStaked.add(amountToStake);
370 
371     emit TotalStakeUpdated(totalStaked);
372     emit TokenStakeUpdated(
373       tokenContractAddress, 
374       tokenId, 
375       tokenStakes[tokenContractAddress][tokenId].amount, 
376       !tokenStakes[tokenContractAddress][tokenId].exists
377     );
378 
379     if(!tokenStakes[tokenContractAddress][tokenId].exists) {
380       tokenStakes[tokenContractAddress][tokenId].genesisBlock = block.number;
381       tokenStakes[tokenContractAddress][tokenId].exists = true;
382     }
383   }
384 }