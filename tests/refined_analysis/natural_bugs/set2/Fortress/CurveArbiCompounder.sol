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

//  _____                 _____     _   _ _____                             _         
// |     |_ _ ___ _ _ ___|  _  |___| |_|_|     |___ _____ ___ ___ _ _ ___ _| |___ ___ 
// |   --| | |  _| | | -_|     |  _| . | |   --| . |     | . | . | | |   | . | -_|  _|
// |_____|___|_|  \_/|___|__|__|_| |___|_|_____|___|_|_|_|  _|___|___|_|_|___|___|_|  
//                                                       |_|                          

// Github - https://github.com/FortressFinance

import {AMMCompounderBase, SafeERC20, IERC20, ERC20, Address, IFortressSwap} from "src/shared/compounders/AMMCompounderBase.sol";

import {ICurveOperations} from "src/shared/fortress-interfaces/ICurveOperations.sol";
import {IConvexBoosterArbi} from "src/arbitrum/interfaces/IConvexBoosterArbi.sol";
import {IConvexBasicRewardsArbi} from "src/arbitrum/interfaces/IConvexBasicRewardsArbi.sol";

contract CurveArbiCompounder is AMMCompounderBase {
    
    using SafeERC20 for IERC20;
    using Address for address payable;

    /// @notice The address of the vault's Curve pool
    address private immutable poolAddress;
    /// @notice The internal type of pool, used in CurveOperations
    uint256 private immutable poolType;
    /// @notice The address of CRV token
    address private constant CRV = 0x11cDb42B0EB46D95f990BeDD4695A6e3fA034978;

    /********************************** Constructor **********************************/

    constructor(
        ERC20 _asset,
        string memory _name,
        string memory _symbol,
        bytes memory _settingsConfig,
        bytes memory _boosterConfig,
        address[] memory _underlyingAssets,
        uint256 _poolType
        )
        AMMCompounderBase(
            _asset,
            _name,
            _symbol,
            _settingsConfig,
            _boosterConfig,
            _underlyingAssets
        ) {
            poolType = _poolType;
            poolAddress = ICurveOperations(settings.ammOperations).getPoolFromLpToken(address(_asset));
    }

    /********************************** View Functions **********************************/

    /// @notice See {AMMConcentratorBase - isPendingRewards}
    function isPendingRewards() external override view returns (bool) {
        return IConvexBasicRewardsArbi(boosterData.crvRewards).claimable_reward(CRV, address(this)) > 0;
    }

    /********************************** Internal Functions **********************************/

    function _depositStrategy(uint256 _assets, bool _transfer) internal override {
        if (_transfer) IERC20(address(asset)).safeTransferFrom(msg.sender, address(this), _assets);
        Booster memory _boosterData = boosterData;
        IConvexBoosterArbi(_boosterData.booster).deposit(_boosterData.boosterPoolId, _assets);
    }

    function _withdrawStrategy(uint256 _assets, address _receiver, bool _transfer) internal override {
        IConvexBasicRewardsArbi(boosterData.crvRewards).withdraw(_assets, false);
        if (_transfer) IERC20(address(asset)).safeTransfer(_receiver, _assets);
    }

    function _swapFromUnderlying(address _underlyingAsset, uint256 _underlyingAmount, uint256 _minAmount) internal override returns (uint256 _assets) {
        address payable _ammOperations = settings.ammOperations;
        if (_underlyingAsset == ETH) {
            (bytes memory _result) = _ammOperations.functionCallWithValue(
                abi.encodeWithSignature("addLiquidity(address,uint256,address,uint256)", poolAddress, poolType, _underlyingAsset, _underlyingAmount),
                _underlyingAmount
            );
            _assets = abi.decode(_result, (uint256));
        } else {
            _approve(_underlyingAsset, _ammOperations, _underlyingAmount);
            _assets = ICurveOperations(_ammOperations).addLiquidity(poolAddress, poolType, _underlyingAsset, _underlyingAmount);
        }

        if (!(_assets >= _minAmount)) revert InsufficientAmountOut();
    }

    function _swapToUnderlying(address _underlyingAsset, uint256 _assets, uint256 _minAmount) internal override returns (uint256 _underlyingAmount) {
        address _ammOperations = settings.ammOperations;
        _approve(address(asset), _ammOperations, _assets);
        _underlyingAmount = ICurveOperations(_ammOperations).removeLiquidity(poolAddress, poolType, _underlyingAsset, _assets);
        
        if (!(_underlyingAmount >= _minAmount)) revert InsufficientAmountOut();
    }

    function _harvest(address _receiver, address _underlyingAsset, uint256 _minBounty) internal override returns (uint256 _rewards) {
        Booster memory _boosterData = boosterData;

        IConvexBasicRewardsArbi(_boosterData.crvRewards).getReward(address(this));
        
        Settings memory _settings = settings;
        address _rewardAsset;
        address _swap = _settings.swap;
        address[] memory _rewardAssets = _boosterData.rewardAssets;
        for (uint256 i = 0; i < _rewardAssets.length; i++) {
            _rewardAsset = _rewardAssets[i];
            
            if (_rewardAsset != _underlyingAsset) {
                if (_rewardAsset == ETH) {
                    payable(_swap).functionCallWithValue(abi.encodeWithSignature("swap(address,address,uint256)", _rewardAsset, _underlyingAsset, address(this).balance), address(this).balance);
                } else {
                    uint256 _balance = IERC20(_rewardAsset).balanceOf(address(this));
                    if (_balance > 0) {
                        IFortressSwap(_swap).swap(_rewardAsset, _underlyingAsset, _balance);
                    }
                }
            }
        }

        if (_underlyingAsset == ETH) {
            _rewards = address(this).balance;
        } else {
            _rewards = IERC20(_underlyingAsset).balanceOf(address(this));
        }

        if (_rewards > 0) {
            address _ammOperations = _settings.ammOperations;
            _approve(_underlyingAsset, _ammOperations, _rewards);
            _rewards = ICurveOperations(_ammOperations).addLiquidity(poolAddress, poolType, _underlyingAsset, _rewards);

            Fees memory _fees = fees;
            uint256 _platformFee = _fees.platformFeePercentage;
            uint256 _harvestBounty = _fees.harvestBountyPercentage;
            address _lpToken = address(asset);
            if (_platformFee > 0) {
                _platformFee = (_platformFee * _rewards) / FEE_DENOMINATOR;
                _rewards = _rewards - _platformFee;
                IERC20(_lpToken).safeTransfer(_settings.platform, _platformFee);
            }
            if (_harvestBounty > 0) {
                _harvestBounty = (_harvestBounty * _rewards) / FEE_DENOMINATOR;
                if (!(_harvestBounty >= _minBounty)) revert InsufficientAmountOut();
                _rewards = _rewards - _harvestBounty;
                IERC20(_lpToken).safeTransfer(_receiver, _harvestBounty);
            }

            IConvexBoosterArbi(_boosterData.booster).deposit(_boosterData.boosterPoolId, _rewards);

            emit Harvest(msg.sender, _receiver, _rewards, _platformFee);

            return _rewards;
        } else {
            revert NoPendingRewards();
        }
    }

    receive() external payable {}
}