1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity 0.8.9;
3 
4 import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
5 import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
6 
7 import "../../interfaces/IController.sol";
8 import "../../interfaces/tokenomics/IBkdToken.sol";
9 
10 import "../../libraries/Errors.sol";
11 import "../../libraries/ScaledMath.sol";
12 import "../../libraries/AddressProviderHelpers.sol";
13 
14 import "./BkdToken.sol";
15 import "../access/Authorization.sol";
16 
17 contract Minter is Authorization, ReentrancyGuard {
18     using ScaledMath for uint256;
19     using AddressProviderHelpers for IAddressProvider;
20 
21     uint256 private constant _INFLATION_DECAY_PERIOD = 365 days;
22 
23     // Lp Rates
24     uint256 public immutable initialAnnualInflationRateLp;
25     uint256 public immutable annualInflationDecayLp;
26     uint256 public currentInflationAmountLp;
27 
28     // Keeper Rates
29     uint256 public immutable initialPeriodKeeperInflation;
30     uint256 public immutable initialAnnualInflationRateKeeper;
31     uint256 public immutable annualInflationDecayKeeper;
32     uint256 public currentInflationAmountKeeper;
33 
34     // AMM Rates
35     uint256 public immutable initialPeriodAmmInflation;
36     uint256 public immutable initialAnnualInflationRateAmm;
37     uint256 public immutable annualInflationDecayAmm;
38     uint256 public currentInflationAmountAmm;
39 
40     bool public initialPeriodEnded;
41 
42     // Non-inflation rates
43     uint256 public immutable nonInflationDistribution;
44     uint256 public issuedNonInflationSupply;
45 
46     uint256 public lastInflationDecay;
47     uint256 public currentTotalInflation;
48 
49     // Used for final safety check to ensure inflation is not exceeded
50     uint256 public totalAvailableToNow;
51     uint256 public totalMintedToNow;
52     uint256 public lastEvent;
53 
54     IController public immutable controller;
55     BkdToken public token;
56 
57     event TokensMinted(address beneficiary, uint256 amount);
58 
59     constructor(
60         uint256 _annualInflationRateLp,
61         uint256 _annualInflationRateKeeper,
62         uint256 _annualInflationRateAmm,
63         uint256 _annualInflationDecayLp,
64         uint256 _annualInflationDecayKeeper,
65         uint256 _annualInflationDecayAmm,
66         uint256 _initialPeriodKeeperInflation,
67         uint256 _initialPeriodAmmInflation,
68         uint256 _nonInflationDistribution,
69         IController _controller
70     ) Authorization(_controller.addressProvider().getRoleManager()) {
71         require(_annualInflationDecayLp < ScaledMath.ONE, Error.INVALID_PARAMETER_VALUE);
72         require(_annualInflationDecayKeeper < ScaledMath.ONE, Error.INVALID_PARAMETER_VALUE);
73         require(_annualInflationDecayAmm < ScaledMath.ONE, Error.INVALID_PARAMETER_VALUE);
74         initialAnnualInflationRateLp = _annualInflationRateLp;
75         initialAnnualInflationRateKeeper = _annualInflationRateKeeper;
76         initialAnnualInflationRateAmm = _annualInflationRateAmm;
77 
78         annualInflationDecayLp = _annualInflationDecayLp;
79         annualInflationDecayKeeper = _annualInflationDecayKeeper;
80         annualInflationDecayAmm = _annualInflationDecayAmm;
81 
82         initialPeriodKeeperInflation = _initialPeriodKeeperInflation;
83         initialPeriodAmmInflation = _initialPeriodAmmInflation;
84 
85         currentInflationAmountLp = _annualInflationRateLp / _INFLATION_DECAY_PERIOD;
86         currentInflationAmountKeeper = _initialPeriodKeeperInflation / _INFLATION_DECAY_PERIOD;
87         currentInflationAmountAmm = _initialPeriodAmmInflation / _INFLATION_DECAY_PERIOD;
88 
89         currentTotalInflation =
90             currentInflationAmountLp +
91             currentInflationAmountKeeper +
92             currentInflationAmountAmm;
93 
94         nonInflationDistribution = _nonInflationDistribution;
95         controller = _controller;
96     }
97 
98     function setToken(address _token) external onlyGovernance {
99         require(address(token) == address(0), "Token already set!");
100         token = BkdToken(_token);
101     }
102 
103     function startInflation() external onlyGovernance {
104         require(lastEvent == 0, "Inflation has already started.");
105         lastEvent = block.timestamp;
106         lastInflationDecay = block.timestamp;
107     }
108 
109     /**
110      * @notice Update the inflation rate according to the piecewise linear schedule.
111      * @dev This updates the inflation rate to the next linear segment in the inflations schedule.
112      * @return `true` if successful.
113      */
114     function executeInflationRateUpdate() external returns (bool) {
115         return _executeInflationRateUpdate();
116     }
117 
118     /**
119      * @notice Mints BKD tokens to a specified address.
120      * @dev Can only be called by the controller.
121      * @param beneficiary Address to mint tokens for.
122      * @param amount Amount of tokens to mint.
123      * @return `true` if successful.
124      */
125     function mint(address beneficiary, uint256 amount) external nonReentrant returns (bool) {
126         require(msg.sender == address(controller.inflationManager()), Error.UNAUTHORIZED_ACCESS);
127         if (lastEvent == 0) return false;
128         return _mint(beneficiary, amount);
129     }
130 
131     /**
132      * @notice Mint tokens that are not part of the inflation schedule.
133      * @dev The amount of tokens that can be minted in total is subject to a pre-set upper limit.
134      * @param beneficiary Address to mint tokens for.
135      * @param amount Amount of tokens to mint.
136      * @return `true` if successful.
137      */
138     function mintNonInflationTokens(address beneficiary, uint256 amount)
139         external
140         onlyGovernance
141         returns (bool)
142     {
143         require(
144             issuedNonInflationSupply + amount <= nonInflationDistribution,
145             "Maximum non-inflation amount exceeded."
146         );
147         issuedNonInflationSupply += amount;
148         token.mint(beneficiary, amount);
149         emit TokensMinted(beneficiary, amount);
150         return true;
151     }
152 
153     /**
154      * @notice Supplies the inflation rate for LPs per unit of time (seconds).
155      * @return LP inflation rate.
156      */
157     function getLpInflationRate() external view returns (uint256) {
158         if (lastEvent == 0) return 0;
159         return currentInflationAmountLp;
160     }
161 
162     /**
163      * @notice Supplies the inflation rate for keepers per unit of time (seconds).
164      * @return keeper inflation rate.
165      */
166     function getKeeperInflationRate() external view returns (uint256) {
167         if (lastEvent == 0) return 0;
168         return currentInflationAmountKeeper;
169     }
170 
171     /**
172      * @notice Supplies the inflation rate for LPs on AMMs per unit of time (seconds).
173      * @return AMM inflation rate.
174      */
175     function getAmmInflationRate() external view returns (uint256) {
176         if (lastEvent == 0) return 0;
177         return currentInflationAmountAmm;
178     }
179 
180     function _executeInflationRateUpdate() internal returns (bool) {
181         totalAvailableToNow += (currentTotalInflation * (block.timestamp - lastEvent));
182         lastEvent = block.timestamp;
183         if (block.timestamp >= lastInflationDecay + _INFLATION_DECAY_PERIOD) {
184             currentInflationAmountLp = currentInflationAmountLp.scaledMul(annualInflationDecayLp);
185             if (initialPeriodEnded) {
186                 currentInflationAmountKeeper = currentInflationAmountKeeper.scaledMul(
187                     annualInflationDecayKeeper
188                 );
189                 currentInflationAmountAmm = currentInflationAmountAmm.scaledMul(
190                     annualInflationDecayAmm
191                 );
192             } else {
193                 currentInflationAmountKeeper =
194                     initialAnnualInflationRateKeeper /
195                     _INFLATION_DECAY_PERIOD;
196 
197                 currentInflationAmountAmm = initialAnnualInflationRateAmm / _INFLATION_DECAY_PERIOD;
198                 initialPeriodEnded = true;
199             }
200             currentTotalInflation =
201                 currentInflationAmountLp +
202                 currentInflationAmountKeeper +
203                 currentInflationAmountAmm;
204             controller.inflationManager().checkpointAllGauges();
205             lastInflationDecay = block.timestamp;
206         }
207         return true;
208     }
209 
210     function _mint(address beneficiary, uint256 amount) internal returns (bool) {
211         totalAvailableToNow += ((block.timestamp - lastEvent) * currentTotalInflation);
212         uint256 newTotalMintedToNow = totalMintedToNow + amount;
213         require(newTotalMintedToNow <= totalAvailableToNow, "Mintable amount exceeded");
214         totalMintedToNow = newTotalMintedToNow;
215         lastEvent = block.timestamp;
216         token.mint(beneficiary, amount);
217         _executeInflationRateUpdate();
218         emit TokensMinted(beneficiary, amount);
219         return true;
220     }
221 }
