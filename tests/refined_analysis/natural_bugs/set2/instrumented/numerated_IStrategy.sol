1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 interface IStrategy {
5 
6     /********************************** View Functions **********************************/
7 
8     /// @dev Indicates whether the strategy has deployed assets
9     /// @return True if the strategy has deployed assets, false otherwise
10     function isActive() external view returns (bool);
11 
12     /********************************** Asset Vault Functions **********************************/
13 
14     /// @dev Deposits assets into the strategy. Can only be called by the AssetVault
15     /// @param _amount The amount of assets to deposit
16     function deposit(uint256 _amount) external;
17 
18     /// @dev Withdraws assets from the strategy. Can only be called by the AssetVault
19     /// @param _amount The amount of assets to withdraw
20     function withdraw(uint256 _amount) external;
21 
22     /// @dev Withdraws all assets from the strategy. Can only be called by the AssetVault. Fails if the strategy is not ready to exit
23     function withdrawAll() external;
24 
25     /********************************** Manager Functions **********************************/
26 
27     /// @dev Executes the strategy. Can only be called by the manager
28     /// @param _configData The configuration data for the strategy
29     function execute(bytes memory _configData) external returns (uint256);
30 
31     /// @dev Terminates the strategy. Can only be called by the manager
32     /// @param _configData The configuration data for the strategy
33     function terminate(bytes memory _configData) external returns (uint256);
34 
35     /********************************** Platform Functions **********************************/
36 
37     /// @dev Overrides the active status of the strategy. Can only be called by the platform
38     function overrideActiveStatus(bool _isStrategiesActive) external;
39 
40     /// @dev Rescues stuck ERC20 tokens. Can only be called by the platform
41     function rescueERC20(uint256 _amount) external;
42 
43     /********************************** Events **********************************/
44 
45     /// @notice Emitted when a deposit is made
46     /// @param _timestamp The timestamp of the deposit
47     /// @param _amount The amount of assets deposited
48     event Deposit(uint256 indexed _timestamp, uint256 _amount);
49 
50     /// @notice Emitted when a withdrawal is made
51     /// @param _timestamp The timestamp of the withdrawal
52     /// @param _amount The amount of assets withdrawn
53     event Withdraw(uint256 indexed _timestamp, uint256 _amount);
54 
55     /// @notice Emitted when the active status of the strategy is overriden
56     /// @param _timestamp The timestamp of the override
57     /// @param _isStrategiesActive The new active status of the strategy
58     event ActiveStatusOverriden(uint256 indexed _timestamp, bool _isStrategiesActive);
59 
60     /// @notice Emitted when Platform rescues stuck assets
61     /// @param _amount The amount of assets rescued
62     event Rescue(uint256 _amount);
63 
64     /********************************** Errors **********************************/
65 
66     error Unauthorized();
67     error AmountMismatch();
68     error StrategyActive();
69     error NonExistent();
70 }