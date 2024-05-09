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

//  __ __ ___ _____ _____ _                     _____ _           _               
// |  |  |_  |  |  |   __|_|___ ___ ___ ___ ___|   __| |_ ___ ___| |_ ___ ___ _ _ 
// |_   _|  _|    -|   __| |   | .'|   |  _| -_|__   |  _|  _| .'|  _| -_| . | | |
//   |_| |___|__|__|__|  |_|_|_|__,|_|_|___|___|_____|_| |_| |__,|_| |___|_  |_  |
//                                                                       |___|___|

// Github - https://github.com/FortressFinance

import {BaseStrategy, IAssetVault} from "./BaseStrategy.sol";
import {IY2KVault} from "./interfaces/IY2KVault.sol";
import {IY2KRewards} from "./interfaces/IY2KRewards.sol";
import {IFortressSwap} from "../interfaces/IFortressSwap.sol";

import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IERC1155} from "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";

contract Y2KFinanceStrategy is BaseStrategy {

    using SafeERC20 for IERC20;
    
    /// @notice The address of FortressSwap
    address public swap;

    /// @notice The address of the Y2K token
    address private constant Y2K = address(0x65c936f008BC34fE819bce9Fa5afD9dc2d49977f);
    /// @notice The address of the WETH token
    address private constant WETH = address(0x82aF49447D8a07e3bd95BD0d56f35241523fBab1);

    /// @notice Array of vaults that were used
    address[] vaults;
    /// @notice Array of vault IDs that were used
    uint256[] vaultIDs;

    /// @notice Indicates if a vault is used
    mapping(address => bool) isVault;
    /// @notice The address of the Y2K Rewards contract for a specific vault and ID
    mapping(address => mapping(uint => address)) stakingRewards;


    /********************************** Constructor **********************************/

    constructor(address _assetVault, address _platform, address _manager, address _swap)
        BaseStrategy(_assetVault, _platform, _manager) {
            if (!IFortressSwap(_swap).routeExists(Y2K, assetVaultPrimaryAsset)) revert InvalidSwap();
            if (assetVaultPrimaryAsset != WETH) revert InvalidAssetVault();

            swap = _swap;
        }

    /********************************** View Functions **********************************/

    function isActive() public view override returns (bool) {
        if (isStrategiesActiveOverride) return false;
        if (IERC20(assetVaultPrimaryAsset).balanceOf(address(this)) > 0) return true;

        address[] memory _vaults = vaults;
        uint256[] memory _vaultIDs = vaultIDs;
        for (uint256 i = 0; i < vaults.length; i++) {
            if (IY2KVault(_vaults[i]).balanceOf(address(this), _vaultIDs[i]) > 0) return true;
        }

        return false;
    }

    /********************************** Manager Functions **********************************/

    // TODO - fix docs
    /// @dev Executes the strategy - deposit into a Y2K Risk/Hedge Vault
    /// @dev _configData:
    /// @dev _index - index of the vault in the vaultFactory, determines the asset and the strike vault
    /// @dev _amount - amount of the assetVaultPrimaryAsset to deposit, will be set to the balance if set to type(uint256).max
    /// @dev _id - id of the vault in the vaultFactory, determines end date of the Epoch
    /// @dev _type - true for Risk Vault, false for Hedge Vault
    function execute(bytes memory _configData) external override onlyManager returns (uint256) {

        (uint256 _id, uint256 _amount, address _vault, address _stakingRewards) = abi.decode(_configData, (uint256, uint256, address, address));

        address _assetVaultPrimaryAsset = assetVaultPrimaryAsset;
        if (_amount == type(uint256).max) {
            _amount = IERC20(_assetVaultPrimaryAsset).balanceOf(address(this));
        }

        if (!isVault[_vault]) {
            isVault[_vault] = true;
            vaults.push(_vault);
            vaultIDs.push(_id);
        }

        uint256 _before = IERC1155(_vault).balanceOf(address(this), _id);
        IERC20(_assetVaultPrimaryAsset).safeApprove(_vault, _amount);
        IY2KVault(_vault).deposit(_id, _amount, address(this));
        // TODO - should revert because no ERC1155Receiver implemented
        uint256 _shares = IERC1155(_vault).balanceOf(address(this), _id) - _before;

        if (_stakingRewards != address(0)) {
            stakingRewards[_vault][_id] = _stakingRewards;

            IERC1155(_vault).setApprovalForAll(_stakingRewards, true);
            IY2KRewards(_stakingRewards).stake(_shares);
            IERC1155(_vault).setApprovalForAll(_stakingRewards, false);
        }

        return _shares;
    }

    // TODO - fix docs
    /// @dev Terminates the strategy - withdraw from fortGLP
    /// @dev _configData:
    /// @dev _index - index of the vault in the vaultFactory, determines the asset and the strike vault
    /// @dev _amount - amount of the assetVaultPrimaryAsset to deposit, will be set to the balance if set to type(uint256).max
    /// @dev _id - id of the vault in the vaultFactory, determines end date of the Epoch
    /// @dev _type - true for Risk Vault, false for Hedge Vault
    function terminate(bytes memory _configData) external override onlyManager returns (uint256) {
        
        (uint256 _id, uint256 _shares, address _vault, bool _claimRewards) = abi.decode(_configData, (uint256,uint256,address,bool));
        
        address _assetVaultPrimaryAsset = assetVaultPrimaryAsset;
        uint256 _before = IERC20(_assetVaultPrimaryAsset).balanceOf(address(this));
        if (_shares == type(uint256).max) {
            _shares = IERC1155(_vault).balanceOf(address(this), _id);
        }

        address _stakingRewards = stakingRewards[_vault][_id];
        if (_stakingRewards != address(0)) {
            // TODO - should revert because no ERC1155Receiver implemented
            IY2KRewards(_stakingRewards).withdraw(_shares);
            if (_claimRewards) _getRewards(_stakingRewards);
        }

        IY2KVault(_vault).withdraw(_id, _shares, address(this), address(this));

        return IY2KVault(_vault).balanceOf(address(this), _id) - _before;
    }

    /// @dev Updates the fortressSwap address
    function updateSwap(address _swap) external onlyManager {
        if (IFortressSwap(_swap).routeExists(Y2K, assetVaultPrimaryAsset)) revert InvalidSwap();

        swap = _swap;
    }

    /********************************** Internal Functions **********************************/

    /// @dev increases the balance of assetVaultPrimaryAsset by swapping Y2K tokens
    function _getRewards(address _stakingRewards) internal {
        address _y2k = Y2K;
        uint256 before = IERC20(_y2k).balanceOf(address(this));
        IY2KRewards(_stakingRewards).getReward();
        uint256 _rewards = IERC20(_y2k).balanceOf(address(this)) - before;
        
        emit Y2KRewards(_rewards);

        if (_rewards > 0) {
            address _swap = swap;
            IERC20(_y2k).safeApprove(_swap, IERC20(_y2k).balanceOf(address(this)) - before);
            _rewards = IFortressSwap(_swap).swap(_y2k, assetVaultPrimaryAsset, _rewards);

            emit PrimaryAssetRewards(_rewards);
        } else {
            revert NoRewards();
        }
    }

    /********************************** Events **********************************/

    event PrimaryAssetRewards(uint256 _rewards);
    event Y2KRewards(uint256 _rewards);

    /********************************** Errors **********************************/

    error InvalidSwap();
    error NoRewards();
    error InvalidAssetVault();
}
