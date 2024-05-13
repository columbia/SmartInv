1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.0;
3 
4 import "./IBasePool.sol";
5 
6 // interface with required methods from Balancer V2 WeightedPool
7 // https://github.com/balancer-labs/balancer-v2-monorepo/blob/389b52f1fc9e468de854810ce9dc3251d2d5b212/pkg/pool-weighted/contracts/WeightedPool.sol
8 interface IWeightedPool is IBasePool {
9     function getSwapEnabled() external view returns (bool);
10 
11     function getNormalizedWeights() external view returns (uint256[] memory);
12 
13     function getGradualWeightUpdateParams()
14         external
15         view
16         returns (
17             uint256 startTime,
18             uint256 endTime,
19             uint256[] memory endWeights
20         );
21 
22     function setSwapEnabled(bool swapEnabled) external;
23 
24     function updateWeightsGradually(
25         uint256 startTime,
26         uint256 endTime,
27         uint256[] memory endWeights
28     ) external;
29 
30     function withdrawCollectedManagementFees(address recipient) external;
31 
32     enum JoinKind {
33         INIT,
34         EXACT_TOKENS_IN_FOR_BPT_OUT,
35         TOKEN_IN_FOR_EXACT_BPT_OUT
36     }
37     enum ExitKind {
38         EXACT_BPT_IN_FOR_ONE_TOKEN_OUT,
39         EXACT_BPT_IN_FOR_TOKENS_OUT,
40         BPT_IN_FOR_EXACT_TOKENS_OUT
41     }
42 }
