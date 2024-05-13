1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 interface IMetaVault {
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
18     /// @dev Returns whether the epoch is overdue or not, i.e. if the epoch has ended in the specified time
19     function isEpochOverdue() external view returns (bool);
20 
21     /// @dev Returns whether all assets are back from AssetVaults or not
22     function areAssetsBack() external view returns (bool);
23 
24     /// @dev Returns the address of the FortressSwap contract
25     function getSwap() external view returns (address);
26 
27     /// @dev Returns true if the Vault is in an "UNMANAGED" state, false otherwise
28     function isUnmanaged() external view returns (bool);
29 
30     /// @dev Returns the length of the AssetVaults array
31     function getAssetVaultsLength() external view returns (uint256);
32         
33     /********************************** Investor Functions **********************************/
34 
35     /// @dev Burns half of the managers collateral + cancels the charging of performance fee for the epoch. Used in order to incentivize Vault Managers to end the epoch at the specified time
36     /// @dev Can only be called by anyone while "state" is "MANAGED" and "epochEnd" has passed
37     function executeLatenessPenalty() external;
38 
39     /********************************** Manager Functions **********************************/
40 
41     /// @dev Opens vault for deposits and claims and initiates an epoch. Can only be called by the Vault Manager while state is "INITIAL"
42     /// @param _configData - The encoded config data
43     function initiateVault(bytes memory _configData) external;
44 
45     /// @dev Initiates the start of a new epoch. Can only be called by the Vault Manager while state is "UNMANAGED"
46     /// @param _configData - The encoded config data
47     function initiateEpoch(bytes memory _configData) external;
48 
49     /// @dev Starts a new epoch. Can only be called by the Vault Manager while state is "UNMANAGED" and after the timelock has passed
50     function startEpoch() external;
51 
52     /// @dev Ends the current epoch. Can only be called by the Vault Manager while state is "MANAGED" and if all assets are back
53     function endEpoch() external;
54 
55     /// @dev Adds a new AssetVault. Can only be called by the Vault Manager while state is "UNMANAGED" and if FortressSwap supports the asset + asset is not blacklisted
56     /// @param _asset - The address of the asset (ERC20 token)
57     function addAssetVault(address _asset) external returns (address _assetVault);
58 
59     /// @dev Deposits assets to the AssetVault. Can only be called by the Vault Manager while state is "UNMANAGED" and if the asset is supported + not blacklisted
60     /// @param _asset - The address of the asset
61     /// @param _amount - The amount of assets to deposit
62     /// @param _minAmount - The minimum amount of VaultAsset assets to deposit
63     function depositAsset(address _asset, uint256 _amount, uint256 _minAmount) external returns (uint256);
64 
65     /// @dev Withdraws assets from the AssetVault. Can only be called by the Vault Manager while state is "UNMANAGED" and if the asset is supported
66     /// @param _asset - The address of the asset
67     /// @param _amount - The amount of VaultAsset assets to withdraw
68     /// @param _minAmount - The minimum amount of assets to withdraw
69     function withdrawAsset(address _asset, uint256 _amount, uint256 _minAmount) external returns (uint256);
70 
71     /// @dev Sets a new Vault Manager. Can only be called by the Vault Manager while state is "UNMANAGED"
72     /// @param _manager - The new Vault Manager
73     function updateManager(address _manager) external;
74 
75     /// @dev Updates the Vault Manager's settings. Can only be called by the Vault Manager while state is "UNMANAGED"
76     /// @param _managerPerformanceFee - The new manager performance fee
77     /// @param _vaultWithdrawFee - The new vault withdraw fee
78     /// @param _collateralRequirement - The new collateral requirement
79     /// @param _performanceFeeLimit - The new performance fee limit
80     function updateManagerSettings(uint256 _managerPerformanceFee, uint256 _vaultWithdrawFee, uint256 _collateralRequirement, uint256 _performanceFeeLimit) external;
81 
82     /// @dev Makes the Vault's settings immutable
83     function makeImmutable() external;
84 
85     /********************************** Platform Functions **********************************/
86 
87     /// @dev Charges the management fee. Can only be called by the Platform
88     function chargeManagementFee() external;
89 
90     /// @dev Updates platform fees. Can only be called by the Platform while "state" is "UNMANAGED"
91     /// @param _platformFeePercentage - The new platform fee percentage
92     function updateManagementFees(uint256 _platformFeePercentage) external;
93 
94     /// @dev Sets the _isDepositPaused and _isWithdrawPaused. Can only be called by the Platform
95     /// @param _isDepositPaused - Whether to pause deposits
96     /// @param _isWithdrawPaused - Whether to pause withdrawals
97     function updatePauseInteractions(bool _isDepositPaused, bool _isWithdrawPaused) external;
98 
99     /// @dev Sets some Vault settings. Can only be called by the Platform while "state" is "UNMANAGED"
100     /// @param _currentVaultState - The new Vault state
101     /// @param _swap - The new FortressSwap address
102     /// @param _depositLimit - The new deposit cap
103     /// @param _timelockDuration - The new timelock delay
104     function updatePlatformSettings(State _currentVaultState, address _swap, uint256 _depositLimit, uint256 _timelockDuration) external;
105 
106     /// @dev Blacklists an asset. Can only be called by the Platform while "state" is "UNMANAGED"
107     /// @param _asset - The address of the asset to blacklist
108     function blacklistAsset(address _asset) external;
109 
110     /********************************** Events **********************************/
111 
112     /// @notice emitted when a deposit is made
113     /// @param _caller - The address of the depositor
114     /// @param _receiver - The address of the receiver of shares
115     /// @param _assets - The amount of assets deposited
116     /// @param _shares - The amount of shares received
117     event Deposited(address indexed _caller, address indexed _receiver, uint256 _assets, uint256 _shares);
118 
119     /// @notice emitted when a withdraw is made
120     /// @param _caller - The address of the withdrawer
121     /// @param _receiver - The address of the receiver of assets
122     /// @param _owner - The address if the owner of shares
123     /// @param _assets - The amount of assets withdrawn
124     /// @param _shares - The amount of shares burned
125     event Withdrawn(address indexed _caller, address indexed _receiver, address indexed _owner, uint256 _assets, uint256 _shares);
126 
127     /// @notice emitted when "setManagementFees" function is called
128     /// @param _platformManagementFee - The new platform management fee percentage
129     event ManagementFeeUpdated(uint256 _platformManagementFee);
130 
131     /// @notice emitted when "updatePauseInteraction" function is called
132     /// @param _pauseDeposit - Whether to pause deposits
133     /// @param _pauseWithdraw - Whether to pause withdrawals
134     event PauseInteractionsUpdated(bool _pauseDeposit, bool _pauseWithdraw);
135 
136     /// @notice emitted when "updateSettings" function is called
137     /// @param _state - The new Vault state
138     /// @param _swap - The new FortressSwap address
139     /// @param _depositCap - The new deposit cap
140     /// @param _delay - The new timelock delay
141     event SettingsUpdated(State _state, address _swap, uint256 _depositCap, uint256 _delay);
142 
143     /// @notice emitted when "blacklistAsset" function is called
144     /// @param _asset - The address of the asset to blacklist
145     event AssetBlacklisted(address indexed _asset);
146 
147     /// @notice emitted when "updateManager" function is called
148     /// @param _manager - The new Vault Manager
149     event ManagerUpdated(address indexed _manager);
150 
151     /// @notice emitted when "executeLatenessPenalty" function is called
152     /// @param _timestamp - The timestamp at call time
153     /// @param _burnAmount - The amount of shares burned
154     event LatenessPenalty(uint256 indexed _timestamp, uint256 _burnAmount);
155 
156     /// @notice emitted when "setPauseInteraction" function is called
157     /// @param _pauseDeposit - The new pauseDeposit status
158     /// @param _pauseWithdraw - The new pauseWithdraw status
159     event PauseInteractions(bool _pauseDeposit, bool _pauseWithdraw);
160 
161     /// @notice emitted when "chargeManagementFee" function is called
162     /// @param _feeAmount - The amount of fee charged
163     /// @param _timestamp - The timestamp at call time
164     event ManagementFeeCharged(uint256 indexed _timestamp, uint256 _feeAmount);
165 
166     /// @notice emitted when "requestStartEpoch" function is called
167     /// @param _timestamp - The timestamp at call time
168     /// @param _configData - The config data for the new epoch
169     event EpochInitiated(uint256 indexed _timestamp, bytes _configData);
170 
171     /// @notice emitted when an epoch has ended
172     /// @param _timestamp The timestamp of epoch end (indexed)
173     /// @param _blockNumber The block number of epoch end (indexed)
174     /// @param _assetBalance The asset balance at this time
175     /// @param _shareSupply The share balance at this time
176     event EpochCompleted(uint256 indexed _timestamp, uint256 indexed _blockNumber, uint256 _assetBalance, uint256 _shareSupply);
177 
178     /// @notice emitted when an epoch has started
179     /// @param _timestamp The timestamp of epoch start (indexed)
180     /// @param _assetBalance The asset balance at this time
181     /// @param _shareSupply The share balance at this time
182     event EpochStarted(uint256 indexed _timestamp, uint256 _assetBalance, uint256 _shareSupply);
183 
184     /// @notice emitted when a new AssetVault is added
185     /// @param _assetVault The address of the new AssetVault
186     /// @param _asset The address of the asset
187     event AssetVaultAdded(address indexed _assetVault, address indexed _asset);
188 
189     /// @notice emitted when a deposit is made to an AssetVault
190     /// @param _assetVault The address of the AssetVault
191     /// @param _asset The address of the asset
192     /// @param _amount The amount of AssetVault assets deposited
193     event AssetDeposited(address indexed _assetVault, address indexed _asset, uint256 _amount);
194 
195     /// @notice emitted when a withdraw is made from an AssetVault
196     /// @param _assetVault The address of the AssetVault
197     /// @param _asset The address of the asset
198     /// @param _amount The amount of assets withdrawn
199     event AssetWithdrawn(address indexed _assetVault, address indexed _asset, uint256 _amount);
200 
201     /// @notice emitted when a manager fee is charged
202     /// @param _managerFee The amount of fee charged
203     /// @param _postEpochBalance The balance before the start of the epoch
204     /// @param _preEpochBalance The balance after the end of the epoch
205     event FeesCharged(uint256 _managerFee, uint256 _postEpochBalance, uint256 _preEpochBalance);
206 
207     /// @notice emitted when manager settings are updated
208     /// @param _managerPerformanceFee The new manager performance fee
209     /// @param _vaultWithdrawFee The new vault withdraw fee
210     /// @param _collateralRequirement The new collateral requirement
211     /// @param _performanceFeeLimit The new performance fee limit
212     event ManagerSettingsUpdated(uint256 _managerPerformanceFee, uint256 _vaultWithdrawFee, uint256 _collateralRequirement, uint256 _performanceFeeLimit);
213 
214     /// @notice emitted when vault balance snapshot is taken
215     /// @param _timestamp The snapshot timestamp (indexed)
216     /// @param _blockNumber The snapshot block number (indexed)
217     /// @param _assetBalance The asset balance at this time
218     /// @param _shareSupply The share balance at this time
219     event Snapshot(uint256 indexed _timestamp, uint256 indexed _blockNumber, uint256 _assetBalance, uint256 _shareSupply);
220 
221     /// @notice emitted when vault is made immutable
222     event VaultImmutable();
223 
224 
225     /********************************** Errors **********************************/
226 
227     error InvalidState();
228     error InvalidAmount();
229     error DepositPaused();
230     error WithdrawPaused();
231     error DepositLimitExceeded();
232     error ZeroAmount();
233     error ZeroAddress();
234     error InsufficientBalance();
235     error InsufficientCollateral();
236     error InsufficientAllowance();
237     error InsufficientAmountOut();
238     error InsufficientManagerCollateral();
239     error LatenessNotPenalized();
240     error EpochNotCompleted();
241     error InvalidSwapRoute();
242     error BlacklistedAsset();
243     error AssetVaultNotAvailable();
244     error NotTimelocked();
245     error TimelockNotExpired();
246     error Unauthorized();
247     error AssetsNotBack();
248     error EpochEndBlockInvalid();
249     error ManagerPerformanceFeeInvalid();
250     error VaultWithdrawFeeInvalid();
251     error CollateralRequirementInvalid();
252     error PlatformManagementFeeInvalid();
253     error PerformanceFeeLimitInvalid();
254     error EpochAlreadyInitiated();
255     error platformManagementFeeInvalid();
256     error ManagementFeeNotDue();
257     error Immutable();
258 }