1 //SPDX-License-Identifier: MIT
2 pragma solidity 0.8.14;
3 
4 interface IERC20 {
5 
6     function totalSupply() external view returns (uint256);
7     
8     function symbol() external view returns(string memory);
9     
10     function name() external view returns(string memory);
11 
12     /**
13      * @dev Returns the amount of tokens owned by `account`.
14      */
15     function balanceOf(address account) external view returns (uint256);
16     
17     /**
18      * @dev Returns the number of decimal places
19      */
20     function decimals() external view returns (uint8);
21 
22     /**
23      * @dev Moves `amount` tokens from the caller's account to `recipient`.
24      *
25      * Returns a boolean value indicating whether the operation succeeded.
26      *
27      * Emits a {Transfer} event.
28      */
29     function transfer(address recipient, uint256 amount) external returns (bool);
30 
31     /**
32      * @dev Returns the remaining number of tokens that `spender` will be
33      * allowed to spend on behalf of `owner` through {transferFrom}. This is
34      * zero by default.
35      *
36      * This value changes when {approve} or {transferFrom} are called.
37      */
38     function allowance(address owner, address spender) external view returns (uint256);
39 
40     /**
41      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * IMPORTANT: Beware that changing an allowance with this method brings the risk
46      * that someone may use both the old and the new allowance by unfortunate
47      * transaction ordering. One possible solution to mitigate this race
48      * condition is to first reduce the spender's allowance to 0 and set the
49      * desired value afterwards:
50      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
51      *
52      * Emits an {Approval} event.
53      */
54     function approve(address spender, uint256 amount) external returns (bool);
55 
56     /**
57      * @dev Moves `amount` tokens from `sender` to `recipient` using the
58      * allowance mechanism. `amount` is then deducted from the caller's
59      * allowance.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * Emits a {Transfer} event.
64      */
65     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
66 
67     /**
68      * @dev Emitted when `value` tokens are moved from one account (`from`) to
69      * another (`to`).
70      *
71      * Note that `value` may be zero.
72      */
73     event Transfer(address indexed from, address indexed to, uint256 value);
74 
75     /**
76      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
77      * a call to {approve}. `value` is the new allowance.
78      */
79     event Approval(address indexed owner, address indexed spender, uint256 value);
80 }
81 
82 /**
83  * @title Owner
84  * @dev Set & change owner
85  */
86 contract Ownable {
87 
88     address private owner;
89     
90     // event for EVM logging
91     event OwnerSet(address indexed oldOwner, address indexed newOwner);
92     
93     // modifier to check if caller is owner
94     modifier onlyOwner() {
95         // If the first argument of 'require' evaluates to 'false', execution terminates and all
96         // changes to the state and to Ether balances are reverted.
97         // This used to consume all gas in old EVM versions, but not anymore.
98         // It is often a good idea to use 'require' to check if functions are called correctly.
99         // As a second argument, you can also provide an explanation about what went wrong.
100         require(msg.sender == owner, "Caller is not owner");
101         _;
102     }
103     
104     /**
105      * @dev Set contract deployer as owner
106      */
107     constructor() {
108         owner = msg.sender; // 'msg.sender' is sender of current call, contract deployer for a constructor
109         emit OwnerSet(address(0), owner);
110     }
111 
112     /**
113      * @dev Change owner
114      * @param newOwner address of new owner
115      */
116     function changeOwner(address newOwner) public onlyOwner {
117         emit OwnerSet(owner, newOwner);
118         owner = newOwner;
119     }
120 
121     /**
122      * @dev Return owner address 
123      * @return address of owner
124      */
125     function getOwner() external view returns (address) {
126         return owner;
127     }
128 }
129 
130 interface IKeysFarming {
131     function deposit(uint256 amount) external;
132 }
133 
134 interface ILoyalKeyDatabase {
135     function getLoyalKeyRank(address user) external view returns (uint256);
136 }
137 
138 /**
139  *
140  * KEYS Funding Receiver
141  * Will Allocate Funding To Different Sources
142  *
143  */
144 contract KEYSDistributor is Ownable {
145 
146     // KEYS
147     address public constant KEYS = 0xe0a189C975e4928222978A74517442239a0b86ff;
148 
149     // LoyalKey Database
150     ILoyalKeyDatabase public immutable loyalKey;
151 
152     // Max Int
153     uint256 private constant MAX_INT = type(uint256).max;
154 
155     // Farming & Stake Manager
156     address public farm;
157     address public stake;
158     
159     // allocation to farm + stake
160     uint256 public farmFee;
161     uint256 public stakeFee;
162 
163     // farm fee + stake fee
164     uint256 public feeDenom;
165 
166     // keys to distribute per second 0.385802469 => 1,000,000 keys per month (30 days)
167     uint256 public keysPerSecond = 385802469;
168 
169     // last second to distribute keys
170     uint256 public lastSecond;
171 
172     // minimum to distribute keys
173     uint256 public distributionMinimum = 1 * 10**9;
174 
175     // tracks total rewards
176     uint256 public totalRewards;
177     uint256 public totalBounties;
178 
179     // Bounty Percent Out Of 1,000
180     uint256 public constant Default_Bounty_Percent = 10; // 1%
181     uint256 private constant Bounty_Denom = 1000;
182 
183     mapping ( uint256 => uint256 ) public loyalKeyRankToBountyPercent;
184     
185     constructor(uint256 stakePercent, uint256 farmPercent, address loyalKeyDB) {
186 
187         loyalKey = ILoyalKeyDatabase(loyalKeyDB);
188     
189         farm = 0x810487135d29f35f06f1075b48D5978F1791d743;
190         stake = 0x73940d8E53b3cF00D92e3EBFfa33b4d54626306D;
191     
192         stakeFee = stakePercent;
193         farmFee = farmPercent;
194         feeDenom = stakePercent + farmPercent;
195 
196         loyalKeyRankToBountyPercent[0] = 10; // 1.0% for zero rank
197         loyalKeyRankToBountyPercent[1] = 16; // 1.6% for first rank
198         loyalKeyRankToBountyPercent[2] = 20; // 2.0% for second rank
199         loyalKeyRankToBountyPercent[3] = 24; // 2.4% for third rank
200         loyalKeyRankToBountyPercent[4] = 28; // 2.8% for forth rank
201         loyalKeyRankToBountyPercent[5] = 32; // 3.2% for fifth rank
202         loyalKeyRankToBountyPercent[6] = 36; // 3.6% for sixth rank
203         loyalKeyRankToBountyPercent[7] = 40; // 4.0% for seventh rank
204 
205         lastSecond = block.timestamp;
206         IERC20(KEYS).approve(farm, MAX_INT);
207     }
208     
209     // Events
210     event ResetRewardTimer();
211     event SetFarm(address farm);
212     event SetStaker(address staker);
213     event TokenWithdrawal(uint256 amount);
214     event SetKeysPerSecond(uint256 keysPerSec);
215     event SetDistributionMinimum(uint256 minKeys);
216     event SetBountyPercent(uint256 loyalKeyRank, uint256 newBounty);
217     event SetFundPercents(uint256 farmPercentage, uint256 stakePercent);
218 
219     function setKeysPerSecond(uint256 keysPerSec) external onlyOwner {
220         keysPerSecond = keysPerSec;
221         emit SetKeysPerSecond(keysPerSec);
222     }
223 
224     function setDistributionMinimum(uint256 minKeys) external onlyOwner {
225         distributionMinimum = minKeys;
226         emit SetDistributionMinimum(minKeys);
227     }
228     
229     function resetRewardTimer() external onlyOwner {
230         lastSecond = block.timestamp;
231         emit ResetRewardTimer();
232     }
233 
234     function setFarm(address _farm) external onlyOwner {
235         farm = _farm;
236         emit SetFarm(_farm);
237     }
238     
239     function setStake(address _stake) external onlyOwner {
240         stake = _stake;
241         emit SetStaker(_stake);
242     }
243 
244     function setBountyPercentForLoyalKeyRank(uint256 loyalKeyRank, uint256 newBountyPercent) external onlyOwner {
245         require(
246             newBountyPercent < Bounty_Denom,
247             'Bounty Too High'
248         );
249         loyalKeyRankToBountyPercent[loyalKeyRank] = newBountyPercent;
250         emit SetBountyPercent(loyalKeyRank, newBountyPercent);
251     }
252     
253     function setFundPercents(uint256 farmPercentage, uint256 stakePercentage) external onlyOwner {
254         farmFee = farmPercentage;
255         stakeFee = stakePercentage;
256         feeDenom = farmPercentage + stakePercentage;
257         emit SetFundPercents(farmPercentage, stakePercentage);
258     }
259     
260     function withdrawToken(address token) external onlyOwner {
261         uint256 bal = IERC20(token).balanceOf(address(this));
262         IERC20(token).transfer(msg.sender, bal);
263         emit TokenWithdrawal(bal);
264     }
265     
266     function reApprove() external onlyOwner {
267         IERC20(KEYS).approve(farm, MAX_INT);
268     }
269     
270     // ONLY APPROVED
271     
272     function distribute() external {
273         _distribute();
274     }
275 
276     receive() external payable {
277         (bool s,) = payable(KEYS).call{value: address(this).balance}("");
278         require(s, 'Failure on Token Purchase');
279         _distribute();    
280     }
281 
282     // INTERNAL
283     
284     function _distribute() internal {
285 
286         // pending keys for distribution
287         uint pending = pendingKeys();
288         require(
289             pending >= distributionMinimum,
290             'Min Distribution Not Met'
291         );
292 
293         // keys bounty
294         uint256 bounty = calculateBounty(msg.sender, pending);
295 
296         // update timer
297         lastSecond = block.timestamp;
298 
299         // send bounty to msg.sender
300         if (bounty > 0) {
301             IERC20(KEYS).transfer(msg.sender, bounty);
302             pending = pending - bounty;    
303         }
304 
305         // Increment Total Rewards And Bounties
306         unchecked {
307             totalRewards += pending;
308             totalBounties += bounty;
309         }
310         
311         // divy up pending keys
312         uint256 keysForFarming = (pending * farmFee) / feeDenom;
313         uint256 keysForStaking = pending - keysForFarming;
314 
315         // deposit keys in farm as rewards - we have already pre-approved for max int
316         IKeysFarming(farm).deposit(keysForFarming);
317 
318         // transfer rewards to Keys MAXI
319         IERC20(KEYS).transfer(stake, keysForStaking);    
320     }
321 
322 
323     // Read Functions
324 
325     function timeSince() public view returns (uint256) {
326         return lastSecond >= block.timestamp ? 0 : block.timestamp - lastSecond;
327     }
328 
329     function pendingKeys() public view returns (uint256) {
330         uint pending = timeSince() * keysPerSecond;
331         uint bal = balanceOf();
332         return pending < bal ? pending : bal;
333     }
334 
335     function balanceOf() public view returns (uint256) {
336         return IERC20(KEYS).balanceOf(address(this));
337     }
338 
339     function minBounty() public view returns (uint256) {
340         return currentBounty(address(0));
341     }
342 
343     function currentBounty(address user) public view returns (uint256) {
344         return ( pendingKeys() * getBountyPercent(user) ) / Bounty_Denom;
345     }
346 
347     function calculateBounty(address user, uint256 pending) public view returns (uint256) {
348         return ( pending * getBountyPercent(user) ) / Bounty_Denom;
349     }
350 
351     function getBountyPercent(address user) public view returns (uint256) {
352         uint percent = loyalKeyRankToBountyPercent[getLoyalKeyRank(user)];
353         return percent == 0 ? Default_Bounty_Percent : percent;
354     }
355 
356     function getLoyalKeyRank(address user) public view returns (uint256) {
357         if (user == address(0)) {
358             return 0;
359         }
360         return loyalKey.getLoyalKeyRank(user);
361     }
362 }