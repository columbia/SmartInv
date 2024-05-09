1 /*
2 https://www.stiltonmusk.com
3 https://t.me/stiltonmusk
4 */
5 
6 
7 
8 
9 
10 
11 
12 
13 
14 // File: contracts/Ownable.sol
15 
16 abstract contract Ownable {
17     address _owner;
18 
19     modifier onlyOwner() {
20         require(msg.sender == _owner);
21         _;
22     }
23 
24     constructor() {
25         _owner = msg.sender;
26     }
27 
28     function transferOwnership(address newOwner) external onlyOwner {
29         _owner = newOwner;
30     }
31 }
32 
33 // File: contracts/Stake.sol
34 
35 pragma solidity ^0.8.7;
36 
37 struct Stake {
38     uint256 scores; // scores of the stake
39     uint256 lastGrantIntervalNumber; // interval number, when last granted reward
40     uint256[] nft;
41 }
42 
43 // File: contracts/IERC721.sol
44 
45 pragma solidity ^0.8.7;
46 
47 interface IERC721 {
48 
49     function balanceOf(address owner) external view returns (uint256 balance);
50     function ownerOf(uint256 tokenId) external view returns (address owner);
51 
52     /**
53      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
54      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
55      *
56      * Requirements:
57      *
58      * - `from` cannot be the zero address.
59      * - `to` cannot be the zero address.
60      * - `tokenId` token must exist and be owned by `from`.
61      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
62      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
63      *
64      * Emits a {Transfer} event.
65      */
66     function safeTransferFrom(
67         address from,
68         address to,
69         uint256 tokenId
70     ) external;
71 
72     /**
73      * @dev Transfers `tokenId` token from `from` to `to`.
74      *
75      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
76      *
77      * Requirements:
78      *
79      * - `from` cannot be the zero address.
80      * - `to` cannot be the zero address.
81      * - `tokenId` token must be owned by `from`.
82      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
83      *
84      * Emits a {Transfer} event.
85      */
86     function transferFrom(
87         address from,
88         address to,
89         uint256 tokenId
90     ) external;
91 }
92 // File: contracts/IERC20.sol
93 
94 interface IERC20 {
95     function totalSupply() external view returns (uint256);
96 
97     function balanceOf(address account) external view returns (uint256);
98 
99     function transfer(address recipient, uint256 amount)
100         external
101         returns (bool);
102 
103     function allowance(address owner, address spender)
104         external
105         view
106         returns (uint256);
107 
108     function approve(address spender, uint256 amount) external returns (bool);
109 
110     function transferFrom(
111         address sender,
112         address recipient,
113         uint256 amount
114     ) external returns (bool);
115 
116     event Transfer(address indexed from, address indexed to, uint256 value);
117     event Approval(
118         address indexed owner,
119         address indexed spender,
120         uint256 value
121     );
122 }
123 // File: contracts/RewardPoolBase.sol
124 
125 pragma solidity ^0.8.7;
126 
127 //import "hardhat/console.sol";
128 
129 
130 
131 
132 
133 abstract contract RewardPoolBase is Ownable {
134     mapping(address => Stake) internal staks; // token staks by account
135     uint256 public staksScoresSum; // total staks scores
136     uint256 public claimStaksScoresSum; // total staked scores, in use for claim reward pool
137     uint256 public claimRewardPool; // reward pool to claim
138     uint256 public claimRewardPoolStartCount; // reward pool to claim on start
139     uint256 public nextIntervalTime; // time of new interval
140     uint256 public intervalMinutes = 10080; // interval length
141     uint256 public intervalNumber; // number of current interval (if pool is not started the value is 0)
142     uint256 public totalRewardClaimed; // total, that claimed by users
143     bool public enabled; // if true, than pool is enabled
144 
145     function start() external onlyOwner {
146         require(intervalNumber == 0, "reward pool alredy started");
147         beforeStart();
148         nextIntervalTime = block.timestamp + intervalMinutes * 1 minutes;
149         intervalNumber = 1;
150         claimRewardPoolStartCount = claimRewardPool;
151         enabled = true;
152     }
153 
154     function setIntervalTimer(uint256 newIntervalMinutes) external onlyOwner {
155         intervalMinutes = newIntervalMinutes;
156     }
157 
158     function setIsEnabled(bool newEnabled) external onlyOwner {
159         enabled = newEnabled;
160     }
161 
162     function nextIntervalLapsedTime() external view returns (uint256) {
163         if (block.timestamp >= nextIntervalTime) return 0;
164         return nextIntervalTime - block.timestamp;
165     }
166 
167     function getRewardCount(address account) public view returns (uint256) {
168         return _getRewardCount(staks[account]);
169     }
170 
171     function _getRewardCount(Stake storage stake)
172         internal
173         view
174         returns (uint256)
175     {
176         if (
177             stake.scores == 0 || stake.lastGrantIntervalNumber >= intervalNumber
178         ) return 0;
179         return (stake.scores * claimRewardPoolStartCount) / claimStaksScoresSum;
180     }
181 
182     function _grantReward(
183         address account,
184         Stake storage stake,
185         uint256 reward
186     ) private {
187         if (reward > claimRewardPool) reward = claimRewardPool;
188         if (reward == 0) return;
189         unchecked {
190             claimRewardPool -= reward;
191             totalRewardClaimed += reward;
192         }
193         // grant reward
194         transferRewardTo(account, reward);
195         // use stake
196         stake.lastGrantIntervalNumber = intervalNumber;
197     }
198 
199     function claimReward() external {
200         tryNextInterval();
201         Stake storage stake = staks[msg.sender];
202         uint256 reward = _getRewardCount(stake);
203         require(reward > 0, "has no reward");
204         _grantReward(msg.sender, stake, reward);
205     }
206 
207     function removeStake() external {
208         tryNextInterval();
209         Stake storage stake = staks[msg.sender];
210         _grantReward(msg.sender, stake, _getRewardCount(stake)); // try grant reward if change stack
211         require(stake.scores > 0, "stake scores is 0");
212         removeStake(msg.sender, stake);
213         staksScoresSum -= stake.scores;        
214         delete staks[msg.sender];
215     }
216 
217     function tryNextInterval() public {
218         // try to go into next  interval
219         if (block.timestamp < nextIntervalTime) return;
220         // save total staks
221         claimStaksScoresSum = staksScoresSum;
222         // update reward pools
223         claimRewardPool = getRewardsTotal();
224         claimRewardPoolStartCount = claimRewardPool;
225         // set the next interval
226         ++intervalNumber;
227         nextIntervalTime = block.timestamp + intervalMinutes * 1 minutes;
228     }
229 
230     function _updateScores(Stake storage stake, uint256 newScores) internal {
231         require(intervalNumber > 0 && enabled, "reward pool not started");
232         tryNextInterval();
233         _grantReward(msg.sender, stake, _getRewardCount(stake));
234         if (stake.scores == newScores) return;
235         if (stake.scores < newScores) {
236             uint256 delta = newScores - stake.scores;
237             staksScoresSum += delta;
238             stake.scores += delta;
239         } else {
240             uint256 delta = stake.scores - newScores;
241             staksScoresSum -= delta;
242             stake.scores -= delta;
243         }
244         stake.lastGrantIntervalNumber = intervalNumber;
245     }
246 
247     function getStake(address account) external view returns (Stake memory) {
248         return _getStake(account);
249     }
250 
251     function _getStake(address account)
252         internal
253         view
254         virtual
255         returns (Stake memory)
256     {
257         return staks[account];
258     }
259 
260     function beforeStart() internal virtual;
261 
262     function transferRewardTo(address account, uint256 count) internal virtual;
263 
264     function removeStake(address account, Stake memory stake) internal virtual;
265 
266     // current total rewards count (for claims and accumulative)
267     function getRewardsTotal() public view virtual returns (uint256);
268 }
269 
270 // File: contracts/RewardPool.sol
271 
272 pragma solidity ^0.8.7;
273 
274 //import "hardhat/console.sol";
275 
276 
277 
278 
279 
280 // the reward pool that provides erc20 and nft staking and grants erc20 tokens
281 contract RewardPool is RewardPoolBase {
282     IERC20 public erc20; // erc20 token
283     IERC721 public nft; // erc721 token
284     mapping(address => uint256[]) mftByAccounts;
285 
286     constructor(address erc20Address, address nftAddress) {
287         erc20 = IERC20(erc20Address);
288         nft = IERC721(nftAddress);
289     }
290 
291     function setErc20Address(address newErc20Address) external onlyOwner {
292         erc20 = IERC20(newErc20Address);
293     }
294 
295     function setNftAddress(address newNftAddress) external onlyOwner {
296         nft = IERC721(newNftAddress);
297     }
298 
299     function beforeStart() internal view override {
300         require(address(erc20) != address(0), "erc20 is zero");
301         require(address(nft) != address(0), "nft is zero");
302     }
303 
304     function getRewardsTotal() public view override returns (uint256) {
305         return erc20.balanceOf(address(this));
306     }
307 
308     function transferRewardTo(address account, uint256 count)
309         internal
310         override
311     {
312         erc20.transfer(account, count);
313     }
314 
315     function removeStake(address account, Stake memory stake)
316         internal
317         override
318     {
319         uint256 len = stake.nft.length;
320         for (uint256 i = 0; i < len; ++i)
321             nft.safeTransferFrom(address(this), account, stake.nft[i]);
322     }
323 
324     function addNftToStack(uint256 nftId) external {
325         _addNftToStack(nftId);
326     }
327 
328     function _addNftToStack(uint256 nftId) private {
329         require(nftId != 0, "nft id can not be zero");
330         Stake storage stake = staks[msg.sender];
331         nft.transferFrom(msg.sender, address(this), nftId);
332         stake.nft.push(nftId);
333         _updateScores(stake, stake.scores + 1);
334     }
335 
336     function addNftListToStack(uint256[] calldata nftIds) external {
337         for (uint256 i = 0; i < nftIds.length; ++i) _addNftToStack(nftIds[i]);
338     }
339 
340     function withdraw() external onlyOwner {
341         erc20.transfer(_owner, erc20.balanceOf(address(this)));
342     }
343 }