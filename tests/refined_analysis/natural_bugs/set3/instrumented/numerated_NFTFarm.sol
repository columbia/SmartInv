1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.7.4;
4 
5 import '@openzeppelin/contracts/utils/ReentrancyGuard.sol';
6 import '@openzeppelin/contracts/token/ERC20/SafeERC20.sol';
7 import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
8 import '@openzeppelin/contracts/utils/EnumerableMap.sol';
9 import '@openzeppelin/contracts/utils/EnumerableSet.sol';
10 import '@openzeppelin/contracts/token/ERC20/ERC20.sol';
11 import '@openzeppelin/contracts/access/Ownable.sol';
12 import '../interfaces/IMasterChef.sol';
13 import 'hardhat/console.sol';
14 
15 contract NFTFarm is Ownable, ReentrancyGuard {
16     using SafeMath for uint256;
17     using EnumerableSet for EnumerableSet.UintSet;
18     using EnumerableMap for EnumerableMap.UintToAddressMap;
19 
20     event Stake(address user, uint256 tokenId, uint256 amount);
21     event Unstake(address user, uint256 tokenId, uint256 amount);
22     event Claim(address user, uint256 amount);
23     event NewRangeInfo(uint index, uint startIndex, uint endIndex, uint babyValue, uint weight);
24     event DelRangeInfo(uint index);
25 
26     uint constant public WEIGHT_BASE = 1e2;
27     uint256 constant public RATIO = 1e18;
28 
29     struct PoolInfo {
30         ERC721 token;
31         uint256 totalShares;
32         uint256 accBabyPerShare;
33     }
34 
35     struct UserInfo {
36         uint256 amount;
37         uint256 debt;
38         uint256 pending;
39     }
40 
41     struct RangeInfo {
42         uint startIndex;
43         uint endIndex;
44         uint babyValue;
45         uint weight;
46     }
47 
48     PoolInfo public poolInfo;
49     mapping(address => UserInfo) public userInfo;
50     mapping(address => EnumerableSet.UintSet) holderTokens;
51     EnumerableMap.UintToAddressMap tokenOwners;
52     mapping(uint256 => uint256) public tokenWeight;
53     RangeInfo[] public rangeInfo;
54     ERC20 public immutable babyToken;
55     ERC721 public immutable nftToken;
56     IMasterChef immutable masterChef;
57     address public vault;
58 
59     constructor(ERC20 _babyToken, ERC721 _nftToken, IMasterChef _masterChef, address _vault) {
60         require(address(_babyToken) != address(0), "_babyToken address cannot be 0");
61         require(address(_nftToken) != address(0), "_nftToken address cannot be 0");
62         require(address(_masterChef) != address(0), "_masterChef address cannot be 0");
63         require(_vault != address(0), "_vault address cannot be 0");
64         babyToken = _babyToken;
65         nftToken = _nftToken;
66         masterChef = _masterChef;
67         vault = _vault;
68     }
69 
70     function addRangeInfo(uint _startIndex, uint _endIndex, uint _babyValue, uint _weight) external onlyOwner {
71         require(_startIndex <= _endIndex, "error index");
72         rangeInfo.push(RangeInfo({
73             startIndex: _startIndex,
74             endIndex: _endIndex,
75             babyValue: _babyValue,
76             weight: _weight
77         }));
78         emit NewRangeInfo(rangeInfo.length - 1, _startIndex, _endIndex, _babyValue, _weight);
79     }
80 
81     function setRangeInfo(uint _index, uint _startIndex, uint _endIndex, uint _babyValue, uint _weight) external onlyOwner {
82         require(_index < rangeInfo.length, "illegal index");
83         require(_startIndex <= _endIndex, "error index");
84         rangeInfo[_index] = RangeInfo({
85             startIndex: _startIndex,
86             endIndex: _endIndex,
87             babyValue: _babyValue,
88             weight: _weight
89         });
90         emit NewRangeInfo(_index, _startIndex, _endIndex, _babyValue, _weight);
91     }
92 
93     function delRangeInfo(uint _index) external onlyOwner {
94         require(_index < rangeInfo.length, "illegal index"); 
95         if (_index < rangeInfo.length - 1) {
96             RangeInfo memory _lastRangeInfo = rangeInfo[rangeInfo.length - 1];
97             rangeInfo[_index] = rangeInfo[rangeInfo.length - 1];
98             emit NewRangeInfo(_index, _lastRangeInfo.startIndex, _lastRangeInfo.endIndex, _lastRangeInfo.babyValue, _lastRangeInfo.weight);
99         }
100         rangeInfo.pop();
101         emit DelRangeInfo(rangeInfo.length);
102     }
103 
104     function stake(uint _tokenId, uint _idx) public nonReentrant {
105         require(_idx < rangeInfo.length, "illegal idx");
106         RangeInfo memory _rangeInfo = rangeInfo[_idx];
107         require(_tokenId >= _rangeInfo.startIndex && _tokenId <= _rangeInfo.endIndex, "illegal tokenId");
108         uint stakeBaby = _rangeInfo.babyValue.mul(_rangeInfo.weight).div(WEIGHT_BASE);
109         SafeERC20.safeTransferFrom(babyToken, vault, address(this), stakeBaby);
110         nftToken.transferFrom(msg.sender, address(this), _tokenId);
111 
112         PoolInfo memory _poolInfo = poolInfo;
113         UserInfo memory _userInfo = userInfo[msg.sender];
114         //uint _pending = masterChef.pendingCake(0, address(this));
115         uint balanceBefore = babyToken.balanceOf(address(this));
116         masterChef.enterStaking(0);
117         uint balanceAfter = babyToken.balanceOf(address(this));
118         uint _pending = balanceAfter.sub(balanceBefore);
119         if (_pending > 0 && _poolInfo.totalShares > 0) {
120             poolInfo.accBabyPerShare = _poolInfo.accBabyPerShare.add(_pending.mul(RATIO).div(_poolInfo.totalShares));
121             _poolInfo.accBabyPerShare = _poolInfo.accBabyPerShare.add(_pending.mul(RATIO).div(_poolInfo.totalShares));
122         }
123         if (_userInfo.amount > 0) {
124             userInfo[msg.sender].pending = _userInfo.pending.add(_userInfo.amount.mul(_poolInfo.accBabyPerShare).div(RATIO).sub(_userInfo.debt));
125         }
126         babyToken.approve(address(masterChef), stakeBaby.add(_pending));
127         masterChef.enterStaking(stakeBaby.add(_pending));
128         userInfo[msg.sender].amount = _userInfo.amount.add(stakeBaby);
129         holderTokens[msg.sender].add(_tokenId);
130         tokenOwners.set(_tokenId, msg.sender);
131         tokenWeight[_tokenId] = stakeBaby;
132         poolInfo.totalShares = _poolInfo.totalShares.add(stakeBaby);
133         userInfo[msg.sender].debt = _poolInfo.accBabyPerShare.mul(_userInfo.amount.add(stakeBaby)).div(RATIO);
134         emit Stake(msg.sender, _tokenId, stakeBaby);
135     }
136 
137     function stakeAll(uint[] memory _tokenIds, uint[] memory _idxs) external {
138         require(_tokenIds.length == _idxs.length, "illegal array length");
139         for (uint i = 0; i < _idxs.length; i ++) {
140             stake(_tokenIds[i], _idxs[i]);
141         }
142     }
143 
144     function unstake(uint _tokenId) public nonReentrant {
145         require(tokenOwners.get(_tokenId) == msg.sender, "illegal tokenId");
146 
147         PoolInfo memory _poolInfo = poolInfo;
148         UserInfo memory _userInfo = userInfo[msg.sender];
149 
150         //uint _pending = masterChef.pendingCake(0, address(this));
151         uint balanceBefore = babyToken.balanceOf(address(this));
152         masterChef.leaveStaking(0);
153         uint balanceAfter = babyToken.balanceOf(address(this));
154         uint _pending = balanceAfter.sub(balanceBefore);
155         if (_pending > 0 && _poolInfo.totalShares > 0) {
156             poolInfo.accBabyPerShare = _poolInfo.accBabyPerShare.add(_pending.mul(RATIO).div(_poolInfo.totalShares));
157             _poolInfo.accBabyPerShare = _poolInfo.accBabyPerShare.add(_pending.mul(RATIO).div(_poolInfo.totalShares));
158         }
159 
160         uint _userPending = _userInfo.pending.add(_userInfo.amount.mul(_poolInfo.accBabyPerShare).div(RATIO).sub(_userInfo.debt));
161         uint _stakeAmount = tokenWeight[_tokenId];
162         uint _totalPending = _userPending.add(_stakeAmount);
163 
164         if (_totalPending >= _pending) {
165             masterChef.leaveStaking(_totalPending.sub(_pending));
166         } else {
167             //masterChef.leaveStaking(0);
168             babyToken.approve(address(masterChef), _pending.sub(_totalPending));
169             masterChef.enterStaking(_pending.sub(_totalPending));
170         }
171 
172         if (_userPending > 0) {
173             SafeERC20.safeTransfer(babyToken, msg.sender, _userPending);
174             emit Claim(msg.sender, _userPending);
175         }
176         if (_totalPending > _userPending) {
177             SafeERC20.safeTransfer(babyToken, vault, _totalPending.sub(_userPending));
178         }
179 
180         poolInfo.totalShares = _poolInfo.totalShares.sub(_stakeAmount);
181         userInfo[msg.sender].amount = _userInfo.amount.sub(_stakeAmount);
182         userInfo[msg.sender].pending = 0;
183         userInfo[msg.sender].debt = _userInfo.amount.sub(_stakeAmount).mul(_poolInfo.accBabyPerShare).div(RATIO);
184         tokenOwners.remove(_tokenId);
185         holderTokens[msg.sender].remove(_tokenId);
186         nftToken.transferFrom(address(this), msg.sender, _tokenId);
187         delete tokenWeight[_tokenId];
188         emit Unstake(msg.sender, _tokenId, _stakeAmount);
189     }
190 
191     function unstakeAll(uint[] memory _tokenIds) external {
192         for (uint i = 0; i < _tokenIds.length; i ++) {
193             unstake(_tokenIds[i]);
194         }
195     }
196 
197     function claim(address _user) external nonReentrant {
198         PoolInfo memory _poolInfo = poolInfo;
199         UserInfo memory _userInfo = userInfo[_user];
200 
201         //uint _pending = masterChef.pendingCake(0, address(this));
202         uint balanceBefore = babyToken.balanceOf(address(this));
203         masterChef.leaveStaking(0);
204         uint balanceAfter = babyToken.balanceOf(address(this));
205         uint _pending = balanceAfter.sub(balanceBefore);
206         if (_pending > 0 && _poolInfo.totalShares > 0) {
207             poolInfo.accBabyPerShare = _poolInfo.accBabyPerShare.add(_pending.mul(RATIO).div(_poolInfo.totalShares));
208             _poolInfo.accBabyPerShare = _poolInfo.accBabyPerShare.add(_pending.mul(RATIO).div(_poolInfo.totalShares));
209         }
210         uint _userPending = _userInfo.pending.add(_userInfo.amount.mul(_poolInfo.accBabyPerShare).div(RATIO).sub(_userInfo.debt));
211         if (_userPending == 0) {
212             return;
213         }
214         if (_userPending >= _pending) {
215             masterChef.leaveStaking(_userPending.sub(_pending));
216         } else {
217             //masterChef.leaveStaking(0);
218             babyToken.approve(address(masterChef), _pending.sub(_userPending));
219             masterChef.enterStaking(_pending.sub(_userPending));
220         }
221         SafeERC20.safeTransfer(babyToken, _user, _userPending);
222         emit Claim(_user, _userPending);
223         userInfo[_user].debt = _userInfo.amount.mul(_poolInfo.accBabyPerShare).div(RATIO);
224         userInfo[_user].pending = 0;
225     }
226 
227     function pending(address _user) external view returns (uint256) {
228         uint _pending = masterChef.pendingCake(0, address(this));
229         if (poolInfo.totalShares == 0) {
230             return 0;
231         }
232         uint acc = poolInfo.accBabyPerShare.add(_pending.mul(RATIO).div(poolInfo.totalShares));
233         uint userPending = userInfo[_user].pending.add(userInfo[_user].amount.mul(acc).div(RATIO).sub(userInfo[_user].debt));
234         return userPending;
235     }
236 
237     function balanceOf(address owner) external view returns (uint256) {
238         require(owner != address(0), "ERC721: balance query for the zero address");
239         return holderTokens[owner].length();
240     }
241 
242     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256) {
243         return holderTokens[owner].at(index);
244     }
245 }
