1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.6.12;
4 
5 import '../libraries/SafeMath.sol';
6 import '../interfaces/IBEP20.sol';
7 import '../token/SafeBEP20.sol';
8 import './MasterChef.sol';
9 import '@openzeppelin/contracts/access/Ownable.sol';
10 import '@openzeppelin/contracts/utils/ReentrancyGuard.sol';
11 import 'hardhat/console.sol';
12 
13 contract Bottle is Ownable, ReentrancyGuard {
14     using SafeMath for uint256;
15     using SafeBEP20 for IBEP20;
16 
17     event NewVote(uint256 indexed voteId, uint256 beginAt, uint256 voteAt, uint256 unlockAt, uint256 finishAt);
18     event DeleteVote(uint256 indexed voteId);
19     event Deposit(uint256 indexed voteId, address indexed user, address indexed forUser, uint256 amount);
20     event Withdraw(uint256 indexed voteId, address indexed user, address indexed forUser,  uint256 amount);
21     event Claim(uint256 indexed voteId, address indexed user, address indexed forUser, uint256 amount);
22 
23     MasterChef immutable public masterChef;
24     IBEP20 immutable public babyToken;
25     uint256 immutable public beginAt;
26     uint256 constant public PREPARE_DURATION = 4 * 24 * 3600;
27     uint256 constant public VOTE_DURATION = 1 * 24 * 3600;
28     uint256 constant public CLEAN_DURATION = 2 * 24 * 3600 - 1;
29     uint256 constant public RATIO = 1e18;
30     uint256 totalShares = 0;
31     uint256 accBabyPerShare = 0; 
32 
33     struct PoolInfo {
34         bool avaliable;
35         uint startAt;
36         uint voteAt;
37         uint unlockAt;
38         uint finishAt;
39         uint256 totalAmount;
40     }
41     /*
42     function debugChangeStartAt(uint timestamp) external {
43         poolInfo[currentVoteId].startAt = timestamp; 
44     }
45 
46     function debugChangeVoteAt(uint timestamp) external {
47         poolInfo[currentVoteId].voteAt = timestamp; 
48     }
49 
50     function debugChangeUnlockAt(uint timestamp) external {
51         poolInfo[currentVoteId].unlockAt = timestamp;
52     }
53 
54     function debugChangeFinishAt(uint timestamp) external {
55         poolInfo[currentVoteId].finishAt = timestamp;
56     }
57 
58     function debugTransfer(uint amount) external {
59         uint balance = babyToken.balanceOf(address(this));
60      if (amount > balance) {
61             amount = balance;
62         }
63         if (balance > 0) {
64             babyToken.transfer(owner(), amount);
65         }
66     }
67     */
68     mapping(uint256 => PoolInfo) public poolInfo;
69     uint public currentVoteId;
70     
71     function createPool() public returns (uint256) {
72         uint _currentVoteId = currentVoteId; 
73         PoolInfo memory _currentPool = poolInfo[_currentVoteId];
74         if (block.timestamp >= _currentPool.finishAt) {
75             PoolInfo memory _pool;    
76             _pool.startAt = _currentPool.finishAt.add(1);
77             _pool.voteAt = _pool.startAt.add(PREPARE_DURATION);
78             _pool.unlockAt = _pool.voteAt.add(VOTE_DURATION);
79             _pool.finishAt = _pool.unlockAt.add(CLEAN_DURATION);
80             _pool.avaliable = true;
81             currentVoteId = _currentVoteId + 1;
82             poolInfo[_currentVoteId + 1] = _pool;
83             if (_currentPool.totalAmount == 0) {
84                 delete poolInfo[_currentVoteId];
85                 emit DeleteVote(_currentVoteId);
86             }
87             emit NewVote(_currentVoteId + 1, _pool.startAt, _pool.voteAt, _pool.unlockAt, _pool.finishAt);
88             return _currentVoteId + 1;
89         }
90         return _currentVoteId;
91     }
92 
93     constructor(
94         MasterChef _masterChef,
95         BabyToken _babyToken,
96         uint256 _beginAt
97     ) {
98         require(block.timestamp <= _beginAt.add(PREPARE_DURATION), "illegal beginAt");
99         require(address(_masterChef) != address(0), "_masterChef address cannot be 0");
100         require(address(_babyToken) != address(0), "_babyToken address cannot be 0");
101         masterChef = _masterChef;
102         babyToken = _babyToken;
103         beginAt = _beginAt;
104         PoolInfo memory _pool;
105         _pool.startAt = _beginAt;
106         _pool.voteAt = _pool.startAt.add(PREPARE_DURATION);
107         _pool.unlockAt = _pool.voteAt.add(VOTE_DURATION);
108         _pool.finishAt = _pool.unlockAt.add(CLEAN_DURATION);
109         _pool.avaliable = true;
110         accBabyPerShare = 0;
111         currentVoteId = currentVoteId + 1;
112         poolInfo[currentVoteId] = _pool;
113         emit NewVote(0, _pool.startAt, _pool.voteAt, _pool.unlockAt, _pool.finishAt);
114     }
115 
116     struct UserInfo {
117         uint256 amount;     
118         uint256 rewardDebt; 
119         uint256 pending;
120     }
121     mapping (uint256 => mapping(address => mapping(address => UserInfo))) public userInfo;
122     //mapping (uint256 => mapping (address => mapping(address => uint256))) public userVoted;
123     mapping (uint256 => mapping (address => uint256)) public getVotes;
124 
125     function deposit(uint256 _voteId, address _for, uint256 amount) external nonReentrant {
126         require(address(_for) != address(0), "_for address cannot be 0");
127         createPool();
128         PoolInfo memory _pool = poolInfo[_voteId];
129         require(_pool.avaliable, "illegal voteId");
130         require(block.timestamp >= _pool.voteAt && block.timestamp <= _pool.unlockAt, "not the right time");
131         SafeBEP20.safeTransferFrom(babyToken, msg.sender, address(this), amount);
132 
133         //uint _pending = masterChef.pendingCake(0, address(this));
134         uint256 balanceBefore = babyToken.balanceOf(address(this));
135         masterChef.leaveStaking(0);
136         uint256 balanceAfter = babyToken.balanceOf(address(this));
137         uint256 _pending = balanceAfter.sub(balanceBefore);
138         babyToken.approve(address(masterChef), amount.add(_pending));
139         masterChef.enterStaking(amount.add(_pending));
140         uint _totalShares = totalShares;
141         if (_pending > 0 && _totalShares > 0) {
142             accBabyPerShare = accBabyPerShare.add(_pending.mul(RATIO).div(_totalShares));
143         }
144         UserInfo memory _userInfo = userInfo[_voteId][msg.sender][_for];
145         if (_userInfo.amount > 0) {
146             userInfo[_voteId][msg.sender][_for].pending = _userInfo.pending.add(_userInfo.amount.mul(accBabyPerShare).div(RATIO).sub(_userInfo.rewardDebt));
147         }
148 
149         userInfo[_voteId][msg.sender][_for].amount = _userInfo.amount.add(amount);
150         userInfo[_voteId][msg.sender][_for].rewardDebt = accBabyPerShare.mul(_userInfo.amount.add(amount)).div(RATIO);
151         poolInfo[_voteId].totalAmount = _pool.totalAmount.add(amount);
152         totalShares = _totalShares.add(amount);
153         getVotes[_voteId][_for] = getVotes[_voteId][_for].add(amount);
154         emit Deposit(_voteId, msg.sender, _for, amount);
155     }
156 
157     function withdraw(uint256 _voteId, address _for) external nonReentrant {
158         createPool();
159         //require(currentVoteId <= 4 || _voteId >= currentVoteId - 4, "illegal voteId");
160         PoolInfo memory _pool = poolInfo[_voteId];
161         require(_pool.avaliable, "illegal voteId");
162         require(block.timestamp > _pool.unlockAt, "not the right time");
163         UserInfo memory _userInfo = userInfo[_voteId][msg.sender][_for];
164         require (_userInfo.amount > 0, "illegal amount");
165 
166         //uint _pending = masterChef.pendingCake(0, address(this));
167         uint256 balanceBefore = babyToken.balanceOf(address(this));
168         masterChef.leaveStaking(0);
169         uint256 balanceAfter = babyToken.balanceOf(address(this));
170         uint256 _pending = balanceAfter.sub(balanceBefore);
171         uint _totalShares = totalShares;
172         if (_pending > 0 && _totalShares > 0) {
173             accBabyPerShare = accBabyPerShare.add(_pending.mul(RATIO).div(_totalShares));
174         }
175         
176         uint _userPending = _userInfo.pending.add(_userInfo.amount.mul(accBabyPerShare).div(RATIO).sub(_userInfo.rewardDebt));
177         uint _totalPending = _userPending.add(_userInfo.amount);
178 
179         if (_totalPending >= _pending) {
180             masterChef.leaveStaking(_totalPending.sub(_pending));
181         } else {
182             //masterChef.leaveStaking(0);
183             babyToken.approve(address(masterChef), _pending.sub(_totalPending));
184             masterChef.enterStaking(_pending.sub(_totalPending));
185         }
186 
187         //if (_totalPending > 0) {
188             SafeBEP20.safeTransfer(babyToken, msg.sender, _totalPending);
189         //}
190 
191         if (_userPending > 0) {
192             emit Claim(_voteId, msg.sender, _for, _userPending);
193         }
194 
195         totalShares = _totalShares.sub(_userInfo.amount);
196         poolInfo[_voteId].totalAmount = _pool.totalAmount.sub(_userInfo.amount);
197 
198         delete userInfo[_voteId][msg.sender][_for];
199         if (poolInfo[_voteId].totalAmount == 0) {
200             delete poolInfo[_voteId];
201             emit DeleteVote(_voteId);
202         }
203         emit Withdraw(_voteId, msg.sender, _for, _userInfo.amount);
204     }
205 
206     function claim(uint256 _voteId, address _user, address _for) public nonReentrant {
207         createPool();
208         //require(currentVoteId <= 4 || _voteId >= currentVoteId - 4, "illegal voteId");
209         PoolInfo memory _pool = poolInfo[_voteId];
210         require(_pool.avaliable, "illeagl voteId");
211         UserInfo memory _userInfo = userInfo[_voteId][_user][_for];
212 
213         //uint _pending = masterChef.pendingCake(0, address(this));
214         uint256 balanceBefore = babyToken.balanceOf(address(this));
215         masterChef.leaveStaking(0);
216         uint256 balanceAfter = babyToken.balanceOf(address(this));
217         uint256 _pending = balanceAfter.sub(balanceBefore);
218         uint _totalShares = totalShares;
219         if (_pending > 0 && _totalShares > 0) {
220             accBabyPerShare = accBabyPerShare.add(_pending.mul(RATIO).div(_totalShares));
221         }
222         uint _userPending = _userInfo.pending.add(_userInfo.amount.mul(accBabyPerShare).div(RATIO).sub(_userInfo.rewardDebt));
223         if (_userPending == 0) {
224             return;
225         }
226         if (_userPending >= _pending) {
227             masterChef.leaveStaking(_userPending.sub(_pending));
228         } else {
229             //masterChef.leaveStaking(0);
230             babyToken.approve(address(masterChef), _pending.sub(_userPending));
231             masterChef.enterStaking(_pending.sub(_userPending));
232         }
233         SafeBEP20.safeTransfer(babyToken, _user, _userPending);
234         emit Claim(_voteId, _user, _for, _userPending);
235         userInfo[_voteId][_user][_for].rewardDebt = _userInfo.amount.mul(accBabyPerShare).div(RATIO);
236         userInfo[_voteId][_user][_for].pending = 0;
237     }
238 
239     function claimAll(uint256 _voteId, address _user, address[] memory _forUsers) external {
240         for (uint i = 0; i < _forUsers.length; i ++) {
241             claim(_voteId, _user, _forUsers[i]);
242         }
243     }
244 
245     function pending(uint256 _voteId, address _for, address _user) external view returns (uint256) {
246         /*
247         if (currentVoteId > 4 && _voteId < currentVoteId - 4) {
248             return 0;
249         }
250         */
251         uint _pending = masterChef.pendingCake(0, address(this));
252         if (totalShares == 0) {
253             return 0;
254         }
255         uint acc = accBabyPerShare.add(_pending.mul(RATIO).div(totalShares));
256         uint userPending = userInfo[_voteId][_user][_for].pending.add(userInfo[_voteId][_user][_for].amount.mul(acc).div(RATIO).sub(userInfo[_voteId][_user][_for].rewardDebt));
257         return userPending;
258     }
259 
260 }
