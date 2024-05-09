// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

interface IStrategy {

    /********************************** View Functions **********************************/

    /// @dev Indicates whether the strategy has deployed assets
    /// @return True if the strategy has deployed assets, false otherwise
    function isActive() external view returns (bool);

    /********************************** Asset Vault Functions **********************************/

    /// @dev Deposits assets into the strategy. Can only be called by the AssetVault
    /// @param _amount The amount of assets to deposit
    function deposit(uint256 _amount) external;

    /// @dev Withdraws assets from the strategy. Can only be called by the AssetVault
    /// @param _amount The amount of assets to withdraw
    function withdraw(uint256 _amount) external;

    /// @dev Withdraws all assets from the strategy. Can only be called by the AssetVault. Fails if the strategy is not ready to exit
    function withdrawAll() external;

    /********************************** Manager Functions **********************************/

    /// @dev Executes the strategy. Can only be called by the manager
    /// @param _configData The configuration data for the strategy
    function execute(bytes memory _configData) external returns (uint256);

    /// @dev Terminates the strategy. Can only be called by the manager
    /// @param _configData The configuration data for the strategy
    function terminate(bytes memory _configData) external returns (uint256);

    /********************************** Platform Functions **********************************/

    /// @dev Overrides the active status of the strategy. Can only be called by the platform
    function overrideActiveStatus(bool _isStrategiesActive) external;

    /// @dev Rescues stuck ERC20 tokens. Can only be called by the platform
    function rescueERC20(uint256 _amount) external;

    /********************************** Events **********************************/

    /// @notice Emitted when a deposit is made
    /// @param _timestamp The timestamp of the deposit
    /// @param _amount The amount of assets deposited
    event Deposit(uint256 indexed _timestamp, uint256 _amount);

    /// @notice Emitted when a withdrawal is made
    /// @param _timestamp The timestamp of the withdrawal
    /// @param _amount The amount of assets withdrawn
    event Withdraw(uint256 indexed _timestamp, uint256 _amount);

    /// @notice Emitted when the active status of the strategy is overriden
    /// @param _timestamp The timestamp of the override
    /// @param _isStrategiesActive The new active status of the strategy
    event ActiveStatusOverriden(uint256 indexed _timestamp, bool _isStrategiesActive);

    /// @notice Emitted when Platform rescues stuck assets
    /// @param _amount The amount of assets rescued
    event Rescue(uint256 _amount);

    /********************************** Errors **********************************/

    error Unauthorized();
    error AmountMismatch();
    error StrategyActive();
    error NonExistent();
}