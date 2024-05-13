1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "./MockERC20.sol";
5 import "./MockVault.sol";
6 import "../pcv/balancer/IVault.sol";
7 
8 contract MockWeightedPool is MockERC20 {
9     uint256 public _startTime;
10     uint256 public _endTime;
11     uint256[] public _endWeights;
12 
13     MockVault public immutable getVault;
14     bytes32 public constant getPoolId = bytes32(uint256(1));
15     address public immutable getOwner;
16 
17     bool public getSwapEnabled;
18     bool public getPaused;
19     uint256 public getSwapFeePercentage;
20     uint256[] public weights; // normalized weights
21     uint256 rate = 1e18; // rate of the LP tokens vs underlying (for stable pools)
22 
23     constructor(MockVault vault, address owner) {
24         getOwner = owner;
25         getVault = vault;
26         mint(address(this), 1); // prevents totalSupply() to be 0
27         weights = new uint256[](2);
28         weights[0] = 5e17;
29         weights[1] = 5e17;
30     }
31 
32     function mockInitApprovals() external {
33         for (uint256 i = 0; i < weights.length; i++) {
34             getVault._tokens(i).approve(address(getVault), type(uint256).max);
35         }
36     }
37 
38     function mockSetNormalizedWeights(uint256[] memory _weights) external {
39         weights = _weights;
40     }
41 
42     // this method is specific to weighted pool
43     function getNormalizedWeights() external view returns (uint256[] memory _weights) {
44         return weights;
45     }
46 
47     // this method is specific to stable pool, but for convenience we just need
48     // one mock balancer pool
49     function getRate() external view returns (uint256) {
50         return rate;
51     }
52 
53     function mockSetRate(uint256 _rate) external {
54         rate = _rate;
55     }
56 
57     function getGradualWeightUpdateParams()
58         external
59         view
60         returns (
61             uint256 startTime,
62             uint256 endTime,
63             uint256[] memory endWeights
64         )
65     {
66         return (_startTime, _endTime, _endWeights);
67     }
68 
69     function setSwapEnabled(bool swapEnabled) external {
70         getSwapEnabled = swapEnabled;
71     }
72 
73     function updateWeightsGradually(
74         uint256 startTime,
75         uint256 endTime,
76         uint256[] memory endWeights
77     ) external {
78         _startTime = startTime;
79         _endTime = endTime;
80         _endWeights = endWeights;
81     }
82 
83     function setSwapFeePercentage(uint256 swapFeePercentage) external {
84         getSwapFeePercentage = swapFeePercentage;
85     }
86 
87     function setPaused(bool paused) external {
88         getPaused = paused;
89     }
90 }
