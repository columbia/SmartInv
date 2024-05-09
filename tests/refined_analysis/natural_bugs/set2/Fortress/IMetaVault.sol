// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

interface IMetaVault {

    /// @notice Enum to represent the current state of the vault
    /// @dev INITIAL = Right after deployment, can move to `UNMANAGED` by calling 'initVault'
    /// @dev UNMANAGED = Users are able to interact with the vault, can move to `MANAGED` by calling 'startEpoch'
    /// @dev MANAGED = Strategies will be able to borrow & repay, can move to `UNMANAGED` by calling 'endEpoch'
    enum State {
        INITIAL,
        UNMANAGED,
        MANAGED
    }

    /********************************** View Functions **********************************/

    /// @dev Returns whether the epoch is overdue or not, i.e. if the epoch has ended in the specified time
    function isEpochOverdue() external view returns (bool);

    /// @dev Returns whether all assets are back from AssetVaults or not
    function areAssetsBack() external view returns (bool);

    /// @dev Returns the address of the FortressSwap contract
    function getSwap() external view returns (address);

    /// @dev Returns true if the Vault is in an "UNMANAGED" state, false otherwise
    function isUnmanaged() external view returns (bool);

    /// @dev Returns the length of the AssetVaults array
    function getAssetVaultsLength() external view returns (uint256);
        
    /********************************** Investor Functions **********************************/

    /// @dev Burns half of the managers collateral + cancels the charging of performance fee for the epoch. Used in order to incentivize Vault Managers to end the epoch at the specified time
    /// @dev Can only be called by anyone while "state" is "MANAGED" and "epochEnd" has passed
    function executeLatenessPenalty() external;

    /********************************** Manager Functions **********************************/

    /// @dev Opens vault for deposits and claims and initiates an epoch. Can only be called by the Vault Manager while state is "INITIAL"
    /// @param _configData - The encoded config data
    function initiateVault(bytes memory _configData) external;

    /// @dev Initiates the start of a new epoch. Can only be called by the Vault Manager while state is "UNMANAGED"
    /// @param _configData - The encoded config data
    function initiateEpoch(bytes memory _configData) external;

    /// @dev Starts a new epoch. Can only be called by the Vault Manager while state is "UNMANAGED" and after the timelock has passed
    function startEpoch() external;

    /// @dev Ends the current epoch. Can only be called by the Vault Manager while state is "MANAGED" and if all assets are back
    function endEpoch() external;

    /// @dev Adds a new AssetVault. Can only be called by the Vault Manager while state is "UNMANAGED" and if FortressSwap supports the asset + asset is not blacklisted
    /// @param _asset - The address of the asset (ERC20 token)
    function addAssetVault(address _asset) external returns (address _assetVault);

    /// @dev Deposits assets to the AssetVault. Can only be called by the Vault Manager while state is "UNMANAGED" and if the asset is supported + not blacklisted
    /// @param _asset - The address of the asset
    /// @param _amount - The amount of assets to deposit
    /// @param _minAmount - The minimum amount of VaultAsset assets to deposit
    function depositAsset(address _asset, uint256 _amount, uint256 _minAmount) external returns (uint256);

    /// @dev Withdraws assets from the AssetVault. Can only be called by the Vault Manager while state is "UNMANAGED" and if the asset is supported
    /// @param _asset - The address of the asset
    /// @param _amount - The amount of VaultAsset assets to withdraw
    /// @param _minAmount - The minimum amount of assets to withdraw
    function withdrawAsset(address _asset, uint256 _amount, uint256 _minAmount) external returns (uint256);

    /// @dev Sets a new Vault Manager. Can only be called by the Vault Manager while state is "UNMANAGED"
    /// @param _manager - The new Vault Manager
    function updateManager(address _manager) external;

    /// @dev Updates the Vault Manager's settings. Can only be called by the Vault Manager while state is "UNMANAGED"
    /// @param _managerPerformanceFee - The new manager performance fee
    /// @param _vaultWithdrawFee - The new vault withdraw fee
    /// @param _collateralRequirement - The new collateral requirement
    /// @param _performanceFeeLimit - The new performance fee limit
    function updateManagerSettings(uint256 _managerPerformanceFee, uint256 _vaultWithdrawFee, uint256 _collateralRequirement, uint256 _performanceFeeLimit) external;

