1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.7;
4 
5 /**
6  * @title Zen Apes Staking contract
7  * @author The Core Devs (@thecoredevs)
8  */
9 
10 interface IZenApes {
11     function ownerOf(uint256 _tokenId) external view returns (address);
12     function balanceOf(address owner) external view returns (uint256 balance);
13     function transferFrom(address _from, address _to, uint256 _tokenId) external;
14     function multiTransferFrom(address from_, address to_, uint256[] memory tokenIds_) external;
15 }
16 
17 interface IZenToken {
18     function mintAsController(address to_, uint256 amount_) external;
19 }
20 
21 contract ZenStakingV1 {
22     
23     uint private yieldPerDay;
24     uint40 private _requiredStakeTime;
25     address public owner;
26 
27     struct StakedToken {
28         uint40 stakingTimestamp;
29         uint40 lastClaimTimestamp;
30         address tokenOwner;
31     }
32 
33     // seconds in 24 hours: 86400
34 
35     mapping(uint16 => StakedToken) private stakedTokens;
36     mapping(address => uint) public stakedTokensAmount;
37     
38     IZenApes zenApesContract;
39     IZenToken zenTokenContract;
40 
41     modifier onlyOwner() {
42         require(msg.sender == owner, "Caller Not Owner!");
43         _;
44     }
45 
46     event OwnershipTransfer(address oldOwner, address newOwner);
47 
48     constructor (
49         uint yieldAmountPerDay,
50         uint40 requiredStakeTimeInSeconds, 
51         address zenApesContractAddr,
52         address zenTokenContractAddr
53         ) {
54         _setZenApesContractAddr(zenApesContractAddr);
55         _setZenTokenContractAddr(zenTokenContractAddr);
56         yieldPerDay = yieldAmountPerDay;
57         _requiredStakeTime = requiredStakeTimeInSeconds;
58         owner = msg.sender;
59     }
60 
61     function transferOwnership(address newOwner) external onlyOwner {
62         address oldOwner = owner;
63         owner = newOwner;
64         emit OwnershipTransfer(oldOwner, newOwner);
65     }
66 
67     function setYieldPerDay(uint amount) external onlyOwner {
68         yieldPerDay = amount;
69     }
70     
71     function setRequiredStakeTime(uint40 timeInSeconds) external onlyOwner {
72         _requiredStakeTime = timeInSeconds;
73     }
74 
75     function setZenApesContractAddr(address contractAddress) external onlyOwner {
76         _setZenApesContractAddr(contractAddress);
77     }
78 
79     function _setZenApesContractAddr(address _contractAddress) private {
80         _requireContract(_contractAddress);
81         zenApesContract = IZenApes(_contractAddress);
82     }
83 
84     function setZenTokenContractAddr(address contractAddress) external onlyOwner {
85         _setZenTokenContractAddr(contractAddress);
86     }
87 
88     function _setZenTokenContractAddr(address _contractAddress) private {
89         _requireContract(_contractAddress);
90         zenTokenContract = IZenToken(_contractAddress);
91     }
92 
93     function _requireContract(address contractAddr) private view {
94         uint256 size;
95         assembly {
96             size := extcodesize(contractAddr)
97         }
98         require(size > 0, "Not A Contract!");
99     }
100 
101     function claim(uint tokenId) external {
102         StakedToken memory tokenInfo = stakedTokens[uint16(tokenId)];
103         require(tokenInfo.tokenOwner == msg.sender, "Caller is not token owner!");
104 
105         uint claimAmount = _getClaimableAmount(tokenInfo);
106 
107         require(claimAmount > 0, "No claimable Tokens!");
108 
109         stakedTokens[uint16(tokenId)].lastClaimTimestamp = uint40(block.timestamp);
110         zenTokenContract.mintAsController(msg.sender, claimAmount);
111     }
112 
113     function batchClaim(uint[] memory tokenIds) external {
114         uint length = tokenIds.length;
115         uint claimAmount;
116         uint cId;
117         StakedToken memory tokenInfo;
118 
119         for (uint i; i < length;) {
120             assembly {
121                 cId := mload(add(add(tokenIds, 0x20), mul(i, 0x20)))
122             }
123 
124             tokenInfo = stakedTokens[uint16(cId)];
125             require(tokenInfo.tokenOwner == msg.sender, "Caller is not token owner!");
126 
127             claimAmount += _getClaimableAmount(tokenInfo);
128             stakedTokens[uint16(cId)].lastClaimTimestamp = uint40(block.timestamp);
129             
130             unchecked { ++i; }
131         }
132 
133         zenTokenContract.mintAsController(msg.sender, claimAmount);
134     }
135 
136     function _getClaimableAmount(StakedToken memory tokenInfo) private view returns(uint claimAmount) {
137 
138         if (tokenInfo.lastClaimTimestamp == 0) {
139             uint timeStaked;
140             unchecked { timeStaked = block.timestamp - tokenInfo.stakingTimestamp; }
141             uint requiredStakeTime = _requiredStakeTime;
142 
143             require(timeStaked >= requiredStakeTime, "Required stake time not met!");
144             claimAmount = ((timeStaked - requiredStakeTime) / 86400) * yieldPerDay ;
145         } else {
146             uint secondsSinceLastClaim;
147             unchecked { secondsSinceLastClaim = block.timestamp - tokenInfo.lastClaimTimestamp; }
148             require(secondsSinceLastClaim > 86399, "Cannot cliam zero tokens!");
149 
150             claimAmount = (secondsSinceLastClaim / 86400) * yieldPerDay ;
151         }
152     }
153 
154     function _getClaimableAmountView(StakedToken memory tokenInfo) private view returns(uint claimAmount) {
155 
156          if (tokenInfo.lastClaimTimestamp == 0) {
157             uint timeStaked;
158             unchecked { timeStaked = block.timestamp - tokenInfo.stakingTimestamp; }
159             uint requiredStakeTime = _requiredStakeTime;
160 
161             if (timeStaked <= requiredStakeTime) { return 0; }
162             claimAmount = ((timeStaked - requiredStakeTime) / 86400) * yieldPerDay ;
163         } else {
164             uint secondsSinceLastClaim;
165             unchecked { secondsSinceLastClaim = block.timestamp - tokenInfo.lastClaimTimestamp; }
166             if (secondsSinceLastClaim < 86401) { return 0; }
167 
168             claimAmount = (secondsSinceLastClaim / 86400) * yieldPerDay ;
169         }
170     }
171 
172     function stake(uint tokenId) external {
173         require(zenApesContract.ownerOf(tokenId) == msg.sender);
174         stakedTokens[uint16(tokenId)].stakingTimestamp = uint40(block.timestamp);
175         stakedTokens[uint16(tokenId)].tokenOwner = msg.sender;
176         unchecked { ++stakedTokensAmount[msg.sender]; }
177         zenApesContract.transferFrom(msg.sender, address(this), tokenId);
178     }
179 
180     function stakeBatch(uint[] memory tokenIds) external {
181         uint amount = tokenIds.length;
182         uint cId;
183         for(uint i; i < amount;) {
184 
185             assembly {
186                 cId := mload(add(add(tokenIds, 0x20), mul(i, 0x20)))
187             }
188 
189             require(zenApesContract.ownerOf(cId) == msg.sender);
190             stakedTokens[uint16(cId)].stakingTimestamp = uint40(block.timestamp);
191             stakedTokens[uint16(cId)].tokenOwner = msg.sender;
192 
193             unchecked {
194                 ++stakedTokensAmount[msg.sender];
195                 ++i;
196             }
197         }
198         zenApesContract.multiTransferFrom(msg.sender, address(this), tokenIds);
199     }
200 
201     function unstake(uint tokenId) external {
202         require(stakedTokens[uint16(tokenId)].tokenOwner == msg.sender);
203         delete stakedTokens[uint16(tokenId)];
204         unchecked { --stakedTokensAmount[msg.sender]; }
205         zenApesContract.transferFrom(address(this), msg.sender, tokenId);
206     }
207 
208     function unstakeBatch(uint[] memory tokenIds) external {
209         uint amount = tokenIds.length;
210         uint cId;
211         for(uint i; i < amount;) {
212 
213             assembly {
214                 cId := mload(add(add(tokenIds, 0x20), mul(i, 0x20)))
215             }
216 
217             require(stakedTokens[uint16(cId)].tokenOwner == msg.sender);
218             delete stakedTokens[uint16(cId)];
219 
220             unchecked {
221                 ++i;
222                 --stakedTokensAmount[msg.sender]; 
223             }
224         }
225         
226         zenApesContract.multiTransferFrom(address(this), msg.sender, tokenIds);
227     }
228 
229     function ownerUnstakeBatch(uint[] memory tokenIds) external onlyOwner {
230         uint amount = tokenIds.length;
231         uint cId;
232         for(uint i; i < amount;) {
233 
234             assembly {
235                 cId := mload(add(add(tokenIds, 0x20), mul(i, 0x20)))
236             }
237 
238             zenApesContract.transferFrom(address(this), stakedTokens[uint16(cId)].tokenOwner, cId);
239             delete stakedTokens[uint16(cId)];
240 
241             unchecked {
242                 ++i;
243                 --stakedTokensAmount[msg.sender]; 
244             }
245         }
246     }
247 
248 
249     function getTokenInfo(uint16 id) external view returns(uint40 stakingTimestamp, uint40 lastClaimTimestamp, address tokenOwner) {
250         return (stakedTokens[id].stakingTimestamp, stakedTokens[id].lastClaimTimestamp, stakedTokens[id].tokenOwner);
251     }
252 
253     function getUserTokenInfo(address user) external view returns(
254         uint[] memory stakingTimestamp,
255         uint[] memory lastClaimTimestamp,
256         uint[] memory tokenIds,
257         uint[] memory claimableAmount,
258         uint totalClaimableAmount
259     ) {
260         uint x;
261         uint ca;
262         uint stakedAmount = stakedTokensAmount[user];
263         StakedToken memory st;
264 
265         stakingTimestamp = new uint[](stakedAmount);
266         lastClaimTimestamp = new uint[](stakedAmount);
267         tokenIds = new uint[](stakedAmount);
268         claimableAmount = new uint[](stakedAmount);
269 
270         for(uint i = 1; i < 5001;) {
271             st = stakedTokens[uint16(i)];
272             if(st.tokenOwner == user) {
273                 stakingTimestamp[x] = st.stakingTimestamp;
274                 lastClaimTimestamp[x] = st.lastClaimTimestamp;
275                 tokenIds[x] = i;
276                 ca = _getClaimableAmountView(st);
277                 claimableAmount[x] = ca;
278                 totalClaimableAmount += ca;
279                 unchecked { ++x; }
280             }
281             unchecked { ++i; }
282         }
283     }
284 
285     function getStakingSettings() external view returns (uint, uint40) {
286         return (yieldPerDay, _requiredStakeTime);
287     }
288 
289     function getContractAddresses() external view returns(address zenApes, address zenToken) {
290         return(address(zenApesContract), address(zenTokenContract));
291     }
292 
293 }