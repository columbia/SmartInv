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

//  _____             _   _____         _ _   
// |  _  |___ ___ ___| |_|  |  |___ _ _| | |_ 
// |     |_ -|_ -| -_|  _|  |  | .'| | | |  _|
// |__|__|___|___|___|_|  \___/|__,|___|_|_|  

// Github - https://github.com/FortressFinance

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";

import {IStrategy} from "./interfaces/IStrategy.sol";
import {IFortressSwap} from "./interfaces/IFortressSwap.sol";
import {IMetaVault} from "./interfaces/IMetaVault.sol";
import {IAssetVault} from "./interfaces/IAssetVault.sol";

contract AssetVault is ReentrancyGuard, IAssetVault {

    using SafeERC20 for ERC20;

    /// @notice The asset managed by this vault
    address internal primaryAsset;
    /// @notice The metaVault that manages this vault
    address public metaVault;
    /// @notice The Primary Asset of the metaVault
    address public metaVaultPrimaryAsset;
    /// @notice The platform address
    address public platform;
    /// @notice The vault manager address
    address public manager;
    /// @notice The address of the newly initiated strategy
    address public initiatedStrategy;
    /// @notice The timelock duration, in seconds
    uint256 public timelockDuration;
    /// @notice The timelock timestamp
    uint256 public timelock;
    /// @notice Indicates whether the timelock was initiated
    bool public isTimelocked;
    /// @notice Enables Platform to override isStrategiesActive value
    bool public isStrategiesActiveOverride;

    /// @notice The address list of strategies
    address[] public strategyList;

    /// @notice The mapping of strategies
    mapping(address => bool) public strategies;
    /// @notice The mapping of blacklisted strategies
    mapping(address => bool) public blacklistedStrategies;

    /********************************** Constructor **********************************/
    
    constructor(address _primaryAsset, address _metaVault, address _metaVaultPrimaryAsset, address _platform, address _manager) {
        primaryAsset = _primaryAsset;
        metaVault = _metaVault;
        platform = _platform;
        manager = _manager;
        metaVaultPrimaryAsset = _metaVaultPrimaryAsset;
        
        timelockDuration = 1 days;
        isStrategiesActiveOverride = false;
    }

    /********************************** Modifiers **********************************/

    modifier onlyPlatform() {
        if (msg.sender != platform) revert Unauthorized();
        _;
    }

    /// @notice Platform has admin access
    modifier onlyMetaVault {
        if (msg.sender != metaVault && msg.sender != platform) revert Unauthorized();
        _;
    }

    /// @notice Platform has admin access
    modifier onlyManager() {
        if (msg.sender != manager && msg.sender != platform) revert Unauthorized();
        _;
    }

    modifier unmanaged() {
        if (!IMetaVault(metaVault).isUnmanaged()) revert InvalidState();
        _;
    }

    /********************************** View Functions **********************************/

    /// @inheritdoc IAssetVault
    function isActive() external view returns (bool) {
        return ERC20(primaryAsset).balanceOf(address(this)) > 0 || areStrategiesActive();
    }

    /// @inheritdoc IAssetVault
    function isStrategyActive(address _strategy) public view returns (bool) {
        return strategies[_strategy] && IStrategy(_strategy).isActive() && !blacklistedStrategies[_strategy];
    }

    /// @inheritdoc IAssetVault
    function areStrategiesActive() public view returns (bool) {
        if (isStrategiesActiveOverride) return false;

        address[] memory _strategyList = strategyList;
        for (uint256 i = 0; i < _strategyList.length; i++) {
            if (isStrategyActive(_strategyList[i])) {
                return true;
            }
        }
        return false;
    }

    /// @inheritdoc IAssetVault
    function getAsset() external view returns (address) {
        return primaryAsset;
    }

    /********************************** Meta Vault Functions **********************************/

    /// @inheritdoc IAssetVault
    function deposit(uint256 _amount) external onlyMetaVault nonReentrant returns (uint256 _amountIn) {
        address _primaryAsset = primaryAsset;
        address _metaVault = metaVault;
        address _metaVaultPrimaryAsset = metaVaultPrimaryAsset;
        uint256 _before = ERC20(_primaryAsset).balanceOf(address(this));
        ERC20(_metaVaultPrimaryAsset).safeTransferFrom(_metaVault, address(this), _amount);
        if (_primaryAsset != _metaVaultPrimaryAsset) {
            address _swap = IMetaVault(_metaVault).getSwap();
            _approve(_metaVaultPrimaryAsset, _swap, _amount);
            _amount = IFortressSwap(_swap).swap(_metaVaultPrimaryAsset, _primaryAsset, _amount);
        }
        
        _amountIn = ERC20(_primaryAsset).balanceOf(address(this)) - _before;

        emit Deposited(block.timestamp, _amount);

        return _amountIn;
    }

    /// @inheritdoc IAssetVault
    function withdraw(uint256 _amount) public onlyMetaVault nonReentrant returns (uint256 _amountOut) {
        address _primaryAsset = primaryAsset;
        address _metaVaultPrimaryAsset = metaVaultPrimaryAsset;
        address _metaVault = metaVault;
        uint256 _before = ERC20(_metaVaultPrimaryAsset).balanceOf(_metaVault);
        if (_primaryAsset != _metaVaultPrimaryAsset) {
            address _swap = IMetaVault(metaVault).getSwap();
            _approve(_primaryAsset, _swap, _amount);
            _amount = IFortressSwap(IMetaVault(metaVault).getSwap()).swap(_primaryAsset, _metaVaultPrimaryAsset, _amount);
        }

        ERC20(_metaVaultPrimaryAsset).safeTransfer(_metaVault, _amount);
        _amountOut = ERC20(_metaVaultPrimaryAsset).balanceOf(_metaVault) - _before;

        emit Withdrawn(block.timestamp, _amount);
        
        return _amountOut;
    }

    /********************************** Manager Functions **********************************/

    /// @inheritdoc IAssetVault
    function depositToStrategy(address _strategy, uint256 _amount) external onlyManager nonReentrant {
        if (!strategies[_strategy]) revert StrategyNonExistent();
        if (blacklistedStrategies[_strategy]) revert StrategyBlacklisted();

        address _primaryAsset = primaryAsset;
        _approve(_primaryAsset, _strategy, _amount);
        IStrategy(_strategy).deposit(_amount);

        emit DepositedToStrategy(block.timestamp, _strategy, _amount);
    }

    /// @inheritdoc IAssetVault
    function withdrawFromStrategy(address _strategy, uint256 _amount) external onlyManager nonReentrant {
        if (!strategies[_strategy]) revert StrategyNonExistent();

        IStrategy(_strategy).withdraw(_amount);

        emit WithdrawnFromStrategy(block.timestamp, _strategy, _amount);
    }

    /// @inheritdoc IAssetVault
    function withdrawAllFromAllStrategies() external onlyManager {
        address[] memory _strategyList = strategyList;
        for (uint256 i = 0; i < _strategyList.length; i++) {
            if (!blacklistedStrategies[_strategyList[i]]) {
                IStrategy(_strategyList[i]).withdrawAll();
            }
        }
        
        emit WithdrawnFromAllStrategies(block.timestamp);
    }

    /// @inheritdoc IAssetVault
    function initiateStrategy(address _strategy) public onlyManager unmanaged nonReentrant {
        timelock = block.timestamp;
        isTimelocked = true;
        initiatedStrategy = _strategy;

        emit StrategyInitiated(block.timestamp, _strategy);
    }

    /// @inheritdoc IAssetVault
    function addStrategy() external onlyManager unmanaged nonReentrant {
        if (isTimelocked == false) revert NotTimelocked();
        if (timelock + timelockDuration > block.timestamp) revert TimelockNotExpired();
        
        address _strategy = initiatedStrategy;
        if (blacklistedStrategies[_strategy]) revert StrategyBlacklisted();
        if (strategies[_strategy]) revert StrategyAlreadyActive();

        strategies[_strategy] = true;
        strategyList.push(_strategy);
        initiatedStrategy = address(0);

        isTimelocked = false;

        emit StrategyAdded(block.timestamp, _strategy);
    }

    /// @inheritdoc IAssetVault
    function updateManager(address _manager) external onlyManager unmanaged {
        manager = _manager;

        emit ManagerUpdated(block.timestamp, _manager);
    }

    /********************************** Platform Functions **********************************/

    /// @inheritdoc IAssetVault
    function updateTimelockDuration(uint256 _timelockDuration) external onlyPlatform unmanaged {
        timelockDuration = _timelockDuration;

        emit TimelockDurationUpdated(block.timestamp, _timelockDuration);
    }

    /// @inheritdoc IAssetVault
    function platformAddStrategy(address _strategy) external onlyPlatform unmanaged {
        strategies[_strategy] = true;
        strategyList.push(_strategy);

        emit StrategyAdded(block.timestamp, _strategy);
    }

    /// @inheritdoc IAssetVault
    function overrideActiveStatus(bool _isStrategiesActive) external onlyPlatform {
        isStrategiesActiveOverride = _isStrategiesActive;

        emit ActiveStatusOverriden(block.timestamp, _isStrategiesActive);
    }

    /// @inheritdoc IAssetVault
    function setBlacklistStatus(address _strategy, bool _isBlacklisted) external onlyPlatform {
        if (strategies[_strategy] == false) revert StrategyNonExistent();

        blacklistedStrategies[_strategy] = _isBlacklisted;

        emit BlacklistStatusOverriden(block.timestamp, _strategy, _isBlacklisted);
    }

    /********************************** Internal Functions **********************************/

    function _approve(address _asset, address _spender, uint256 _amount) internal {
        ERC20(_asset).safeApprove(_spender, 0);
        ERC20(_asset).safeApprove(_spender, _amount);
    }
}