    /// @dev Makes the Vault's settings immutable
    function makeImmutable() external;

    /********************************** Platform Functions **********************************/

    /// @dev Charges the management fee. Can only be called by the Platform
    function chargeManagementFee() external;

    /// @dev Updates platform fees. Can only be called by the Platform while "state" is "UNMANAGED"
    /// @param _platformFeePercentage - The new platform fee percentage
    function updateManagementFees(uint256 _platformFeePercentage) external;

    /// @dev Sets the _isDepositPaused and _isWithdrawPaused. Can only be called by the Platform
    /// @param _isDepositPaused - Whether to pause deposits
    /// @param _isWithdrawPaused - Whether to pause withdrawals
    function updatePauseInteractions(bool _isDepositPaused, bool _isWithdrawPaused) external;

    /// @dev Sets some Vault settings. Can only be called by the Platform while "state" is "UNMANAGED"
    /// @param _currentVaultState - The new Vault state
    /// @param _swap - The new FortressSwap address
    /// @param _depositLimit - The new deposit cap
    /// @param _timelockDuration - The new timelock delay
    function updatePlatformSettings(State _currentVaultState, address _swap, uint256 _depositLimit, uint256 _timelockDuration) external;

    /// @dev Blacklists an asset. Can only be called by the Platform while "state" is "UNMANAGED"
    /// @param _asset - The address of the asset to blacklist
    function blacklistAsset(address _asset) external;

    /********************************** Events **********************************/

    /// @notice emitted when a deposit is made
    /// @param _caller - The address of the depositor
    /// @param _receiver - The address of the receiver of shares
    /// @param _assets - The amount of assets deposited
    /// @param _shares - The amount of shares received
    event Deposited(address indexed _caller, address indexed _receiver, uint256 _assets, uint256 _shares);

    /// @notice emitted when a withdraw is made
    /// @param _caller - The address of the withdrawer
    /// @param _receiver - The address of the receiver of assets
    /// @param _owner - The address if the owner of shares
    /// @param _assets - The amount of assets withdrawn
    /// @param _shares - The amount of shares burned
    event Withdrawn(address indexed _caller, address indexed _receiver, address indexed _owner, uint256 _assets, uint256 _shares);

    /// @notice emitted when "setManagementFees" function is called
    /// @param _platformManagementFee - The new platform management fee percentage
    event ManagementFeeUpdated(uint256 _platformManagementFee);

    /// @notice emitted when "updatePauseInteraction" function is called
    /// @param _pauseDeposit - Whether to pause deposits
    /// @param _pauseWithdraw - Whether to pause withdrawals
    event PauseInteractionsUpdated(bool _pauseDeposit, bool _pauseWithdraw);

    /// @notice emitted when "updateSettings" function is called
    /// @param _state - The new Vault state
    /// @param _swap - The new FortressSwap address
    /// @param _depositCap - The new deposit cap
    /// @param _delay - The new timelock delay
    event SettingsUpdated(State _state, address _swap, uint256 _depositCap, uint256 _delay);

    /// @notice emitted when "blacklistAsset" function is called
    /// @param _asset - The address of the asset to blacklist
    event AssetBlacklisted(address indexed _asset);

    /// @notice emitted when "updateManager" function is called
    /// @param _manager - The new Vault Manager
    event ManagerUpdated(address indexed _manager);

    /// @notice emitted when "executeLatenessPenalty" function is called
    /// @param _timestamp - The timestamp at call time
    /// @param _burnAmount - The amount of shares burned
    event LatenessPenalty(uint256 indexed _timestamp, uint256 _burnAmount);

    /// @notice emitted when "setPauseInteraction" function is called
    /// @param _pauseDeposit - The new pauseDeposit status
    /// @param _pauseWithdraw - The new pauseWithdraw status
    event PauseInteractions(bool _pauseDeposit, bool _pauseWithdraw);

    /// @notice emitted when "chargeManagementFee" function is called
    /// @param _feeAmount - The amount of fee charged
    /// @param _timestamp - The timestamp at call time
    event ManagementFeeCharged(uint256 indexed _timestamp, uint256 _feeAmount);

