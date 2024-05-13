1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 pragma experimental ABIEncoderV2;
5 
6 import "@boringcrypto/boring-solidity-e06e943/contracts/libraries/BoringERC20.sol";
7 import "@boringcrypto/boring-solidity-e06e943/contracts/libraries/BoringMath.sol";
8 import "@boringcrypto/boring-solidity-e06e943/contracts/BoringOwnable.sol";
9 import "../interfaces/IRewarder.sol";
10 
11 interface IMiniChef {
12     function lpToken(uint256 pid) external view returns (IERC20 _lpToken);
13 }
14 
15 /**
16  * @title SimpleRewarder
17  * @notice Rewarder contract that can add one additional reward token to a specific PID in MiniChef.
18  * Emission rate is controlled by the owner of this contract, independently from MiniChef's owner.
19  * @author @0xKeno @weeb_mcgee
20  */
21 contract SimpleRewarder is IRewarder, BoringOwnable {
22     using BoringMath for uint256;
23     using BoringMath128 for uint128;
24     using BoringERC20 for IERC20;
25 
26     uint256 private constant ACC_TOKEN_PRECISION = 1e12;
27 
28     /// @notice Info of each Rewarder user.
29     /// `amount` LP token amount the user has provided.
30     /// `rewardDebt` The amount of Reward Token entitled to the user.
31     struct UserInfo {
32         uint256 amount;
33         uint256 rewardDebt;
34     }
35 
36     /// @notice Info of the rewarder pool
37     struct PoolInfo {
38         uint128 accToken1PerShare;
39         uint64 lastRewardTime;
40     }
41 
42     /// @notice Address of the token that should be given out as rewards.
43     IERC20 public rewardToken;
44 
45     /// @notice Var to track the rewarder pool.
46     PoolInfo public poolInfo;
47 
48     /// @notice Info of each user that stakes LP tokens.
49     mapping(address => UserInfo) public userInfo;
50 
51     /// @notice Total emission rate of the reward token per second
52     uint256 public rewardPerSecond;
53     /// @notice Address of the lp token that should be incentivized
54     IERC20 public masterLpToken;
55     /// @notice PID in MiniChef that corresponds to masterLpToken
56     uint256 public pid;
57 
58     /// @notice MiniChef contract that will call this contract's callback function
59     address public immutable MINICHEF;
60 
61     event LogOnReward(
62         address indexed user,
63         uint256 indexed pid,
64         uint256 amount,
65         address indexed to
66     );
67     event LogUpdatePool(
68         uint256 indexed pid,
69         uint64 lastRewardTime,
70         uint256 lpSupply,
71         uint256 accToken1PerShare
72     );
73     event LogRewardPerSecond(uint256 rewardPerSecond);
74     event LogInit(
75         IERC20 indexed rewardToken,
76         address owner,
77         uint256 rewardPerSecond,
78         IERC20 indexed masterLpToken
79     );
80 
81     /**
82      * @notice Deploys this contract and sets immutable MiniChef address.
83      */
84     constructor(address _MINICHEF) public {
85         MINICHEF = _MINICHEF;
86     }
87 
88     /**
89      * @notice Modifier to restrict caller to be only MiniChef
90      */
91     modifier onlyMiniChef() {
92         require(msg.sender == MINICHEF, "Rewarder: caller is not MiniChef");
93         _;
94     }
95 
96     /**
97      * @notice Serves as the constructor for clones, as clones can't have a regular constructor.
98      * Initializes state variables with the given parameter.
99      * @param data abi encoded data in format of (IERC20 rewardToken, address owner, uint256 rewardPerSecond, IERC20 masterLpToken, uint256 pid).
100      */
101     function init(bytes calldata data) public payable {
102         require(rewardToken == IERC20(0), "Rewarder: already initialized");
103         address _owner;
104         (rewardToken, _owner, rewardPerSecond, masterLpToken, pid) = abi.decode(
105             data,
106             (IERC20, address, uint256, IERC20, uint256)
107         );
108         require(rewardToken != IERC20(0), "Rewarder: bad rewardToken");
109         require(
110             IMiniChef(MINICHEF).lpToken(pid) == masterLpToken,
111             "Rewarder: bad pid or masterLpToken"
112         );
113         transferOwnership(_owner, true, false);
114         emit LogInit(rewardToken, _owner, rewardPerSecond, masterLpToken);
115     }
116 
117     /**
118      * @notice Callback function for when the user claims via the MiniChef contract.
119      * @param _pid PID of the pool it was called for
120      * @param _user address of the user who is claiming rewards
121      * @param to address to send the reward token to
122      * @param lpTokenAmount amount of total lp tokens that the user has it staked
123      */
124     function onSaddleReward(
125         uint256 _pid,
126         address _user,
127         address to,
128         uint256,
129         uint256 lpTokenAmount
130     ) external override onlyMiniChef {
131         require(pid == _pid, "Rewarder: bad pid init");
132 
133         PoolInfo memory pool = updatePool();
134         UserInfo storage user = userInfo[_user];
135         uint256 pending;
136         if (user.amount > 0) {
137             pending = (user.amount.mul(pool.accToken1PerShare) /
138                 ACC_TOKEN_PRECISION).sub(user.rewardDebt);
139             rewardToken.safeTransfer(to, pending);
140         }
141         user.amount = lpTokenAmount;
142         user.rewardDebt =
143             lpTokenAmount.mul(pool.accToken1PerShare) /
144             ACC_TOKEN_PRECISION;
145         emit LogOnReward(_user, pid, pending, to);
146     }
147 
148     /**
149      * @notice Sets the reward token per second to be distributed. Can only be called by the owner.
150      * @param _rewardPerSecond The amount of reward token to be distributed per second.
151      */
152     function setRewardPerSecond(uint256 _rewardPerSecond) public onlyOwner {
153         rewardPerSecond = _rewardPerSecond;
154         emit LogRewardPerSecond(_rewardPerSecond);
155     }
156 
157     /**
158      * @notice View function to see pending rewards for given address
159      * @param _user Address of user.
160      * @return pending reward for a given user.
161      */
162     function pendingToken(address _user) public view returns (uint256 pending) {
163         PoolInfo memory pool = poolInfo;
164         UserInfo storage user = userInfo[_user];
165         uint256 accToken1PerShare = pool.accToken1PerShare;
166         uint256 lpSupply = IMiniChef(MINICHEF).lpToken(pid).balanceOf(MINICHEF);
167         if (block.timestamp > pool.lastRewardTime && lpSupply != 0) {
168             uint256 time = block.timestamp.sub(pool.lastRewardTime);
169             uint256 reward = time.mul(rewardPerSecond);
170             accToken1PerShare = accToken1PerShare.add(
171                 reward.mul(ACC_TOKEN_PRECISION) / lpSupply
172             );
173         }
174         pending = (user.amount.mul(accToken1PerShare) / ACC_TOKEN_PRECISION)
175             .sub(user.rewardDebt);
176     }
177 
178     /**
179      * @notice Returns pending reward tokens addresses and reward amounts for given address.
180      * @dev Since SimpleRewarder supports only one additional reward, the returning arrays will only have one element.
181      * @param user address of the user
182      * @return rewardTokens array of reward tokens' addresses
183      * @return rewardAmounts array of reward tokens' amounts
184      */
185     function pendingTokens(
186         uint256,
187         address user,
188         uint256
189     )
190         external
191         view
192         override
193         returns (IERC20[] memory rewardTokens, uint256[] memory rewardAmounts)
194     {
195         IERC20[] memory _rewardTokens = new IERC20[](1);
196         _rewardTokens[0] = (rewardToken);
197         uint256[] memory _rewardAmounts = new uint256[](1);
198         _rewardAmounts[0] = pendingToken(user);
199         return (_rewardTokens, _rewardAmounts);
200     }
201 
202     /**
203      * @notice Updates the stored rate of emission per share since the last time this function was called.
204      * @dev This is called whenever `onSaddleReward` is called to ensure the rewards are given out with the
205      * correct emission rate.
206      */
207     function updatePool() public returns (PoolInfo memory pool) {
208         pool = poolInfo;
209         if (block.timestamp > pool.lastRewardTime) {
210             uint256 lpSupply = IMiniChef(MINICHEF).lpToken(pid).balanceOf(
211                 MINICHEF
212             );
213 
214             if (lpSupply > 0) {
215                 uint256 time = block.timestamp.sub(pool.lastRewardTime);
216                 uint256 reward = time.mul(rewardPerSecond);
217                 pool.accToken1PerShare = pool.accToken1PerShare.add(
218                     (reward.mul(ACC_TOKEN_PRECISION) / lpSupply).to128()
219                 );
220             }
221             pool.lastRewardTime = block.timestamp.to64();
222             poolInfo = pool;
223             emit LogUpdatePool(
224                 pid,
225                 pool.lastRewardTime,
226                 lpSupply,
227                 pool.accToken1PerShare
228             );
229         }
230     }
231 }
