1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity 0.8.9;
3 
4 import "../../interfaces/IStakerVault.sol";
5 import "../../interfaces/IController.sol";
6 import "../../interfaces/tokenomics/ILpGauge.sol";
7 import "../../interfaces/tokenomics/IRewardsGauge.sol";
8 
9 import "../../libraries/ScaledMath.sol";
10 import "../../libraries/Errors.sol";
11 import "../../libraries/AddressProviderHelpers.sol";
12 
13 import "../access/Authorization.sol";
14 
15 contract LpGauge is ILpGauge, IRewardsGauge, Authorization {
16     using AddressProviderHelpers for IAddressProvider;
17     using ScaledMath for uint256;
18 
19     IController public immutable controller;
20     IStakerVault public immutable stakerVault;
21     IInflationManager public immutable inflationManager;
22 
23     uint256 public poolStakedIntegral;
24     uint256 public poolLastUpdate;
25     mapping(address => uint256) public perUserStakedIntegral;
26     mapping(address => uint256) public perUserShare;
27 
28     constructor(IController _controller, address _stakerVault)
29         Authorization(_controller.addressProvider().getRoleManager())
30     {
31         require(address(_controller) != address(0), Error.ZERO_ADDRESS_NOT_ALLOWED);
32         require(_stakerVault != address(0), Error.ZERO_ADDRESS_NOT_ALLOWED);
33         controller = IController(_controller);
34         stakerVault = IStakerVault(_stakerVault);
35         IInflationManager _inflationManager = IController(_controller).inflationManager();
36         require(address(_inflationManager) != address(0), Error.ZERO_ADDRESS_NOT_ALLOWED);
37         inflationManager = _inflationManager;
38     }
39 
40     /**
41      * @notice Checkpoint function for the pool statistics.
42      * @return `true` if successful.
43      */
44     function poolCheckpoint() external override returns (bool) {
45         return _poolCheckpoint();
46     }
47 
48     /**
49      * @notice Calculates the token rewards a user should receive and mints these.
50      * @param beneficiary Address to claim rewards for.
51      * @return `true` if success.
52      */
53     function claimRewards(address beneficiary) external override returns (uint256) {
54         require(
55             msg.sender == beneficiary || _roleManager().hasRole(Roles.GAUGE_ZAP, msg.sender),
56             Error.UNAUTHORIZED_ACCESS
57         );
58         userCheckpoint(beneficiary);
59         uint256 amount = perUserShare[beneficiary];
60         if (amount <= 0) return 0;
61         perUserShare[beneficiary] = 0;
62         _mintRewards(beneficiary, amount);
63         return amount;
64     }
65 
66     function claimableRewards(address beneficiary) external view override returns (uint256) {
67         uint256 poolTotalStaked = stakerVault.getPoolTotalStaked();
68         uint256 poolStakedIntegral_ = poolStakedIntegral;
69         if (poolTotalStaked > 0) {
70             poolStakedIntegral_ += (inflationManager.getLpRateForStakerVault(address(stakerVault)) *
71                 (block.timestamp - poolLastUpdate)).scaledDiv(poolTotalStaked);
72         }
73 
74         return
75             perUserShare[beneficiary] +
76             stakerVault.stakedAndActionLockedBalanceOf(beneficiary).scaledMul(
77                 poolStakedIntegral_ - perUserStakedIntegral[beneficiary]
78             );
79     }
80 
81     /**
82      * @notice Checkpoint function for the statistics for a particular user.
83      * @param user Address of the user to checkpoint.
84      * @return `true` if successful.
85      */
86     function userCheckpoint(address user) public override returns (bool) {
87         _poolCheckpoint();
88 
89         // No checkpoint for the actions and strategies, since this does not accumulate tokens
90         if (
91             IController(controller).addressProvider().isAction(user) || stakerVault.isStrategy(user)
92         ) {
93             return false;
94         }
95         uint256 poolStakedIntegral_ = poolStakedIntegral;
96         perUserShare[user] += (
97             (stakerVault.stakedAndActionLockedBalanceOf(user)).scaledMul(
98                 (poolStakedIntegral_ - perUserStakedIntegral[user])
99             )
100         );
101 
102         perUserStakedIntegral[user] = poolStakedIntegral_;
103 
104         return true;
105     }
106 
107     function _mintRewards(address beneficiary, uint256 amount) internal {
108         inflationManager.mintRewards(beneficiary, amount);
109     }
110 
111     function _poolCheckpoint() internal returns (bool) {
112         uint256 currentRate = inflationManager.getLpRateForStakerVault(address(stakerVault));
113         // Update the integral of total token supply for the pool
114         uint256 poolTotalStaked = stakerVault.getPoolTotalStaked();
115         if (poolTotalStaked > 0) {
116             poolStakedIntegral += (currentRate * (block.timestamp - poolLastUpdate)).scaledDiv(
117                 poolTotalStaked
118             );
119         }
120         poolLastUpdate = block.timestamp;
121         return true;
122     }
123 }