    /// @notice emitted when "requestStartEpoch" function is called
    /// @param _timestamp - The timestamp at call time
    /// @param _configData - The config data for the new epoch
    event EpochInitiated(uint256 indexed _timestamp, bytes _configData);

    /// @notice emitted when an epoch has ended
    /// @param _timestamp The timestamp of epoch end (indexed)
    /// @param _blockNumber The block number of epoch end (indexed)
    /// @param _assetBalance The asset balance at this time
    /// @param _shareSupply The share balance at this time
    event EpochCompleted(uint256 indexed _timestamp, uint256 indexed _blockNumber, uint256 _assetBalance, uint256 _shareSupply);

    /// @notice emitted when an epoch has started
    /// @param _timestamp The timestamp of epoch start (indexed)
    /// @param _assetBalance The asset balance at this time
    /// @param _shareSupply The share balance at this time
    event EpochStarted(uint256 indexed _timestamp, uint256 _assetBalance, uint256 _shareSupply);

    /// @notice emitted when a new AssetVault is added
    /// @param _assetVault The address of the new AssetVault
    /// @param _asset The address of the asset
    event AssetVaultAdded(address indexed _assetVault, address indexed _asset);

    /// @notice emitted when a deposit is made to an AssetVault
    /// @param _assetVault The address of the AssetVault
    /// @param _asset The address of the asset
    /// @param _amount The amount of AssetVault assets deposited
    event AssetDeposited(address indexed _assetVault, address indexed _asset, uint256 _amount);

    /// @notice emitted when a withdraw is made from an AssetVault
    /// @param _assetVault The address of the AssetVault
    /// @param _asset The address of the asset
    /// @param _amount The amount of assets withdrawn
    event AssetWithdrawn(address indexed _assetVault, address indexed _asset, uint256 _amount);

    /// @notice emitted when a manager fee is charged
    /// @param _managerFee The amount of fee charged
    /// @param _postEpochBalance The balance before the start of the epoch
    /// @param _preEpochBalance The balance after the end of the epoch
    event FeesCharged(uint256 _managerFee, uint256 _postEpochBalance, uint256 _preEpochBalance);

    /// @notice emitted when manager settings are updated
    /// @param _managerPerformanceFee The new manager performance fee
    /// @param _vaultWithdrawFee The new vault withdraw fee
    /// @param _collateralRequirement The new collateral requirement
    /// @param _performanceFeeLimit The new performance fee limit
    event ManagerSettingsUpdated(uint256 _managerPerformanceFee, uint256 _vaultWithdrawFee, uint256 _collateralRequirement, uint256 _performanceFeeLimit);

    /// @notice emitted when vault balance snapshot is taken
    /// @param _timestamp The snapshot timestamp (indexed)
    /// @param _blockNumber The snapshot block number (indexed)
    /// @param _assetBalance The asset balance at this time
    /// @param _shareSupply The share balance at this time
    event Snapshot(uint256 indexed _timestamp, uint256 indexed _blockNumber, uint256 _assetBalance, uint256 _shareSupply);

    /// @notice emitted when vault is made immutable
    event VaultImmutable();


    /********************************** Errors **********************************/

    error InvalidState();
    error InvalidAmount();
    error DepositPaused();
    error WithdrawPaused();
    error DepositLimitExceeded();
    error ZeroAmount();
    error ZeroAddress();
    error InsufficientBalance();
    error InsufficientCollateral();
    error InsufficientAllowance();
    error InsufficientAmountOut();
    error InsufficientManagerCollateral();
    error LatenessNotPenalized();
    error EpochNotCompleted();
    error InvalidSwapRoute();
    error BlacklistedAsset();
    error AssetVaultNotAvailable();
    error NotTimelocked();
    error TimelockNotExpired();
    error Unauthorized();
    error AssetsNotBack();
    error EpochEndBlockInvalid();
    error ManagerPerformanceFeeInvalid();
    error VaultWithdrawFeeInvalid();
    error CollateralRequirementInvalid();
    error PlatformManagementFeeInvalid();
    error PerformanceFeeLimitInvalid();
    error EpochAlreadyInitiated();
    error platformManagementFeeInvalid();
    error ManagementFeeNotDue();
    error Immutable();
}