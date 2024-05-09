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

//  _____         _                   _____ _     _____ _           _               
// |   __|___ ___| |_ ___ ___ ___ ___|   __| |___|   __| |_ ___ ___| |_ ___ ___ _ _ 
// |   __| . |  _|  _|  _| -_|_ -|_ -|  |  | | . |__   |  _|  _| .'|  _| -_| . | | |
// |__|  |___|_| |_| |_| |___|___|___|_____|_|  _|_____|_| |_| |__,|_| |___|_  |_  |
//                                           |_|                           |___|___|

// Github - https://github.com/FortressFinance

import {BaseStrategy, IAssetVault} from "./BaseStrategy.sol";

import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IFortGlp} from "./interfaces/IFortGlp.sol";
import {IFortressSwap} from "../interfaces/IFortressSwap.sol";

contract FortressGlpStrategy is BaseStrategy {

    using SafeERC20 for IERC20;

    /// @notice The address of fortGLP
    address public fortGlp;
    /// @notice The address of FortressSwap
    address public swap;

    /********************************** Constructor **********************************/

    constructor(address _assetVault, address _platform, address _manager, address _fortGlp, address _swap)
        BaseStrategy(_assetVault, _platform, _manager) {
            fortGlp = _fortGlp;
            swap = _swap;
        }

    /********************************** View Functions **********************************/

    function isActive() public view override returns (bool) {
        if (isStrategiesActiveOverride) return false;
        if (IERC20(assetVaultPrimaryAsset).balanceOf(address(this)) > 0) return true;
        if (IERC20(fortGlp).balanceOf(address(this)) > 0) return true;

        return false;
    }

    /********************************** Manager Functions **********************************/

    /// @dev Executes the strategy - deposit into fortGLP
    /// @dev _configData expects _asset, _amount and _minAmount. If _amount is set to type(uint256).max, it will deposit all the funds
    function execute(bytes memory _configData) external override onlyManager returns (uint256) {
        (address _asset, uint256 _amount, uint256 _minAmount) = abi.decode(_configData, (address, uint256, uint256));

        address _assetVaultPrimaryAsset = assetVaultPrimaryAsset;
        if (_amount == type(uint256).max) {
            _amount = IERC20(_assetVaultPrimaryAsset).balanceOf(address(this));
        }

        if (_asset != _assetVaultPrimaryAsset) {
            address _swap = swap;
            _approve(_assetVaultPrimaryAsset, _swap, _amount);
            _amount = IFortressSwap(_swap).swap(_assetVaultPrimaryAsset, _asset, _amount);
        }
        
        address _fortGlp = fortGlp;
        _approve(_asset, _fortGlp, _amount);
        uint256 _shares = IFortGlp(_fortGlp).depositUnderlying(_asset, address(this), _amount, _minAmount);

        return _shares;
    }

    /// @dev Terminates the strategy - withdraw from fortGLP
    /// @dev _configData expects _asset, _amount and _minAmount. If _amount is set to type(uint256).max, it will withdraw all the funds
    function terminate(bytes memory _configData) external override onlyManager returns (uint256) {
        (address _asset, uint256 _amount, uint256 _minAmount) = abi.decode(_configData, (address, uint256, uint256));

        if (_amount == type(uint256).max) {
            _amount = IERC20(fortGlp).balanceOf(address(this));
        }

        _amount = IFortGlp(fortGlp).redeemUnderlying(_asset, address(this), address(this), _amount, _minAmount);

        if (_asset != assetVaultPrimaryAsset) {
            address _swap = swap;
            _approve(_asset, _swap, _amount);
            _amount = IFortressSwap(_swap).swap(_asset, assetVaultPrimaryAsset, _amount);
        }

        return _amount;
    }

    /// @dev Updates the fortressSwap address
    function updateSwap(address _swap) external onlyManager {
        swap = _swap;
    }

    /********************************** Internal Functions **********************************/

    function _approve(address _asset, address _spender, uint256 _amount) internal {
        IERC20(_asset).safeApprove(_spender, 0);
        IERC20(_asset).safeApprove(_spender, _amount);
    }
}
