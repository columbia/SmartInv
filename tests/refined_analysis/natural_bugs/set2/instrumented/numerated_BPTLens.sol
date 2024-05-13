1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.0;
3 
4 import "./IVault.sol";
5 import "./IWeightedPool.sol";
6 import "../../external/gyro/ExtendedMath.sol";
7 import "../IPCVDepositBalances.sol";
8 import "../../oracle/IOracle.sol";
9 import "../../Constants.sol";
10 
11 /// @title BPTLens
12 /// @author Fei Protocol
13 /// @notice a contract to read manipulation resistant balances from BPTs
14 contract BPTLens is IPCVDepositBalances {
15     using ExtendedMath for uint256;
16 
17     /// @notice the token the lens reports balances in
18     address public immutable override balanceReportedIn;
19 
20     /// @notice the balancer pool to look at
21     IWeightedPool public immutable pool;
22 
23     /// @notice the Balancer V2 Vault
24     IVault public immutable VAULT;
25 
26     // the pool id on balancer
27     bytes32 internal immutable id;
28 
29     // the index of balanceReportedIn on the pool
30     uint256 internal immutable index;
31 
32     /// @notice true if FEI is in the pair
33     bool public immutable feiInPair;
34 
35     /// @notice true if FEI is the reported balance
36     bool public immutable feiIsReportedIn;
37 
38     /// @notice the oracle for balanceReportedIn token
39     IOracle public immutable reportedOracle;
40 
41     /// @notice the oracle for the other token in the pair (not balanceReportedIn)
42     IOracle public immutable otherOracle;
43 
44     constructor(
45         address _token,
46         IWeightedPool _pool,
47         IOracle _reportedOracle,
48         IOracle _otherOracle,
49         bool _feiIsReportedIn,
50         bool _feiIsOther
51     ) {
52         pool = _pool;
53         IVault _vault = _pool.getVault();
54         VAULT = _vault;
55 
56         bytes32 _id = _pool.getPoolId();
57         id = _id;
58         (IERC20[] memory tokens, uint256[] memory balances, ) = _vault.getPoolTokens(_id);
59 
60         // Check the token is in the BPT and its only a 2 token pool
61         require(address(tokens[0]) == _token || address(tokens[1]) == _token);
62         require(tokens.length == 2);
63         balanceReportedIn = _token;
64 
65         index = address(tokens[0]) == _token ? 0 : 1;
66 
67         feiIsReportedIn = _feiIsReportedIn;
68         feiInPair = _feiIsReportedIn || _feiIsOther;
69 
70         reportedOracle = _reportedOracle;
71         otherOracle = _otherOracle;
72     }
73 
74     function balance() public view override returns (uint256) {
75         (IERC20[] memory _tokens, uint256[] memory balances, ) = VAULT.getPoolTokens(id);
76 
77         return balances[index];
78     }
79 
80     /**
81      * @notice Calculates the manipulation resistant balances of Balancer pool tokens using the logic described here:
82      * https://docs.gyro.finance/learn/oracles/bpt-oracle
83      * This is robust to price manipulations within the Balancer pool.
84      */
85     function resistantBalanceAndFei() public view override returns (uint256, uint256) {
86         uint256[] memory prices = new uint256[](2);
87         uint256 j = index == 0 ? 1 : 0;
88 
89         // Check oracles and fill in prices
90         (Decimal.D256 memory reportedPrice, bool reportedValid) = reportedOracle.read();
91         prices[index] = reportedPrice.value;
92 
93         (Decimal.D256 memory otherPrice, bool otherValid) = otherOracle.read();
94         prices[j] = otherPrice.value;
95 
96         require(reportedValid && otherValid, "BPTLens: Invalid Oracle");
97 
98         (IERC20[] memory _tokens, uint256[] memory balances, ) = VAULT.getPoolTokens(id);
99 
100         uint256[] memory weights = pool.getNormalizedWeights();
101 
102         // uses balances, weights, and prices to calculate manipulation resistant reserves
103         uint256 reserves = _getIdealReserves(balances, prices, weights, index);
104 
105         if (feiIsReportedIn) {
106             return (reserves, reserves);
107         }
108         if (feiInPair) {
109             uint256 otherReserves = _getIdealReserves(balances, prices, weights, j);
110             return (reserves, otherReserves);
111         }
112         return (reserves, 0);
113     }
114 
115     /*
116         let r represent reserves and r' be ideal reserves (derived from manipulation resistant variables)
117         p are resistant oracle prices of the tokens
118         w are the balancer weights
119         k is the balancer invariant
120 
121         BPTPrice = (p0/w0)^w0 * (p1/w1)^w1 * k
122         r0' = BPTPrice * w0/p0
123         r0' = ((w0*p1)/(p0*w1))^w1 * k
124 
125         Now including k allows for further simplification
126         k = r0^w0 * r1^w1
127 
128         r0' = r0^w0 * r1^w1 * ((w0*p1)/(p0*w1))^w1
129         r0' = r0^w0 * ((w0*p1*r1)/(p0*w1))^w1
130     */
131     function _getIdealReserves(
132         uint256[] memory balances,
133         uint256[] memory prices,
134         uint256[] memory weights,
135         uint256 i
136     ) internal pure returns (uint256 reserves) {
137         uint256 j = i == 0 ? 1 : 0;
138 
139         uint256 one = Constants.ETH_GRANULARITY;
140 
141         uint256 reservesScaled = one.mulPow(balances[i], weights[i], Constants.ETH_DECIMALS);
142         uint256 multiplier = (weights[i] * prices[j] * balances[j]) / (prices[i] * weights[j]);
143 
144         reserves = reservesScaled.mulPow(multiplier, weights[j], Constants.ETH_DECIMALS);
145     }
146 }
