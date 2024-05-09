// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

interface IAssetVault {

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

    /// @dev Indicates whether the AssetVault is active, i.e. if it has assets under management
    /// @return True if the AssetVault is active, false otherwise
    function isActive() external view returns (bool);

    /// @dev Indicates whether assets are deployed in a specific strategy
    /// @param _strategy The address of the strategy
    /// @return True if assets are deployed in the strategy, false otherwise
    function isStrategyActive(address _strategy) external view returns (bool);

    /// @dev Indicates whether assets are deployed in any strategy
    /// @return True if assets are deployed in any strategy, false otherwise
    function areStrategiesActive() external view returns (bool);

    /// @dev Returns the address of the VaultAsset asset
    function getAsset() external view returns (address);

    /********************************** Meta Vault Functions **********************************/

    /// @dev Deposits assets into the AssetVault. Can only be called by the MetaVault
    /// @param _amount The amount of assets to deposit, in metaVaultAsset
    /// @return _amountIn The amount of assets deposited, in asset
    function deposit(uint256 _amount) external returns (uint256 _amountIn);

    /// @dev Withdraws assets from the AssetVault. Can only be called by the MetaVault
    /// @param _amount The amount of assets to withdraw, in asset
    /// @return _amountOut amount of assets withdrawn, in metaVaultAsset
    function withdraw(uint256 _amount) external returns (uint256 _amountOut);

    /********************************** Manager Functions **********************************/

    /// @dev Deposits assets into a strategy. Can only be called by the manager
    /// @param _strategy The address of the strategy
    /// @param _amount The amount of assets to deposit
    function depositToStrategy(address _strategy, uint256 _amount) external;

    /// @dev Withdraws assets from a strategy. Can only be called by the manager
    /// @param _strategy The address of the strategy
    /// @param _amount The amount of assets to withdraw
    function withdrawFromStrategy(address _strategy, uint256 _amount) external;

    /// @dev Withdraws all assets from all strategy. Fails if any strategy is not ready to exit. Can only be called by the manager
    function withdrawAllFromAllStrategies() external;

    /// @dev Initiate the timelock to add a new strategy contract. Can only be called by the manager
    /// @param _strategy The address of the new strategy
    function initiateStrategy(address _strategy) external;

    /// @dev Add a new strategy contract. Can only be called by the manager and after the timelock has expired
    function addStrategy() external;

    /// @dev Sets a new Vault Manager. Can only be called by the Vault Manager while state is "UNMANAGED"
    /// @param _manager - The new Vault Manager
    function updateManager(address _manager) external;

    /********************************** Platform Functions **********************************/

    /// @dev Set the timelock delay period. Can only be called by the platform
    /// @param _delay The timelock delay
    function updateTimelockDuration(uint256 _delay) external;

    /// @dev Add a new strategy contract. Can only be called by the platform
    /// @param _strategy The address of the new strategy
    function platformAddStrategy(address _strategy) external;

    /// @dev Override the stratagies status of the AssetVault. Can only be called by the platform
    /// @param _isStrategiesActive The new status of the strategies
    function overrideActiveStatus(bool _isStrategiesActive) external;

    /// @dev Set the blacklist status of a strategy. Can only be called by the platform
    /// @param _strategy The address of the strategy
    /// @param _isBlacklisted The new blacklist status of the strategy
    function setBlacklistStatus(address _strategy, bool _isBlacklisted) external;

    /********************************** Events **********************************/

    /// @notice Emitted when a deposit is made
    /// @param _timestamp The timestamp of the deposit
    /// @param _amount The amount of assets deposited
    event Deposited(uint256 indexed _timestamp, uint256 _amount);

    /// @notice Emitted when a withdrawal is made
    /// @param _timestamp The timestamp of the withdrawal
    /// @param _amount The amount of assets withdrawn
    event Withdrawn(uint256 indexed _timestamp, uint256 _amount);

    /// @notice Emitted when assets are deposited into a strategy
    /// @param _timestamp The timestamp of the deposit
    /// @param _strategy The address of the strategy
    /// @param _amount The amount of assets deposited
    event DepositedToStrategy(uint256 indexed _timestamp, address _strategy, uint256 _amount);

    /// @notice Emitted when assets are withdrawn from a strategy
    /// @param _timestamp The timestamp of the withdrawal
    /// @param _strategy The address of the strategy
    /// @param _amount The amount of assets withdrawn
    event WithdrawnFromStrategy(uint256 indexed _timestamp, address _strategy, uint256 _amount);
    
    /// @notice Emitted when assets were withdrawn from all strategies
    /// @param _timestamp The timestamp of the withdrawal
    event WithdrawnFromAllStrategies(uint256 indexed _timestamp);

    /// @notice Emitted when a timelock is initiated to add a new strategy
    /// @param _timestamp The timestamp of the timelock initiation
    /// @param _strategy The address of the new strategy
    event StrategyInitiated(uint256 indexed _timestamp, address _strategy);

    /// @notice Emitted when a new strategy is added
    /// @param _timestamp The timestamp of the strategy addition
    /// @param _strategy The address of the strategy
    event StrategyAdded(uint256 indexed _timestamp, address _strategy);

    /// @notice Emitted when the timelock duration is set
    /// @param _timestamp The timestamp of the timelock delay set
    /// @param _delay The timelock delay
    event TimelockDurationUpdated(uint256 indexed _timestamp, uint256 _delay);

    /// @notice Emitted when the manager is set
    /// @param _timestamp The timestamp of the manager set
    /// @param _manager The address of the new manager
    event ManagerUpdated(uint256 indexed _timestamp, address _manager);

    /// @notice Emitted when platform overrides the active status of the AssetVault
    /// @param _timestamp The timestamp of the active status override
    /// @param _isStrategiesActive The new active status of the AssetVault
    event ActiveStatusOverriden(uint256 indexed _timestamp, bool _isStrategiesActive);

    /// @notice Emitted when platform overrides the blacklist status of a strategy
    /// @param _timestamp The timestamp of the blacklist status override
    /// @param _strategy The address of the strategy
    /// @param _isBlacklisted The new blacklist status of the strategy
    event BlacklistStatusOverriden(uint256 indexed _timestamp, address indexed _strategy, bool indexed _isBlacklisted);

    /********************************** Errors **********************************/

    error InvalidState();
    error StrategyNonExistent();
    error StrategyAlreadyActive();
    error AssetDisabled();
    error StrategyBlacklisted();
    error NotTimelocked();
    error TimelockNotExpired();
    error Unauthorized();
}