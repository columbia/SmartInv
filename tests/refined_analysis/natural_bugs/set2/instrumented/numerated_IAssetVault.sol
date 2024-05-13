1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 interface IAssetVault {
5 
6     /// @notice Enum to represent the current state of the vault
7     /// @dev INITIAL = Right after deployment, can move to `UNMANAGED` by calling 'initVault'
8     /// @dev UNMANAGED = Users are able to interact with the vault, can move to `MANAGED` by calling 'startEpoch'
9     /// @dev MANAGED = Strategies will be able to borrow & repay, can move to `UNMANAGED` by calling 'endEpoch'
10     enum State {
11         INITIAL,
12         UNMANAGED,
13         MANAGED
14     }
15 
16     /********************************** View Functions **********************************/
17 
18     /// @dev Indicates whether the AssetVault is active, i.e. if it has assets under management
19     /// @return True if the AssetVault is active, false otherwise
20     function isActive() external view returns (bool);
21 
22     /// @dev Indicates whether assets are deployed in a specific strategy
23     /// @param _strategy The address of the strategy
24     /// @return True if assets are deployed in the strategy, false otherwise
25     function isStrategyActive(address _strategy) external view returns (bool);
26 
27     /// @dev Indicates whether assets are deployed in any strategy
28     /// @return True if assets are deployed in any strategy, false otherwise
29     function areStrategiesActive() external view returns (bool);
30 
31     /// @dev Returns the address of the VaultAsset asset
32     function getAsset() external view returns (address);
33 
34     /********************************** Meta Vault Functions **********************************/
35 
36     /// @dev Deposits assets into the AssetVault. Can only be called by the MetaVault
37     /// @param _amount The amount of assets to deposit, in metaVaultAsset
38     /// @return _amountIn The amount of assets deposited, in asset
39     function deposit(uint256 _amount) external returns (uint256 _amountIn);
40 
41     /// @dev Withdraws assets from the AssetVault. Can only be called by the MetaVault
42     /// @param _amount The amount of assets to withdraw, in asset
43     /// @return _amountOut amount of assets withdrawn, in metaVaultAsset
44     function withdraw(uint256 _amount) external returns (uint256 _amountOut);
45 
46     /********************************** Manager Functions **********************************/
47 
48     /// @dev Deposits assets into a strategy. Can only be called by the manager
49     /// @param _strategy The address of the strategy
50     /// @param _amount The amount of assets to deposit
51     function depositToStrategy(address _strategy, uint256 _amount) external;
52 
53     /// @dev Withdraws assets from a strategy. Can only be called by the manager
54     /// @param _strategy The address of the strategy
55     /// @param _amount The amount of assets to withdraw
56     function withdrawFromStrategy(address _strategy, uint256 _amount) external;
57 
58     /// @dev Withdraws all assets from all strategy. Fails if any strategy is not ready to exit. Can only be called by the manager
59     function withdrawAllFromAllStrategies() external;
60 
61     /// @dev Initiate the timelock to add a new strategy contract. Can only be called by the manager
62     /// @param _strategy The address of the new strategy
63     function initiateStrategy(address _strategy) external;
64 
65     /// @dev Add a new strategy contract. Can only be called by the manager and after the timelock has expired
66     function addStrategy() external;
67 
68     /// @dev Sets a new Vault Manager. Can only be called by the Vault Manager while state is "UNMANAGED"
69     /// @param _manager - The new Vault Manager
70     function updateManager(address _manager) external;
71 
72     /********************************** Platform Functions **********************************/
73 
74     /// @dev Set the timelock delay period. Can only be called by the platform
75     /// @param _delay The timelock delay
76     function updateTimelockDuration(uint256 _delay) external;
77 
78     /// @dev Add a new strategy contract. Can only be called by the platform
79     /// @param _strategy The address of the new strategy
80     function platformAddStrategy(address _strategy) external;
81 
82     /// @dev Override the stratagies status of the AssetVault. Can only be called by the platform
83     /// @param _isStrategiesActive The new status of the strategies
84     function overrideActiveStatus(bool _isStrategiesActive) external;
85 
86     /// @dev Set the blacklist status of a strategy. Can only be called by the platform
87     /// @param _strategy The address of the strategy
88     /// @param _isBlacklisted The new blacklist status of the strategy
89     function setBlacklistStatus(address _strategy, bool _isBlacklisted) external;
90 
91     /********************************** Events **********************************/
92 
93     /// @notice Emitted when a deposit is made
94     /// @param _timestamp The timestamp of the deposit
95     /// @param _amount The amount of assets deposited
96     event Deposited(uint256 indexed _timestamp, uint256 _amount);
97 
98     /// @notice Emitted when a withdrawal is made
99     /// @param _timestamp The timestamp of the withdrawal
100     /// @param _amount The amount of assets withdrawn
101     event Withdrawn(uint256 indexed _timestamp, uint256 _amount);
102 
103     /// @notice Emitted when assets are deposited into a strategy
104     /// @param _timestamp The timestamp of the deposit
105     /// @param _strategy The address of the strategy
106     /// @param _amount The amount of assets deposited
107     event DepositedToStrategy(uint256 indexed _timestamp, address _strategy, uint256 _amount);
108 
109     /// @notice Emitted when assets are withdrawn from a strategy
110     /// @param _timestamp The timestamp of the withdrawal
111     /// @param _strategy The address of the strategy
112     /// @param _amount The amount of assets withdrawn
113     event WithdrawnFromStrategy(uint256 indexed _timestamp, address _strategy, uint256 _amount);
114     
115     /// @notice Emitted when assets were withdrawn from all strategies
116     /// @param _timestamp The timestamp of the withdrawal
117     event WithdrawnFromAllStrategies(uint256 indexed _timestamp);
118 
119     /// @notice Emitted when a timelock is initiated to add a new strategy
120     /// @param _timestamp The timestamp of the timelock initiation
121     /// @param _strategy The address of the new strategy
122     event StrategyInitiated(uint256 indexed _timestamp, address _strategy);
123 
124     /// @notice Emitted when a new strategy is added
125     /// @param _timestamp The timestamp of the strategy addition
126     /// @param _strategy The address of the strategy
127     event StrategyAdded(uint256 indexed _timestamp, address _strategy);
128 
129     /// @notice Emitted when the timelock duration is set
130     /// @param _timestamp The timestamp of the timelock delay set
131     /// @param _delay The timelock delay
132     event TimelockDurationUpdated(uint256 indexed _timestamp, uint256 _delay);
133 
134     /// @notice Emitted when the manager is set
135     /// @param _timestamp The timestamp of the manager set
136     /// @param _manager The address of the new manager
137     event ManagerUpdated(uint256 indexed _timestamp, address _manager);
138 
139     /// @notice Emitted when platform overrides the active status of the AssetVault
140     /// @param _timestamp The timestamp of the active status override
141     /// @param _isStrategiesActive The new active status of the AssetVault
142     event ActiveStatusOverriden(uint256 indexed _timestamp, bool _isStrategiesActive);
143 
144     /// @notice Emitted when platform overrides the blacklist status of a strategy
145     /// @param _timestamp The timestamp of the blacklist status override
146     /// @param _strategy The address of the strategy
147     /// @param _isBlacklisted The new blacklist status of the strategy
148     event BlacklistStatusOverriden(uint256 indexed _timestamp, address indexed _strategy, bool indexed _isBlacklisted);
149 
150     /********************************** Errors **********************************/
151 
152     error InvalidState();
153     error StrategyNonExistent();
154     error StrategyAlreadyActive();
155     error AssetDisabled();
156     error StrategyBlacklisted();
157     error NotTimelocked();
158     error TimelockNotExpired();
159     error Unauthorized();
160 }