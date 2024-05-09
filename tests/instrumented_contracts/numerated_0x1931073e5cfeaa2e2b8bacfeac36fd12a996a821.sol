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
49 contract OgStake is ERC721TokenReceiver {
50 
51 
52     bool enabled;
53     uint256 timeBetweenRewards;
54     uint256 rewardPerToken;
55     uint256 minimumStakeTime;
56     uint256 startTime;
57     Stake[] stakings;
58 
59     struct StakeInfo {
60         bool enabled;
61         uint256 timeBetweenRewards;
62         uint256 rewardPerToken;
63         uint256 minimumStakeTime;
64     }
65 
66     struct Stake
67     {
68         address holder;
69         uint256 tokenId;
70         uint256 stakeTime;
71         uint256 lastClaimTime;
72         uint256 unstakeTime;
73     }
74 
75     struct StakedNftInfo
76     {
77         uint256 tokenId;
78         string uri;
79         uint256 stakeTime;
80         uint256 owed;
81         uint256 lastClaimed;
82         uint256 timeUntilNextReward;
83     }
84 
85     address public owner;
86     uint256 private nonce;
87     mapping (address => uint256[]) private ownerStakings;
88     mapping (uint256 => uint256) private indexMap;
89     
90     IERC721Metadata private _nftContract;
91     IERC20 private _rewardToken;
92 
93     modifier onlyOwner() {
94         require(msg.sender == owner, "can only be called by the contract owner");
95         _;
96     }
97 
98     modifier whenEnabled() {
99         require(enabled || msg.sender == owner, "staking not enabled");
100         _;
101     }
102 
103     constructor() {
104         owner = msg.sender;
105 
106         if (block.chainid == 1) {
107             _nftContract = IERC721Metadata(0x5b9D7Ee3Ba252c41a07C2D6Ec799eFF8858bf117);
108             _rewardToken = IERC20(0xBeC5938FD565CbEc72107eE39CdE1bc78049537d);
109         } else if (block.chainid == 3 || block.chainid == 4  || block.chainid == 97 || block.chainid == 5) {
110             _nftContract = IERC721Metadata(0xb48408795A879d7e64A356bB71a2a22adE7a75eF);
111             _rewardToken = IERC20(0x2891372D5c2727aC939BF111C45333735d537f09);
112         } else {
113             revert("Unknown Chain ID");
114         }
115 
116         enabled = true;
117         timeBetweenRewards = 1 days;
118         startTime = block.timestamp;
119         rewardPerToken = 8 * 10 ** 18;
120         minimumStakeTime = 7 days;
121 
122     }
123 
124     function info() external view returns (
125         StakedNftInfo[] memory stakedNfts,
126         address rewardToken,
127         address nftContract,
128         StakeInfo memory settings
129     ) {
130         uint256 totalStaked = ownerStakings[msg.sender].length;
131         stakedNfts = new StakedNftInfo[](totalStaked);
132         for (uint256 i = 0; i < totalStaked; i ++) {
133 
134             uint256 index = indexMap[ownerStakings[msg.sender][i]];
135             Stake storage s = stakings[index];
136 
137             (uint256 owed,) = rewardsOwed(s);
138             stakedNfts[i] = StakedNftInfo(
139                 s.tokenId,
140                 _nftContract.tokenURI(s.tokenId),
141                 s.stakeTime,
142                 owed,
143                 s.lastClaimTime,
144                 timeUntilReward(s)
145              );
146         }
147 
148         rewardToken = address(_rewardToken);
149         nftContract = address(_nftContract);
150 
151         settings = StakeInfo(
152             enabled, 
153             timeBetweenRewards, 
154             rewardPerToken, 
155             minimumStakeTime
156         );
157     }
158 
159     function stake(uint256 tokenId) external whenEnabled() {
160         require(_nftContract.getApproved(tokenId) == address(this), "Must approve this contract as an operator");
161         _nftContract.safeTransferFrom(msg.sender, address(this), tokenId);
162         Stake memory s = Stake(msg.sender, tokenId, block.timestamp, block.timestamp, 0);
163         indexMap[tokenId] = stakings.length;
164         stakings.push(s);
165         ownerStakings[msg.sender].push(tokenId);
166     }
167 
168     function unstake(uint256 tokenId) external {
169 
170         uint256 index = indexMap[tokenId];
171         Stake storage s = stakings[index];
172 
173         require(s.unstakeTime == 0, "This NFT has already been unstaked");
174         require(s.holder == msg.sender || msg.sender == owner, "You do not own this token");
175 
176         if (enabled) {
177             claimWalletRewards(s.holder);
178         }
179 
180         _nftContract.safeTransferFrom(address(this), s.holder, tokenId);
181         s.unstakeTime = block.timestamp;
182         removeOwnerStaking(s.holder, tokenId);
183     }
184  
185     function claimRewards() external whenEnabled() {
186         claimWalletRewards(msg.sender);
187     }
188 
189 
190     // Admin Methods
191 
192     function removeEth() external onlyOwner {
193         uint256 balance = address(this).balance;
194         payable(owner).transfer(balance);
195     }
196     
197     function removeTokens(address token) external onlyOwner {
198         uint256 balance = IERC20(token).balanceOf(address(this));
199         IERC20(token).transfer(owner, balance);
200     }
201 
202     function forceUnstake(uint256 tokenId) external onlyOwner {
203         uint256 index = indexMap[tokenId];
204         Stake storage s = stakings[index];
205         _nftContract.safeTransferFrom(address(this), s.holder, tokenId);
206     }
207 
208     function setOwner(address who) external onlyOwner {
209         require(who != address(0), "cannot be zero address");
210         owner = who;
211     }
212 
213     function setEnabled(bool on) external onlyOwner {
214         enabled = on;
215     }
216 
217     function configureStake(uint256 _timeBetweenRewards, uint256 _rewardPerToken, uint256 _minimumStakeTime) external onlyOwner {
218         timeBetweenRewards = _timeBetweenRewards;
219         rewardPerToken = _rewardPerToken;
220         minimumStakeTime = _minimumStakeTime;
221     }
222 
223 
224     // Private Methods
225 
226     function removeOwnerStaking(address holder, uint256 tokenId) private {
227         bool found;
228         uint256 index = 0;
229         for (index; index < ownerStakings[holder].length; index++) {
230             if (ownerStakings[holder][index] == tokenId) {
231                 found = true;
232                 break;
233             } 
234         }
235 
236         if (found) {
237             if (ownerStakings[holder].length > 1) {
238                 ownerStakings[holder][index] = ownerStakings[holder][ownerStakings[holder].length-1];
239             }
240             ownerStakings[holder].pop();
241         }
242     }
243 
244     function claimWalletRewards(address wallet) private {
245         uint256 totalOwed;
246         
247         for (uint256 i = 0; i < ownerStakings[wallet].length; i ++) {
248             
249             uint256 index = indexMap[ownerStakings[wallet][i]];
250             (uint256 owed, uint256 time) = rewardsOwed(stakings[index]);
251             if (owed > 0) {
252                 totalOwed += owed;
253                 stakings[index].lastClaimTime = stakings[index].lastClaimTime + time;
254             }
255         }
256 
257         if (totalOwed > 0) {
258             _rewardToken.transfer(wallet, totalOwed);
259         }
260     }
261 
262     function timeUntilReward(Stake storage stakedToken) private view returns (uint256) {
263 
264         if (block.timestamp - stakedToken.stakeTime < minimumStakeTime) {
265             return minimumStakeTime - (block.timestamp - stakedToken.stakeTime);
266         }
267 
268         uint256 lastClaimTime = stakedToken.stakeTime;
269         if (startTime > lastClaimTime) {
270             lastClaimTime = startTime;
271         } else if (stakedToken.lastClaimTime > lastClaimTime) {
272             lastClaimTime = stakedToken.lastClaimTime;
273         }
274 
275         if (block.timestamp - lastClaimTime >= timeBetweenRewards) {
276             return timeBetweenRewards - ((block.timestamp - lastClaimTime) % timeBetweenRewards);
277         }
278 
279         return timeBetweenRewards - (block.timestamp - lastClaimTime);
280     }
281 
282     function rewardsOwed(Stake storage stakedToken) private view returns (uint256, uint256) {
283 
284         uint256 unstakeTime = block.timestamp;
285         if (stakedToken.unstakeTime > 0) {
286             unstakeTime = stakedToken.unstakeTime;
287         }
288 
289         if (unstakeTime - stakedToken.stakeTime >= minimumStakeTime) {
290             uint256 lastClaimTime = stakedToken.stakeTime;
291             if (startTime > lastClaimTime) {
292                 lastClaimTime = startTime;
293             } else if (stakedToken.lastClaimTime > lastClaimTime) {
294                 lastClaimTime = stakedToken.lastClaimTime;
295             }
296 
297             if (unstakeTime - lastClaimTime >= timeBetweenRewards) {
298                 uint256 multiplesOwed = (unstakeTime - lastClaimTime) / timeBetweenRewards;
299                 return (
300                     multiplesOwed * rewardPerToken,
301                     multiplesOwed * timeBetweenRewards
302                 );
303             }
304         }
305 
306         return (0, 0);
307     }
308 
309     function onERC721Received(address, address, uint256, bytes memory) public pure override returns(bytes4) {
310         return bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"));
311     }
312 
313 }