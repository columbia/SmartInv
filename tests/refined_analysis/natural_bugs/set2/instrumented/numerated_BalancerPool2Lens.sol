1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.10;
3 
4 import "./IVault.sol";
5 import "./IWeightedPool.sol";
6 import "../../external/gyro/ExtendedMath.sol";
7 import "../IPCVDepositBalances.sol";
8 import "../../oracle/IOracle.sol";
9 import "../../Constants.sol";
10 
11 /// @title BalancerPool2Lens
12 /// @author Fei Protocol
13 /// @notice a contract to read tokens & fei out of a contract that reports balance in Balancer LP tokens.
14 /// Limited to BPTs that have 2 underlying tokens.
15 /// @notice this contract use code similar to BPTLens (that reads a whole pool).
16 contract BalancerPool2Lens is IPCVDepositBalances {
17     using ExtendedMath for uint256;
18 
19     /// @notice FEI token address
20     address private constant FEI = 0x956F47F50A910163D8BF957Cf5846D573E7f87CA;
21 
22     /// @notice the deposit inspected
23     address public immutable depositAddress;
24 
25     /// @notice the token the lens reports balances in
26     address public immutable override balanceReportedIn;
27 
28     /// @notice the balancer pool to look at
29     IWeightedPool public immutable pool;
30 
31     /// @notice the Balancer V2 Vault
32     IVault public immutable balancerVault;
33 
34     // the pool id on balancer
35     bytes32 internal immutable id;
36 
37     // the index of balanceReportedIn on the pool
38     uint256 internal immutable index;
39 
40     /// @notice true if FEI is in the pair
41     bool public immutable feiInPair;
42 
43     /// @notice true if FEI is the reported balance
44     bool public immutable feiIsReportedIn;
45 
46     /// @notice the oracle for balanceReportedIn token
47     IOracle public immutable reportedOracle;
48 
49     /// @notice the oracle for the other token in the pair (not balanceReportedIn)
50     IOracle public immutable otherOracle;
51 
52     constructor(
53         address _depositAddress,
54         address _token,
55         IWeightedPool _pool,
56         IOracle _reportedOracle,
57         IOracle _otherOracle,
58         bool _feiIsReportedIn,
59         bool _feiIsOther
60     ) {
61         depositAddress = _depositAddress;
62 
63         pool = _pool;
64         IVault _vault = _pool.getVault();
65         balancerVault = _vault;
66 
67         bytes32 _id = _pool.getPoolId();
68         id = _id;
69         (IERC20[] memory tokens, , ) = _vault.getPoolTokens(_id);
70 
71         // Check the token is in the BPT and its only a 2 token pool
72         require(address(tokens[0]) == _token || address(tokens[1]) == _token);
73         require(tokens.length == 2);
74         balanceReportedIn = _token;
75 
76         index = address(tokens[0]) == _token ? 0 : 1;
77 
78         feiIsReportedIn = _feiIsReportedIn;
79         feiInPair = _feiIsReportedIn || _feiIsOther;
80 
81         reportedOracle = _reportedOracle;
82         otherOracle = _otherOracle;
83     }
84 
85     function balance() public view override returns (uint256) {
86         (, uint256[] memory balances, ) = balancerVault.getPoolTokens(id);
87         uint256 bptsOwned = IPCVDepositBalances(depositAddress).balance();
88         uint256 totalSupply = pool.totalSupply();
89 
90         return (balances[index] * bptsOwned) / totalSupply;
91     }
92 
93     function resistantBalanceAndFei() public view override returns (uint256, uint256) {
94         uint256[] memory prices = new uint256[](2);
95         uint256 j = index == 0 ? 1 : 0;
96 
97         // Check oracles and fill in prices
98         (Decimal.D256 memory reportedPrice, bool reportedValid) = reportedOracle.read();
99         prices[index] = reportedPrice.value;
100 
101         (Decimal.D256 memory otherPrice, bool otherValid) = otherOracle.read();
102         prices[j] = otherPrice.value;
103 
104         require(reportedValid && otherValid, "BPTLens: Invalid Oracle");
105 
106         (, uint256[] memory balances, ) = balancerVault.getPoolTokens(id);
107         uint256 bptsOwned = IPCVDepositBalances(depositAddress).balance();
108         uint256 totalSupply = pool.totalSupply();
109 
110         uint256[] memory weights = pool.getNormalizedWeights();
111 
112         // uses balances, weights, and prices to calculate manipulation resistant reserves
113         uint256 reserves = _getIdealReserves(balances, prices, weights, index);
114         // if the deposit owns x% of the pool, only keep x% of the reserves
115         reserves = (reserves * bptsOwned) / totalSupply;
116 
117         if (feiIsReportedIn) {
118             return (reserves, reserves);
119         }
120         if (feiInPair) {
121             uint256 otherReserves = _getIdealReserves(balances, prices, weights, j);
122             otherReserves = (otherReserves * bptsOwned) / totalSupply;
123             return (reserves, otherReserves);
124         }
125         return (reserves, 0);
126     }
127 
128     /*
129         let r represent reserves and r' be ideal reserves (derived from manipulation resistant variables)
130         p are resistant oracle prices of the tokens
131         w are the balancer weights
132         k is the balancer invariant
133 
134         BPTPrice = (p0/w0)^w0 * (p1/w1)^w1 * k
135         r0' = BPTPrice * w0/p0
136         r0' = ((w0*p1)/(p0*w1))^w1 * k
137 
138         Now including k allows for further simplification
139         k = r0^w0 * r1^w1
140 
141         r0' = r0^w0 * r1^w1 * ((w0*p1)/(p0*w1))^w1
142         r0' = r0^w0 * ((w0*p1*r1)/(p0*w1))^w1
143     */
144     function _getIdealReserves(
145         uint256[] memory balances,
146         uint256[] memory prices,
147         uint256[] memory weights,
148         uint256 i
149     ) internal pure returns (uint256 reserves) {
150         uint256 j = i == 0 ? 1 : 0;
151 
152         uint256 one = Constants.ETH_GRANULARITY;
153 
154         uint256 reservesScaled = one.mulPow(balances[i], weights[i], Constants.ETH_DECIMALS);
155         uint256 multiplier = (weights[i] * prices[j] * balances[j]) / (prices[i] * weights[j]);
156 
157         reserves = reservesScaled.mulPow(multiplier, weights[j], Constants.ETH_DECIMALS);
158     }
159 }
