1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity 0.8.9;
3 
4 import "../interfaces/actions/IAction.sol";
5 import "../interfaces/IAddressProvider.sol";
6 import "../interfaces/IController.sol";
7 import "../interfaces/IStakerVault.sol";
8 import "../interfaces/pool/ILiquidityPool.sol";
9 import "../interfaces/tokenomics/IInflationManager.sol";
10 
11 import "../libraries/AddressProviderHelpers.sol";
12 
13 import "./utils/Preparable.sol";
14 import "./access/Authorization.sol";
15 
16 contract Controller is IController, Authorization, Preparable {
17     using AddressProviderHelpers for IAddressProvider;
18 
19     IAddressProvider public immutable override addressProvider;
20 
21     IInflationManager public inflationManager;
22 
23     bytes32 internal constant _KEEPER_REQUIRED_STAKED_BKD = "KEEPER_REQUIRED_STAKED_BKD";
24 
25     constructor(IAddressProvider _addressProvider)
26         Authorization(_addressProvider.getRoleManager())
27     {
28         addressProvider = _addressProvider;
29     }
30 
31     function setInflationManager(address _inflationManager) external onlyGovernance {
32         require(address(inflationManager) == address(0), Error.ADDRESS_ALREADY_SET);
33         require(_inflationManager != address(0), Error.INVALID_ARGUMENT);
34         inflationManager = IInflationManager(_inflationManager);
35     }
36 
37     function addStakerVault(address stakerVault)
38         external
39         override
40         onlyRoles2(Roles.GOVERNANCE, Roles.POOL_FACTORY)
41         returns (bool)
42     {
43         if (!addressProvider.addStakerVault(stakerVault)) {
44             return false;
45         }
46         if (address(inflationManager) != address(0)) {
47             address lpGauge = IStakerVault(stakerVault).getLpGauge();
48             if (lpGauge != address(0)) {
49                 inflationManager.whitelistGauge(lpGauge);
50             }
51         }
52         return true;
53     }
54 
55     /**
56      * @notice Delists pool.
57      * @param pool Address of pool to delist.
58      * @return `true` if successful.
59      */
60     function removePool(address pool) external override onlyGovernance returns (bool) {
61         if (!addressProvider.removePool(pool)) {
62             return false;
63         }
64         address lpToken = ILiquidityPool(pool).getLpToken();
65 
66         if (address(inflationManager) != address(0)) {
67             (bool exists, address stakerVault) = addressProvider.tryGetStakerVault(lpToken);
68             if (exists) {
69                 inflationManager.removeStakerVaultFromInflation(stakerVault, lpToken);
70             }
71         }
72 
73         return true;
74     }
75 
76     /**
77      * @notice Prepares the minimum amount of staked BKD required by a keeper
78      */
79     function prepareKeeperRequiredStakedBKD(uint256 amount) external override onlyGovernance {
80         require(addressProvider.getBKDLocker() != address(0), Error.ZERO_ADDRESS_NOT_ALLOWED);
81         _prepare(_KEEPER_REQUIRED_STAKED_BKD, amount);
82     }
83 
84     /**
85      * @notice Sets the minimum amount of staked BKD required by a keeper to the prepared value
86      */
87     function executeKeeperRequiredStakedBKD() external override {
88         _executeUInt256(_KEEPER_REQUIRED_STAKED_BKD);
89     }
90 
91     /**
92      * @notice Returns true if the given keeper has enough staked BKD to execute actions
93      */
94     function canKeeperExecuteAction(address keeper) external view override returns (bool) {
95         uint256 requiredBKD = getKeeperRequiredStakedBKD();
96         return
97             requiredBKD == 0 ||
98             IERC20(addressProvider.getBKDLocker()).balanceOf(keeper) >= requiredBKD;
99     }
100 
101     /**
102      * @return Returns the minimum amount of staked BKD required by a keeper
103      */
104     function getKeeperRequiredStakedBKD() public view override returns (uint256) {
105         return currentUInts256[_KEEPER_REQUIRED_STAKED_BKD];
106     }
107 
108     /**
109      * @return the total amount of ETH require by `payer` to cover the fees for
110      * positions registered in all actions
111      */
112     function getTotalEthRequiredForGas(address payer) external view override returns (uint256) {
113         // solhint-disable-previous-line ordering
114         uint256 totalEthRequired = 0;
115         address[] memory actions = addressProvider.allActions();
116         uint256 numActions = actions.length;
117         for (uint256 i = 0; i < numActions; i++) {
118             totalEthRequired += IAction(actions[i]).getEthRequiredForGas(payer);
119         }
120         return totalEthRequired;
121     }
122 }
