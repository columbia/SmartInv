1 pragma solidity ^0.4.18;
2 
3 contract FullERC20 {
4   event Transfer(address indexed from, address indexed to, uint256 value);
5   event Approval(address indexed owner, address indexed spender, uint256 value);
6   
7   uint256 public totalSupply;
8   uint8 public decimals;
9 
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   function allowance(address owner, address spender) public view returns (uint256);
13   function transferFrom(address from, address to, uint256 value) public returns (bool);
14   function approve(address spender, uint256 value) public returns (bool);
15 }
16 
17 contract RewardDistributable {
18     event TokensRewarded(address indexed player, address rewardToken, uint rewards, address requester, uint gameId, uint block);
19     event ReferralRewarded(address indexed referrer, address indexed player, address rewardToken, uint rewards, uint gameId, uint block);
20     event ReferralRegistered(address indexed player, address indexed referrer);
21 
22     /// @dev Calculates and transfers the rewards to the player.
23     function transferRewards(address player, uint entryAmount, uint gameId) public;
24 
25     /// @dev Returns the total number of tokens, across all approvals.
26     function getTotalTokens(address tokenAddress) public constant returns(uint);
27 
28     /// @dev Returns the total number of supported reward token contracts.
29     function getRewardTokenCount() public constant returns(uint);
30 
31     /// @dev Gets the total number of approvers.
32     function getTotalApprovers() public constant returns(uint);
33 
34     /// @dev Gets the reward rate inclusive of referral bonus.
35     function getRewardRate(address player, address tokenAddress) public constant returns(uint);
36 
37     /// @dev Adds a requester to the whitelist.
38     /// @param requester The address of a contract which will request reward transfers
39     function addRequester(address requester) public;
40 
41     /// @dev Removes a requester from the whitelist.
42     /// @param requester The address of a contract which will request reward transfers
43     function removeRequester(address requester) public;
44 
45     /// @dev Adds a approver address.  Approval happens with the token contract.
46     /// @param approver The approver address to add to the pool.
47     function addApprover(address approver) public;
48 
49     /// @dev Removes an approver address. 
50     /// @param approver The approver address to remove from the pool.
51     function removeApprover(address approver) public;
52 
53     /// @dev Updates the reward rate
54     function updateRewardRate(address tokenAddress, uint newRewardRate) public;
55 
56     /// @dev Updates the token address of the payment type.
57     function addRewardToken(address tokenAddress, uint newRewardRate) public;
58 
59     /// @dev Updates the token address of the payment type.
60     function removeRewardToken(address tokenAddress) public;
61 
62     /// @dev Updates the referral bonus rate
63     function updateReferralBonusRate(uint newReferralBonusRate) public;
64 
65     /// @dev Registers the player with the given referral code
66     /// @param player The address of the player
67     /// @param referrer The address of the referrer
68     function registerReferral(address player, address referrer) public;
69 
70     /// @dev Transfers any tokens to the owner
71     function destroyRewards() public;
72 }
73 
74 library SafeMath {
75   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
76     if (a == 0) {
77       return 0;
78     }
79     uint256 c = a * b;
80     assert(c / a == b);
81     return c;
82   }
83 
84   function div(uint256 a, uint256 b) internal pure returns (uint256) {
85     // assert(b > 0); // Solidity automatically throws when dividing by 0
86     uint256 c = a / b;
87     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
88     return c;
89   }
90 
91   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
92     assert(b <= a);
93     return a - b;
94   }
95 
96   function add(uint256 a, uint256 b) internal pure returns (uint256) {
97     uint256 c = a + b;
98     assert(c >= a);
99     return c;
100   }
101 }
102 
103 contract Ownable {
104   address public owner;
105 
106 
107   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
108 
109 
110   /**
111    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
112    * account.
113    */
114   function Ownable() public {
115     owner = msg.sender;
116   }
117 
118 
119   /**
120    * @dev Throws if called by any account other than the owner.
121    */
122   modifier onlyOwner() {
123     require(msg.sender == owner);
124     _;
125   }
126 
127 
128   /**
129    * @dev Allows the current owner to transfer control of the contract to a newOwner.
130    * @param newOwner The address to transfer ownership to.
131    */
132   function transferOwnership(address newOwner) public onlyOwner {
133     require(newOwner != address(0));
134     OwnershipTransferred(owner, newOwner);
135     owner = newOwner;
136   }
137 
138 }
139 
140 contract RewardDistributor is RewardDistributable, Ownable {
141     using SafeMath for uint256;
142 
143     struct RewardSource {
144         address rewardTokenAddress;
145         uint96 rewardRate; // 1 token for every reward rate (in wei)
146     }
147 
148     RewardSource[] public rewardSources;
149     mapping(address => bool) public approvedRewardSources;
150     
151     mapping(address => bool) public requesters; // distribution requesters
152     address[] public approvers; // distribution approvers
153 
154     mapping(address => address) public referrers; // player -> referrer
155     
156     uint public referralBonusRate;
157 
158     modifier onlyRequesters() {
159         require(requesters[msg.sender] || (msg.sender == owner));
160         _;
161     }
162 
163     modifier validRewardSource(address tokenAddress) {
164         require(approvedRewardSources[tokenAddress]);
165         _;        
166     }
167 
168     function RewardDistributor(uint256 rewardRate, address tokenAddress) public {
169         referralBonusRate = 10;
170         addRewardToken(tokenAddress, rewardRate);
171     }
172 
173     /// @dev Calculates and transfers the rewards to the player.
174     function transferRewards(address player, uint entryAmount, uint gameId) public onlyRequesters {
175         // loop through all reward tokens, since we never really expect more than 2, this should be ok wrt gas
176         for (uint i = 0; i < rewardSources.length; i++) {
177             transferRewardsInternal(player, entryAmount, gameId, rewardSources[i]);
178         }
179     }
180 
181     /// @dev Returns the total number of tokens, across all approvals.
182     function getTotalTokens(address tokenAddress) public constant validRewardSource(tokenAddress) returns(uint) {
183         for (uint j = 0; j < rewardSources.length; j++) {
184             if (rewardSources[j].rewardTokenAddress == tokenAddress) {
185                 FullERC20 rewardToken = FullERC20(rewardSources[j].rewardTokenAddress);
186                 uint total = rewardToken.balanceOf(this);
187             
188                 for (uint i = 0; i < approvers.length; i++) {
189                     address approver = approvers[i];
190                     uint allowance = rewardToken.allowance(approver, this);
191                     total = total.add(allowance);
192                 }
193 
194                 return total;
195             }
196         }
197 
198         return 0;
199     }
200 
201     /// @dev Get reward token count
202     function getRewardTokenCount() public constant returns(uint) {
203         return rewardSources.length;
204     }
205 
206 
207     /// @dev Gets the total number of approvers.
208     function getTotalApprovers() public constant returns(uint) {
209         return approvers.length;
210     }
211 
212     /// @dev Gets the reward rate inclusive of bonus.
213     /// This is meant to be used by dividing the total purchase amount in wei by this amount.
214     function getRewardRate(address player, address tokenAddress) public constant validRewardSource(tokenAddress) returns(uint) {
215         for (uint j = 0; j < rewardSources.length; j++) {
216             if (rewardSources[j].rewardTokenAddress == tokenAddress) {
217                 RewardSource storage rewardSource = rewardSources[j];
218                 uint256 rewardRate = rewardSource.rewardRate;
219                 uint bonusRate = referrers[player] == address(0) ? 0 : referralBonusRate;
220                 return rewardRate.mul(100).div(100 + bonusRate);
221             }
222         }
223 
224         return 0;
225     }
226 
227     /// @dev Adds a requester to the whitelist.
228     /// @param requester The address of a contract which will request reward transfers
229     function addRequester(address requester) public onlyOwner {
230         require(!requesters[requester]);    
231         requesters[requester] = true;
232     }
233 
234     /// @dev Removes a requester from the whitelist.
235     /// @param requester The address of a contract which will request reward transfers
236     function removeRequester(address requester) public onlyOwner {
237         require(requesters[requester]);
238         requesters[requester] = false;
239     }
240 
241     /// @dev Adds a approver address.  Approval happens with the token contract.
242     /// @param approver The approver address to add to the pool.
243     function addApprover(address approver) public onlyOwner {
244         approvers.push(approver);
245     }
246 
247     /// @dev Removes an approver address. 
248     /// @param approver The approver address to remove from the pool.
249     function removeApprover(address approver) public onlyOwner {
250         uint good = 0;
251         for (uint i = 0; i < approvers.length; i = i.add(1)) {
252             bool isValid = approvers[i] != approver;
253             if (isValid) {
254                 if (good != i) {
255                     approvers[good] = approvers[i];            
256                 }
257               
258                 good = good.add(1);
259             } 
260         }
261 
262         // TODO Delete the previous entries.
263         approvers.length = good;
264     }
265 
266     /// @dev Updates the reward rate
267     function updateRewardRate(address tokenAddress, uint newRewardRate) public onlyOwner {
268         require(newRewardRate > 0);
269         require(tokenAddress != address(0));
270 
271         for (uint i = 0; i < rewardSources.length; i++) {
272             if (rewardSources[i].rewardTokenAddress == tokenAddress) {
273                 rewardSources[i].rewardRate = uint96(newRewardRate);
274                 return;
275             }
276         }
277     }
278 
279     /// @dev Adds the token address of the payment type.
280     function addRewardToken(address tokenAddress, uint newRewardRate) public onlyOwner {
281         require(tokenAddress != address(0));
282         require(!approvedRewardSources[tokenAddress]);
283         
284         rewardSources.push(RewardSource(tokenAddress, uint96(newRewardRate)));
285         approvedRewardSources[tokenAddress] = true;
286     }
287 
288     /// @dev Removes the given token address from the approved sources.
289     /// @param tokenAddress the address of the token
290     function removeRewardToken(address tokenAddress) public onlyOwner {
291         require(tokenAddress != address(0));
292         require(approvedRewardSources[tokenAddress]);
293 
294         approvedRewardSources[tokenAddress] = false;
295 
296         // Shifting costs significant gas with every write.
297         // UI should update the reward sources after this function call.
298         for (uint i = 0; i < rewardSources.length; i++) {
299             if (rewardSources[i].rewardTokenAddress == tokenAddress) {
300                 rewardSources[i] = rewardSources[rewardSources.length - 1];
301                 delete rewardSources[rewardSources.length - 1];
302                 rewardSources.length--;
303                 return;
304             }
305         }
306     }
307 
308     /// @dev Transfers any tokens to the owner
309     function destroyRewards() public onlyOwner {
310         for (uint i = 0; i < rewardSources.length; i++) {
311             FullERC20 rewardToken = FullERC20(rewardSources[i].rewardTokenAddress);
312             uint tokenBalance = rewardToken.balanceOf(this);
313             assert(rewardToken.transfer(owner, tokenBalance));
314             approvedRewardSources[rewardSources[i].rewardTokenAddress] = false;
315         }
316 
317         rewardSources.length = 0;
318     }
319 
320     /// @dev Updates the referral bonus percentage
321     function updateReferralBonusRate(uint newReferralBonusRate) public onlyOwner {
322         require(newReferralBonusRate < 100);
323         referralBonusRate = newReferralBonusRate;
324     }
325 
326     /// @dev Registers the player with the given referral code
327     /// @param player The address of the player
328     /// @param referrer The address of the referrer
329     function registerReferral(address player, address referrer) public onlyRequesters {
330         if (referrer != address(0) && player != referrer) {
331             referrers[player] = referrer;
332             ReferralRegistered(player, referrer);
333         }
334     }
335 
336     /// @dev Transfers the rewards to the player for the provided reward source
337     function transferRewardsInternal(address player, uint entryAmount, uint gameId, RewardSource storage rewardSource) internal {
338         if (rewardSource.rewardTokenAddress == address(0)) {
339             return;
340         }
341         
342         FullERC20 rewardToken = FullERC20(rewardSource.rewardTokenAddress);
343         uint rewards = entryAmount.div(rewardSource.rewardRate).mul(10**uint256(rewardToken.decimals()));
344         if (rewards == 0) {
345             return;
346         }
347 
348         address referrer = referrers[player];
349         uint referralBonus = referrer == address(0) ? 0 : rewards.mul(referralBonusRate).div(100);
350         uint totalRewards = referralBonus.mul(2).add(rewards);
351         uint playerRewards = rewards.add(referralBonus);
352 
353         // First check if the contract itself has enough tokens to reward.
354         if (rewardToken.balanceOf(this) >= totalRewards) {
355             assert(rewardToken.transfer(player, playerRewards));
356             TokensRewarded(player, rewardToken, playerRewards, msg.sender, gameId, block.number);
357 
358             if (referralBonus > 0) {
359                 assert(rewardToken.transfer(referrer, referralBonus));
360                 ReferralRewarded(referrer, rewardToken, player, referralBonus, gameId, block.number);
361             }
362             
363             return;
364         }
365 
366         // Iterate through the approvers to find first with enough rewards and successful transfer
367         for (uint i = 0; i < approvers.length; i++) {
368             address approver = approvers[i];
369             uint allowance = rewardToken.allowance(approver, this);
370             if (allowance >= totalRewards) {
371                 assert(rewardToken.transferFrom(approver, player, playerRewards));
372                 TokensRewarded(player, rewardToken, playerRewards, msg.sender, gameId, block.number);
373                 if (referralBonus > 0) {
374                     assert(rewardToken.transfer(referrer, referralBonus));
375                     ReferralRewarded(referrer, rewardToken, player, referralBonus, gameId, block.number);
376                 }
377                 return;
378             }
379         }
380     }
381 }