1 // SPDX-License-Identifier: BUSL-1.1
2 pragma solidity ^0.8.0;
3 
4 import "./IncentiveDistribution.sol";
5 import "./RoleAware.sol";
6 
7 /// @title helper class to facilitate staking and unstaking
8 /// within the incentive system.
9 abstract contract IncentivizedHolder is RoleAware {
10     /// @dev here we cache incentive tranches to save on a bit of gas
11     mapping(address => uint256) public incentiveTranches;
12 
13     /// Set incentive tranche
14     function setIncentiveTranche(address token, uint256 tranche) external {
15         require(
16             isTokenActivator(msg.sender),
17             "Caller not authorized to set incentive tranche"
18         );
19         incentiveTranches[token] = tranche;
20     }
21 
22     function stakeClaim(
23         address claimant,
24         address token,
25         uint256 amount
26     ) internal {
27         IncentiveDistribution iD =
28             IncentiveDistribution(incentiveDistributor());
29 
30         uint256 tranche = incentiveTranches[token];
31 
32         iD.addToClaimAmount(tranche, claimant, amount);
33     }
34 
35     function withdrawClaim(
36         address claimant,
37         address token,
38         uint256 amount
39     ) internal {
40         uint256 tranche = incentiveTranches[token];
41 
42         IncentiveDistribution(incentiveDistributor()).subtractFromClaimAmount(
43             tranche,
44             claimant,
45             amount
46         );
47     }
48 }
