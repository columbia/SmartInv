1 // SPDX-License-Identifier: BUSL-1.1
2 pragma solidity ^0.8.0;
3 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
4 
5 import "./IncentiveDistribution.sol";
6 import "./RoleAware.sol";
7 import "./Fund.sol";
8 import "./CrossMarginTrading.sol";
9 
10 /** 
11 @title Here we support staking for MFI incentives as well as
12 staking to perform the maintenance role.
13 */
14 contract Admin is RoleAware, Ownable {
15     /// Marginswap (MFI) token address
16     address public immutable MFI;
17     mapping(address => uint256) public stakes;
18     uint256 public totalStakes;
19 
20     uint256 public maintenanceStakePerBlock = 10 ether;
21     mapping(address => address) public nextMaintenanceStaker;
22     mapping(address => mapping(address => bool)) public maintenanceDelegateTo;
23     address public currentMaintenanceStaker;
24     address public prevMaintenanceStaker;
25     uint256 public currentMaintenanceStakerStartBlock;
26     address public immutable lockedMFI;
27 
28     constructor(
29         address _MFI,
30         address _lockedMFI,
31         address lockedMFIDelegate,
32         address _roles
33     ) RoleAware(_roles) Ownable() {
34         MFI = _MFI;
35         maintenanceStakePerBlock = 1 ether;
36         lockedMFI = _lockedMFI;
37 
38         // for initialization purposes and to ensure availability of service
39         // the team's locked MFI participate in maintenance staking only
40         // (not in the incentive staking part)
41         // this implies some trust of the team to execute, which we deem reasonable
42         // since the locked stake is temporary and diminishing as well as the fact
43         // that the team is heavily invested in the protocol and incentivized
44         // by fees like any other maintainer
45         // furthermore others could step in to liquidate via the attacker route
46         // and take away the team fees if they were delinquent
47         nextMaintenanceStaker[_lockedMFI] = _lockedMFI;
48         currentMaintenanceStaker = _lockedMFI;
49         prevMaintenanceStaker = _lockedMFI;
50         maintenanceDelegateTo[_lockedMFI][lockedMFIDelegate];
51         currentMaintenanceStakerStartBlock = block.number;
52     }
53 
54     /// Maintence stake setter
55     function setMaintenanceStakePerBlock(uint256 amount) external onlyOwner {
56         maintenanceStakePerBlock = amount;
57     }
58 
59     function _stake(address holder, uint256 amount) internal {
60         Fund(fund()).depositFor(holder, MFI, amount);
61 
62         stakes[holder] += amount;
63         totalStakes += amount;
64 
65         IncentiveDistribution(incentiveDistributor()).addToClaimAmount(
66             1,
67             holder,
68             amount
69         );
70     }
71 
72     /// Deposit a stake for sender
73     function depositStake(uint256 amount) external {
74         _stake(msg.sender, amount);
75     }
76 
77     function _withdrawStake(
78         address holder,
79         uint256 amount,
80         address recipient
81     ) internal {
82         // overflow failure desirable
83         stakes[holder] -= amount;
84         totalStakes -= amount;
85         Fund(fund()).withdraw(MFI, recipient, amount);
86 
87         IncentiveDistribution(incentiveDistributor()).subtractFromClaimAmount(
88             1,
89             holder,
90             amount
91         );
92     }
93 
94     /// Withdraw stake for sender
95     function withdrawStake(uint256 amount) external {
96         require(
97             !isAuthorizedStaker(msg.sender),
98             "You can't withdraw while you're authorized staker"
99         );
100         _withdrawStake(msg.sender, amount, msg.sender);
101     }
102 
103     /// Deposit maintenance stake
104     function depositMaintenanceStake(uint256 amount) external {
105         require(
106             amount + stakes[msg.sender] >= maintenanceStakePerBlock,
107             "Insufficient stake to call even one block"
108         );
109         _stake(msg.sender, amount);
110         if (nextMaintenanceStaker[msg.sender] == address(0)) {
111             nextMaintenanceStaker[msg.sender] = getUpdatedCurrentStaker();
112             nextMaintenanceStaker[prevMaintenanceStaker] = msg.sender;
113         }
114     }
115 
116     function getMaintenanceStakerStake(address staker)
117         public
118         view
119         returns (uint256)
120     {
121         if (staker == lockedMFI) {
122             return IERC20(MFI).balanceOf(lockedMFI) / 2;
123         } else {
124             return stakes[staker];
125         }
126     }
127 
128     function getUpdatedCurrentStaker() public returns (address) {
129         uint256 currentStake =
130             getMaintenanceStakerStake(currentMaintenanceStaker);
131         while (
132             (block.number - currentMaintenanceStakerStartBlock) *
133                 maintenanceStakePerBlock >=
134             currentStake
135         ) {
136             if (maintenanceStakePerBlock > currentStake) {
137                 // delete current from daisy chain
138                 address nextOne =
139                     nextMaintenanceStaker[currentMaintenanceStaker];
140                 nextMaintenanceStaker[prevMaintenanceStaker] = nextOne;
141                 nextMaintenanceStaker[currentMaintenanceStaker] = address(0);
142 
143                 currentMaintenanceStaker = nextOne;
144             } else {
145                 currentMaintenanceStakerStartBlock +=
146                     currentStake /
147                     maintenanceStakePerBlock;
148 
149                 prevMaintenanceStaker = currentMaintenanceStaker;
150                 currentMaintenanceStaker = nextMaintenanceStaker[
151                     currentMaintenanceStaker
152                 ];
153             }
154             currentStake = getMaintenanceStakerStake(currentMaintenanceStaker);
155         }
156         return currentMaintenanceStaker;
157     }
158 
159     function viewCurrentMaintenanceStaker()
160         public
161         view
162         returns (address staker, uint256 startBlock)
163     {
164         staker = currentMaintenanceStaker;
165         uint256 currentStake = getMaintenanceStakerStake(staker);
166         startBlock = currentMaintenanceStakerStartBlock;
167         while (
168             (block.number - startBlock) * maintenanceStakePerBlock >=
169             currentStake
170         ) {
171             if (maintenanceStakePerBlock > currentStake) {
172                 // skip
173                 staker = nextMaintenanceStaker[staker];
174                 currentStake = getMaintenanceStakerStake(staker);
175             } else {
176                 startBlock += currentStake / maintenanceStakePerBlock;
177                 staker = nextMaintenanceStaker[staker];
178                 currentStake = getMaintenanceStakerStake(staker);
179             }
180         }
181     }
182 
183     /// Add a delegate for staker
184     function addDelegate(address forStaker, address delegate) external {
185         require(
186             msg.sender == forStaker ||
187                 maintenanceDelegateTo[forStaker][msg.sender],
188             "msg.sender not authorized to delegate for staker"
189         );
190         maintenanceDelegateTo[forStaker][delegate] = true;
191     }
192 
193     /// Remove a delegate for staker
194     function removeDelegate(address forStaker, address delegate) external {
195         require(
196             msg.sender == forStaker ||
197                 maintenanceDelegateTo[forStaker][msg.sender],
198             "msg.sender not authorized to delegate for staker"
199         );
200         maintenanceDelegateTo[forStaker][delegate] = false;
201     }
202 
203     function isAuthorizedStaker(address caller)
204         public
205         returns (bool isAuthorized)
206     {
207         address currentStaker = getUpdatedCurrentStaker();
208         isAuthorized =
209             currentStaker == caller ||
210             maintenanceDelegateTo[currentStaker][caller];
211     }
212 
213     /// Penalize a staker
214     function penalizeMaintenanceStake(
215         address maintainer,
216         uint256 penalty,
217         address recipient
218     ) external returns (uint256 stakeTaken) {
219         require(
220             isStakePenalizer(msg.sender),
221             "msg.sender not authorized to penalize stakers"
222         );
223         if (penalty > stakes[maintainer]) {
224             stakeTaken = stakes[maintainer];
225         } else {
226             stakeTaken = penalty;
227         }
228         _withdrawStake(maintainer, stakeTaken, recipient);
229     }
230 }
