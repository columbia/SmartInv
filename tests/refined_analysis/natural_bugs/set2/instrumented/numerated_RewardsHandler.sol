1 // SPDX-License-Identifier: GNU-GPL v3.0 or later
2 
3 pragma solidity ^0.8.0;
4 
5 import "./interfaces/IRewardsHandler.sol";
6 import "./utils/RevestAccessControl.sol";
7 import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";
8 import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
9 import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
10 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
11 
12 contract RewardsHandler is RevestAccessControl, IRewardsHandler {
13     using SafeERC20 for IERC20;
14 
15     address internal immutable WETH;
16     address internal immutable RVST;
17     address public STAKING;
18     uint public constant PRECISION = 10**27;
19 
20     uint public erc20Fee; // out of 1000
21     uint constant public erc20multiplierPrecision = 1000;
22 
23     /**
24      allocPoints is the same for all reward tokens (WETH vs RVST)
25      lastMul is different for staking types (LP vs basic)
26      */
27 
28     mapping(uint => UserBalance) public wethBasicBalances;
29     mapping(uint => UserBalance) public wethLPBalances;
30     mapping(uint => UserBalance) public rvstBasicBalances;
31     mapping(uint => UserBalance) public rvstLPBalances;
32 
33     uint public wethBasicGlobalMul = PRECISION;
34     uint public wethLPGlobalMul = PRECISION;
35     uint public rvstBasicGlobalMul = PRECISION;
36     uint public rvstLPGlobalMul = PRECISION;
37     uint public totalLPAllocPoint = 1; // Total allocation points. Must be the sum of all allocation points. We start at 1 to avoid divide-by-zero
38     uint public totalBasicAllocPoint = 1;
39 
40     constructor(address provider, address weth, address rvst) RevestAccessControl(provider) {
41         WETH = weth;
42         RVST = rvst;
43     }
44 
45     /**
46      * When receiving new allocPoint, you have to adjust the multiplier accordingly. Claim rewards as part of this
47      * `allocPoint` will always be the same for WETH and RVST, but we need to update them both
48      */
49     function updateLPShares(uint fnftId, uint newAllocPoint) external override onlyStakingContract {
50         // allocPoint is the same for wethBasic and rvstBasic
51         totalLPAllocPoint = totalLPAllocPoint + newAllocPoint - wethLPBalances[fnftId].allocPoint;
52 
53         wethLPBalances[fnftId].allocPoint = newAllocPoint;
54         wethLPBalances[fnftId].lastMul = wethLPGlobalMul;
55         rvstLPBalances[fnftId].allocPoint = newAllocPoint;
56         rvstLPBalances[fnftId].lastMul = rvstLPGlobalMul;
57     }
58 
59     function updateBasicShares(uint fnftId, uint newAllocPoint) external override onlyStakingContract {
60         // allocPoint is the same for wethBasic and rvstBasic
61         totalBasicAllocPoint = totalBasicAllocPoint + newAllocPoint - wethBasicBalances[fnftId].allocPoint;
62 
63         wethBasicBalances[fnftId].allocPoint = newAllocPoint;
64         wethBasicBalances[fnftId].lastMul = wethBasicGlobalMul;
65         rvstBasicBalances[fnftId].allocPoint = newAllocPoint;
66         rvstBasicBalances[fnftId].lastMul = rvstBasicGlobalMul;
67     }
68 
69     /**
70      * We require claiming all rewards simultaneously for simplicity
71      * 0 = has neither, 1 = WETH, 2 = RVST, 3 = BOTH
72      * Implicit assumption that user is authenticated to this FNFT prior to claiming
73      */
74     function claimRewards(uint fnftId, address caller) external override onlyStakingContract returns (uint) {
75         bool hasWeth = claimRewardsForToken(fnftId, WETH, caller);
76         bool hasRVST = claimRewardsForToken(fnftId, RVST, caller);
77         if(hasWeth) {
78             if(hasRVST) {
79                 return 3;
80             } else {
81                 return 1;
82             }
83         }
84         return hasRVST ? 2 : 0;
85     }
86 
87     function claimRewardsForToken(uint fnftId, address token, address user) internal returns (bool) {
88         (UserBalance storage lpBalance, UserBalance storage basicBalance) = getBalances(fnftId, token);
89         uint amount = rewardsOwed(token, lpBalance, basicBalance);
90         lpBalance.lastMul = getLPGlobalMul(token);
91         basicBalance.lastMul = getBasicGlobalMul(token);
92 
93         IERC20(token).safeTransfer(user, amount);
94         return amount > 0;
95     }
96 
97     function getRewards(uint fnftId, address token) external view override returns (uint) {
98         (UserBalance memory lpBalance, UserBalance memory basicBalance) = getBalances(fnftId, token);
99         uint rewards = rewardsOwed(token, lpBalance, basicBalance);
100         return rewards;
101     }
102 
103     /**
104      * Precondition: fee is already approved by msg sender
105      * This simple function increments the multiplier for everyone with existing positions
106      * Hence it covers the case where someone enters later, they start with a higher multiplier.
107      * We increment totalAllocPoint with new depositors, and increment curMul with new income.
108      */
109     function receiveFee(address token, uint amount) external override {
110         require(token == WETH || token == RVST, "Only WETH and RVST supported");
111         IERC20(token).safeTransferFrom(msg.sender, address(this), amount);
112         if(totalLPAllocPoint + totalBasicAllocPoint > 0) {
113             uint basicMulInc = (amount * PRECISION / 2) / totalBasicAllocPoint;
114             uint lpMulInc = (amount * PRECISION / 2) / totalLPAllocPoint;
115             setBasicGlobalMul(token, getBasicGlobalMul(token) + basicMulInc);
116             setLPGlobalMul(token, getLPGlobalMul(token) + lpMulInc);
117         }
118     }
119 
120     function getAllocPoint(uint fnftId, address token, bool isBasic) external view override returns (uint) {
121         if (token == WETH) {
122             return isBasic ? wethBasicBalances[fnftId].allocPoint : wethLPBalances[fnftId].allocPoint;
123         } else {
124             return isBasic ? rvstBasicBalances[fnftId].allocPoint : rvstLPBalances[fnftId].allocPoint;
125         }
126     }
127 
128     function setStakingContract(address stake) external override onlyOwner {
129         STAKING = stake;
130     }
131 
132     // INTERNAL FUNCTIONS
133 
134     /**
135      * View-only function. Does not update any balances.
136      */
137     function rewardsOwed(address token, UserBalance memory lpBalance, UserBalance memory basicBalance) internal view returns (uint) {
138         uint globalBalance = IERC20(token).balanceOf(address(this));
139         uint lpRewards = (getLPGlobalMul(token) - lpBalance.lastMul) * lpBalance.allocPoint;
140         uint basicRewards = (getBasicGlobalMul(token) - basicBalance.lastMul) * basicBalance.allocPoint;
141         uint tokenAmount = (lpRewards + basicRewards) / PRECISION;
142         return tokenAmount;
143     }
144 
145     function getBalances(uint fnftId, address token) internal view returns (UserBalance storage, UserBalance storage) {
146         return token == WETH ? (wethLPBalances[fnftId], wethBasicBalances[fnftId]) : (rvstLPBalances[fnftId], rvstBasicBalances[fnftId]);
147     }
148 
149     function getLPGlobalMul(address token) internal view returns (uint) {
150         return token == WETH ? wethLPGlobalMul : rvstLPGlobalMul;
151     }
152 
153     function setLPGlobalMul(address token, uint newMul) internal {
154         if (token == WETH) {
155             wethLPGlobalMul = newMul;
156         } else {
157             rvstLPGlobalMul = newMul;
158         }
159     }
160 
161     function getBasicGlobalMul(address token) internal view returns (uint) {
162         return token == WETH ? wethBasicGlobalMul : rvstBasicGlobalMul;
163     }
164 
165     function setBasicGlobalMul(address token, uint newMul) internal {
166         if (token == WETH) {
167             wethBasicGlobalMul = newMul;
168         } else {
169             rvstBasicGlobalMul = newMul;
170         }
171     }
172 
173     // Admin functions for migration
174     // To be fully abandoned in future via contract-based owner
175     // Apart from setStakingContract
176 
177     function manualMapRVSTBasic(
178         uint[] memory fnfts,
179         uint[] memory allocPoints
180     ) external onlyOwner {
181         for(uint i = 0; i < fnfts.length; i++) {
182             UserBalance storage userBal = rvstBasicBalances[fnfts[i]];
183             userBal.allocPoint = allocPoints[i];
184             userBal.lastMul = rvstBasicGlobalMul;
185         }
186     }
187 
188     function manualMapRVSTLP(
189         uint[] memory fnfts,
190         uint[] memory allocPoints
191     ) external onlyOwner {
192         for(uint i = 0; i < fnfts.length; i++) {
193             UserBalance storage userBal = rvstLPBalances[fnfts[i]];
194             userBal.allocPoint = allocPoints[i];
195             userBal.lastMul = rvstLPGlobalMul;
196         }
197     }
198 
199     function manualMapWethBasic(
200         uint[] memory fnfts,
201         uint[] memory allocPoints
202     ) external onlyOwner {
203         for(uint i = 0; i < fnfts.length; i++) {
204             UserBalance storage userBal = wethBasicBalances[fnfts[i]];
205             userBal.allocPoint = allocPoints[i];
206             userBal.lastMul = wethBasicGlobalMul;
207         }
208     }
209 
210     function manualMapWethLP(
211         uint[] memory fnfts,
212         uint[] memory allocPoints
213     ) external onlyOwner {
214         for(uint i = 0; i < fnfts.length; i++) {
215             UserBalance storage userBal = wethLPBalances[fnfts[i]];
216             userBal.allocPoint = allocPoints[i];
217             userBal.lastMul = wethLPGlobalMul;
218         }
219     }
220 
221     function manualSetAllocPoints(uint _totalBasic, uint _totalLP) external onlyOwner {
222         if (_totalBasic > 0) {
223             totalBasicAllocPoint = _totalBasic;
224         }
225         if (_totalLP > 0) {
226             totalLPAllocPoint = _totalLP;
227         }
228     }
229 
230     modifier onlyStakingContract() {
231         require(_msgSender() != address(0), "E004");
232         require(_msgSender() == STAKING, "E060");
233         _;
234     }
235 
236 }
