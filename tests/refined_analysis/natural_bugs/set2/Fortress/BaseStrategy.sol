// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

// ███████╗░█████╗░██████╗░████████╗██████╗░███████╗░██████╗░██████╗
// ██╔════╝██╔══██╗██╔══██╗╚══██╔══╝██╔══██╗██╔════╝██╔════╝██╔════╝
// █████╗░░██║░░██║██████╔╝░░░██║░░░██████╔╝█████╗░░╚█████╗░╚█████╗░
// ██╔══╝░░██║░░██║██╔══██╗░░░██║░░░██╔══██╗██╔══╝░░░╚═══██╗░╚═══██╗
// ██║░░░░░╚█████╔╝██║░░██║░░░██║░░░██║░░██║███████╗██████╔╝██████╔╝
// ╚═╝░░░░░░╚════╝░╚═╝░░╚═╝░░░╚═╝░░░╚═╝░░╚═╝╚══════╝╚═════╝░╚═════╝░
// ███████╗██╗███╗░░██╗░█████╗░███╗░░██╗░█████╗░███████╗
// ██╔════╝██║████╗░██║██╔══██╗████╗░██║██╔══██╗██╔════╝
// █████╗░░██║██╔██╗██║███████║██╔██╗██║██║░░╚═╝█████╗░░
// ██╔══╝░░██║██║╚████║██╔══██║██║╚████║██║░░██╗██╔══╝░░
// ██║░░░░░██║██║░╚███║██║░░██║██║░╚███║╚█████╔╝███████╗
// ╚═╝░░░░░╚═╝╚═╝░░╚══╝╚═╝░░╚═╝╚═╝░░╚══╝░╚════╝░╚══════╝

//  _____             _____ _           _               
// | __  |___ ___ ___|   __| |_ ___ ___| |_ ___ ___ _ _ 
// | __ -| .'|_ -| -_|__   |  _|  _| .'|  _| -_| . | | |
// |_____|__,|___|___|_____|_| |_| |__,|_| |___|_  |_  |
//                                             |___|___|

// Github - https://github.com/FortressFinance

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";

import {IAssetVault} from "../interfaces/IAssetVault.sol";
import {IMetaVault} from "../interfaces/IMetaVault.sol";
import {IStrategy} from "../interfaces/IStrategy.sol";

abstract contract BaseStrategy is ReentrancyGuard, IStrategy {

    using SafeERC20 for IERC20;
    
    /// @notice The assetVault that manages this strategy vault
    address public assetVault;
    /// @notice The assetVault Primary Asset
    address public assetVaultPrimaryAsset;
    /// @notice The platform address
    address public platform;
    /// @notice The vault manager address
    address public manager;
    /// @notice Enables Platform to override isStrategiesActive value
    bool public isStrategiesActiveOverride;

    /********************************** Constructor **********************************/
    
    constructor(address _assetVault, address _platform, address _manager) {
        assetVault = _assetVault;
        platform = _platform;
        manager = _manager;

        assetVaultPrimaryAsset = IAssetVault(_assetVault).getAsset();
        isStrategiesActiveOverride = false;
    }

    /********************************* Modifiers **********************************/

    /// @notice Platform has admin access
    modifier onlyAssetVault() {
        if (msg.sender != assetVault && msg.sender != platform) revert Unauthorized();
        _;
    }

    modifier onlyPlatform() {
        if (msg.sender != platform) revert Unauthorized();
        _;
    }

    /// @notice Platform has admin access
    modifier onlyManager() {
        if (msg.sender != manager && msg.sender != platform) revert Unauthorized();
        _;
    }

    /********************************** View Functions **********************************/

    /// @inheritdoc IStrategy
    function isActive() public view virtual returns (bool) {
        if (isStrategiesActiveOverride) return false;
        if (IERC20(assetVaultPrimaryAsset).balanceOf(address(this)) > 0) return true;

        return false;
    }

    /********************************** Asset Vault Functions **********************************/

    /// @inheritdoc IStrategy
    function deposit(uint256 _amount) external virtual onlyAssetVault nonReentrant {
        address _assetVaultPrimaryAsset = assetVaultPrimaryAsset;
        uint256 _before = IERC20(_assetVaultPrimaryAsset).balanceOf(address(this));
        IERC20(_assetVaultPrimaryAsset).safeTransferFrom(assetVault, address(this), _amount);
        uint256 _amountIn = IERC20(_assetVaultPrimaryAsset).balanceOf(address(this)) - _before;
        if (_amountIn != _amount) revert AmountMismatch();

        emit Deposit(block.timestamp, _amountIn);
    }

    /// @inheritdoc IStrategy
    function withdraw(uint256 _amount) public virtual onlyAssetVault nonReentrant {
        address _assetVaultPrimaryAsset = assetVaultPrimaryAsset;
        address _assetVault = assetVault;
        uint256 _before = IERC20(_assetVaultPrimaryAsset).balanceOf(_assetVault);
        IERC20(_assetVaultPrimaryAsset).safeTransfer(_assetVault, _amount);
        uint256 _amountOut = IERC20(_assetVaultPrimaryAsset).balanceOf(_assetVault) - _before;
        if (_amountOut != _amount) revert AmountMismatch();

        emit Withdraw(block.timestamp, _amountOut);
    }

    /// @inheritdoc IStrategy
    function withdrawAll() public virtual onlyAssetVault {
        if (isActive()) revert StrategyActive();

        withdraw(IERC20(assetVaultPrimaryAsset).balanceOf(address(this)));
    }

    /********************************** Manager Functions **********************************/

    /// @inheritdoc IStrategy
    function execute(bytes memory _configData) external virtual onlyManager returns (uint256) {}

    /// @inheritdoc IStrategy
    function terminate(bytes memory _configData) external virtual onlyManager returns (uint256) {}

    /********************************** Platform Functions **********************************/

    /// @inheritdoc IStrategy
    function overrideActiveStatus(bool _isStrategiesActive) external onlyPlatform {
        isStrategiesActiveOverride = _isStrategiesActive;

        emit ActiveStatusOverriden(block.timestamp, _isStrategiesActive);
    }

    /// @inheritdoc IStrategy
    function rescueERC20(uint256 _amount) external onlyPlatform {
        IERC20(assetVaultPrimaryAsset).safeTransfer(platform, _amount);

        emit Rescue(_amount);
    }
}