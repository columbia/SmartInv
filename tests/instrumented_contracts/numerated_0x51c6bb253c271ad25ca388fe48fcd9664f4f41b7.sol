1 //SPDX-License-Identifier: UNLICENSED
2 
3 pragma solidity 0.8.7;
4 
5 interface IERC20 {
6     function totalSupply() external view returns (uint256);
7     function balanceOf(address who) external view returns (uint256);
8     function allowance(address _owner, address spender) external view returns (uint256);
9     function transfer(address to, uint256 value) external returns (bool);
10     function approve(address spender, uint256 value) external returns (bool);
11     function transferFrom(address from, address to, uint256 value) external returns (bool);
12 
13     event Transfer(address indexed from, address indexed to, uint256 value);
14     event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 interface IERC20Metadata is IERC20 {
18     function name() external view returns (string memory);
19     function symbol() external view returns (string memory);
20     function decimals() external view returns (uint8);
21 }
22 
23 interface IERC721 {
24     event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
25     event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
26     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
27 
28     function balanceOf(address _owner) external view returns (uint256);
29     function ownerOf(uint256 _tokenId) external view returns (address);
30     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory data) external payable;
31     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;
32     function transferFrom(address _from, address _to, uint256 _tokenId) external payable;
33     function approve(address _approved, uint256 _tokenId) external payable;
34     function setApprovalForAll(address _operator, bool _approved) external;
35     function getApproved(uint256 _tokenId) external view returns (address);
36     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
37 }
38 
39 interface IERC721Metadata is IERC721 {
40     function name() external view returns (string memory);
41     function symbol() external view returns (string memory);
42     function tokenURI(uint256 tokenId) external view returns (string memory);
43 }
44 
45 interface ERC721TokenReceiver {
46     function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes memory _data) external returns(bytes4);
47 }
48 
49 contract NftStaking is ERC721TokenReceiver {
50 
51     enum StakeType {
52         LOTTERY, APY
53     }
54 
55     struct StakeSettings {
56         bool enabled;
57         uint256 timeBetweenRewards;
58         uint256 rewardPerToken;
59         uint256 minimumStakeTime;
60         uint256 startTime;
61         Stake[] stakings;
62     }
63 
64     struct StakeInfo {
65         StakeType stakeType;
66         bool enabled;
67         uint256 timeBetweenRewards;
68         uint256 rewardPerToken;
69         uint256 minimumStakeTime;
70     }
71 
72     struct Stake
73     {
74         address holder;
75         StakeType stakeType;
76         uint256 tokenId;
77         uint256 stakeTime;
78         uint256 lastClaimTime;
79         uint256 unstakeTime;
80     }
81 
82     struct StakedNftInfo
83     {
84         StakeType stakeType;
85         uint256 tokenId;
86         string uri;
87         uint256 stakeTime;
88         uint256 owed;
89         uint256 lastClaimed;
90         uint256 timeUntilNextReward;
91     }
92 
93     struct Map 
94     {
95         StakeType stakeType;
96         uint256 index;
97     }
98 
99     struct Lottery
100     {
101         bool running;
102         address token;
103         uint256 prize;
104         uint256 totalTickets;
105         address winner;
106     }
107 
108     address public owner;
109 
110     Lottery public currentLottery;
111     Lottery[] public lotteryWinners;
112 
113     uint256 private nonce;
114     mapping (address => uint256[]) private ownerStakings;
115     mapping (uint256 => Map) private indexMap;
116     mapping (StakeType => StakeSettings) private stakes;
117     uint256[] private lotteryMap;
118 
119     IERC721Metadata private _nftContract;
120     IERC20 private _rewardToken;
121 
122     modifier onlyOwner() {
123         require(msg.sender == owner, "can only be called by the contract owner");
124         _;
125     }
126 
127     modifier whenEnabled(StakeType t) {
128         require(stakes[t].enabled || msg.sender == owner, "staking not enabled");
129         _;
130     }
131 
132     constructor() {
133         owner = msg.sender;
134 
135         if (block.chainid == 1) {
136             _nftContract = IERC721Metadata(0x67536f6E4412663E2D3Ee7Ffc7b9F79440F8e42A);
137             _rewardToken = IERC20(0xBeC5938FD565CbEc72107eE39CdE1bc78049537d);
138         } else if (block.chainid == 3 || block.chainid == 4  || block.chainid == 97 || block.chainid == 5) {
139             _nftContract = IERC721Metadata(0xb48408795A879d7e64A356bB71a2a22adE7a75eF);
140             _rewardToken = IERC20(0x2891372D5c2727aC939BF111C45333735d537f09);
141         } else {
142             revert("Unknown Chain ID");
143         }
144 
145         stakes[StakeType.APY].enabled = true;
146         stakes[StakeType.APY].timeBetweenRewards = 60 * 60 * 24;
147         stakes[StakeType.APY].startTime = block.timestamp;
148         stakes[StakeType.APY].rewardPerToken = 1 * 10 ** 18;
149         stakes[StakeType.APY].minimumStakeTime = 60 * 60 * 24 * 7;
150 
151         stakes[StakeType.LOTTERY].enabled = true;
152         stakes[StakeType.LOTTERY].timeBetweenRewards = 60 * 60 * 24;
153         stakes[StakeType.LOTTERY].startTime = block.timestamp;
154         stakes[StakeType.LOTTERY].rewardPerToken = 1;
155         stakes[StakeType.LOTTERY].minimumStakeTime = 60 * 60 * 24;
156     }
157 
158     function info() external view returns (
159         StakedNftInfo[] memory stakedNfts,
160         Lottery memory lottery,
161         address rewardToken,
162         address nftContract,
163         StakeInfo memory apyStake,
164         StakeInfo memory lotteryStake
165     ) {
166         uint256 totalStaked = ownerStakings[msg.sender].length;
167         stakedNfts = new StakedNftInfo[](totalStaked);
168         for (uint256 i = 0; i < totalStaked; i ++) {
169 
170             Map storage m = indexMap[ownerStakings[msg.sender][i]];
171             Stake storage s = stakes[m.stakeType].stakings[m.index];
172 
173             (uint256 owed,) = rewardsOwed(m.stakeType, s);
174             stakedNfts[i] = StakedNftInfo(
175                 m.stakeType,
176                 s.tokenId,
177                 _nftContract.tokenURI(s.tokenId),
178                 s.stakeTime,
179                 owed,
180                 s.lastClaimTime,
181                 timeUntilReward(m.stakeType, s)
182              );
183         }
184 
185         lottery = currentLottery;
186 
187         rewardToken = address(_rewardToken);
188         nftContract = address(_nftContract);
189 
190         apyStake = StakeInfo(
191             StakeType.APY, 
192             stakes[StakeType.APY].enabled, 
193             stakes[StakeType.APY].timeBetweenRewards, 
194             stakes[StakeType.APY].rewardPerToken, 
195             stakes[StakeType.APY].minimumStakeTime
196         );
197 
198         lotteryStake = StakeInfo(
199             StakeType.LOTTERY, 
200             stakes[StakeType.LOTTERY].enabled, 
201             stakes[StakeType.LOTTERY].timeBetweenRewards, 
202             stakes[StakeType.LOTTERY].rewardPerToken, 
203             stakes[StakeType.LOTTERY].minimumStakeTime
204         );
205     }
206 
207     function stake(StakeType stakeType, uint256 tokenId) external whenEnabled(stakeType) {
208         require(_nftContract.getApproved(tokenId) == address(this), "Must approve this contract as an operator");
209         _nftContract.safeTransferFrom(msg.sender, address(this), tokenId);
210         Stake memory s = Stake(msg.sender, stakeType, tokenId, block.timestamp, block.timestamp, 0);
211         indexMap[tokenId] = Map(stakeType, stakes[stakeType].stakings.length);
212         if (stakeType == StakeType.LOTTERY) {
213             lotteryMap.push(stakes[stakeType].stakings.length);
214         }
215         stakes[stakeType].stakings.push(s);
216         ownerStakings[msg.sender].push(tokenId);
217     }
218 
219     function unstake(uint256 tokenId) external {
220 
221         Map storage m = indexMap[tokenId];
222         Stake storage s = stakes[m.stakeType].stakings[m.index];
223 
224         require(s.unstakeTime == 0, "This NFT has already been unstaked");
225         require(s.holder == msg.sender || msg.sender == owner, "You do not own this token");
226 
227         if (m.stakeType == StakeType.APY && stakes[m.stakeType].enabled) {
228             claimWalletRewards(s.holder);
229         }
230 
231         _nftContract.safeTransferFrom(address(this), s.holder, tokenId);
232         s.unstakeTime = block.timestamp;
233         removeOwnerStaking(s.holder, tokenId);
234     }
235  
236     function claimRewards() external whenEnabled(StakeType.APY) {
237         claimWalletRewards(msg.sender);
238     }
239 
240     function pastLotteries() external view returns (uint256) {
241         return lotteryWinners.length;
242     }
243 
244 
245     // Admin Methods
246 
247     function removeEth() external onlyOwner {
248         uint256 balance = address(this).balance;
249         payable(owner).transfer(balance);
250     }
251     
252     function removeTokens(address token) external onlyOwner {
253         uint256 balance = IERC20(token).balanceOf(address(this));
254         IERC20(token).transfer(owner, balance);
255     }
256 
257     function createLottery(address newToken, uint256 newPrize) external onlyOwner {   
258         require(currentLottery.running == false, "Already an active lottery");
259         currentLottery = Lottery(true, newToken, newPrize, 0, address(0));
260         stakes[StakeType.LOTTERY].startTime = block.timestamp;
261     }
262 
263     function drawLottery() external onlyOwner {   
264         IERC20 token = IERC20(currentLottery.token);
265 
266         uint256 totalTickets;
267         uint256[] memory currentLotteryMap = lotteryMap;
268         delete lotteryMap;
269 
270         for (uint256 i = 0; i < currentLotteryMap.length; i++) {
271             (uint256 owed,) = rewardsOwed(StakeType.LOTTERY, stakes[StakeType.LOTTERY].stakings[currentLotteryMap[i]]);
272             totalTickets += owed;
273             if (stakes[StakeType.LOTTERY].stakings[currentLotteryMap[i]].unstakeTime > 0) {
274                 lotteryMap.push(currentLotteryMap[i]);
275             }
276         }
277 
278         if (totalTickets > 0) {
279             require(token.balanceOf(address(this)) >= currentLottery.prize, "Not enough tokens to pay winner");
280 
281             uint256 roll = requestRandomWords() % totalTickets;
282             uint256 current;
283             
284             for (uint256 i = 0; i < currentLotteryMap.length; i++) {
285                 (uint256 owed,) = rewardsOwed(StakeType.LOTTERY, stakes[StakeType.LOTTERY].stakings[currentLotteryMap[i]]);
286                 current += owed;
287 
288                 if (owed > 0 && current >= roll) {
289                     currentLottery.winner = stakes[StakeType.LOTTERY].stakings[currentLotteryMap[i]].holder;
290                     currentLottery.totalTickets = totalTickets;
291                 }
292             }
293 
294             require(currentLottery.winner != address(0), "Unable to find winner"); 
295             token.transfer(currentLottery.winner, currentLottery.prize);
296         }
297 
298         lotteryWinners.push(currentLottery);
299         currentLottery = Lottery(false, address(0), 0, 0, address(0));
300     }
301 
302     function forceUnstake(uint256 tokenId) external onlyOwner {
303         Map storage m = indexMap[tokenId];
304         Stake storage s = stakes[m.stakeType].stakings[m.index];
305         _nftContract.safeTransferFrom(address(this), s.holder, tokenId);
306     }
307 
308     function setOwner(address who) external onlyOwner {
309         require(who != address(0), "cannot be zero address");
310         owner = who;
311     }
312 
313     function setEnabled(StakeType stakeType, bool on) external onlyOwner {
314         stakes[stakeType].enabled = on;
315     }
316 
317     function configureStake(StakeType stakeType, uint256 _timeBetweenRewards, uint256 _rewardPerToken, uint256 _minimumStakeTime) external onlyOwner {
318         stakes[stakeType].timeBetweenRewards = _timeBetweenRewards;
319         stakes[stakeType].rewardPerToken = _rewardPerToken;
320         stakes[stakeType].minimumStakeTime = _minimumStakeTime;
321     }
322 
323 
324     // Private Methods
325 
326     function removeOwnerStaking(address holder, uint256 tokenId) private {
327         bool found;
328         uint256 index = 0;
329         for (index; index < ownerStakings[holder].length; index++) {
330             if (ownerStakings[holder][index] == tokenId) {
331                 found = true;
332                 break;
333             } 
334         }
335 
336         if (found) {
337             if (ownerStakings[holder].length > 1) {
338                 ownerStakings[holder][index] = ownerStakings[holder][ownerStakings[holder].length-1];
339             }
340             ownerStakings[holder].pop();
341         }
342     }
343 
344     function claimWalletRewards(address wallet) private {
345         uint256 totalOwed;
346         
347         for (uint256 i = 0; i < ownerStakings[wallet].length; i ++) {
348             
349             Map storage m = indexMap[ownerStakings[wallet][i]];
350             if (m.stakeType == StakeType.APY) {
351                 (uint256 owed, uint256 time) = rewardsOwed(m.stakeType, stakes[m.stakeType].stakings[m.index]);
352                 if (owed > 0) {
353                     totalOwed += owed;
354                     stakes[m.stakeType].stakings[m.index].lastClaimTime = stakes[m.stakeType].stakings[m.index].lastClaimTime + time;
355                 }
356             }
357         }
358 
359         if (totalOwed > 0) {
360             _rewardToken.transfer(wallet, totalOwed);
361         }
362     }
363 
364     function timeUntilReward(StakeType t, Stake storage stakedToken) private view returns (uint256) {
365 
366         if (block.timestamp - stakedToken.stakeTime < stakes[t].minimumStakeTime) {
367             return stakes[t].minimumStakeTime - (block.timestamp - stakedToken.stakeTime);
368         }
369 
370         uint256 lastClaimTime = stakedToken.stakeTime;
371         if (stakes[t].startTime > lastClaimTime) {
372             lastClaimTime = stakes[t].startTime;
373         } else if (stakedToken.lastClaimTime > lastClaimTime) {
374             lastClaimTime = stakedToken.lastClaimTime;
375         }
376 
377         if (block.timestamp - lastClaimTime >= stakes[t].timeBetweenRewards) {
378             return stakes[t].timeBetweenRewards - ((block.timestamp - lastClaimTime) % stakes[t].timeBetweenRewards);
379         }
380 
381         return stakes[t].timeBetweenRewards - (block.timestamp - lastClaimTime);
382     }
383 
384     function rewardsOwed(StakeType t, Stake storage stakedToken) private view returns (uint256, uint256) {
385 
386         if (t == StakeType.LOTTERY && currentLottery.running == false) {
387             return (0, 0);
388         }
389 
390         uint256 unstakeTime = block.timestamp;
391         if (stakedToken.unstakeTime > 0) {
392             unstakeTime = stakedToken.unstakeTime;
393         }
394 
395         if (unstakeTime - stakedToken.stakeTime >= stakes[t].minimumStakeTime) {
396             uint256 lastClaimTime = stakedToken.stakeTime;
397             if (stakes[t].startTime > lastClaimTime) {
398                 lastClaimTime = stakes[t].startTime;
399             } else if (stakedToken.lastClaimTime > lastClaimTime) {
400                 lastClaimTime = stakedToken.lastClaimTime;
401             }
402 
403             if (unstakeTime - lastClaimTime >= stakes[t].timeBetweenRewards) {
404                 uint256 multiplesOwed = (unstakeTime - lastClaimTime) / stakes[t].timeBetweenRewards;
405                 return (
406                     multiplesOwed * stakes[t].rewardPerToken,
407                     multiplesOwed * stakes[t].timeBetweenRewards
408                 );
409             }
410         }
411 
412         return (0, 0);
413     }
414 
415     function requestRandomWords() private returns (uint256) {
416         nonce += 1;
417         return uint(keccak256(abi.encodePacked(nonce, msg.sender, blockhash(block.number - 1))));
418     }
419 
420     function onERC721Received(address, address, uint256, bytes memory) public pure override returns(bytes4) {
421         return bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"));
422     }
423 
424 }