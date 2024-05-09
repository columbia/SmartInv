// // SPDX-License-Identifier: MIT
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

//  _____         _                   ___ _____         _ _____             _     
// |   __|___ ___| |_ ___ ___ ___ ___|_  |  _  |___ ___| |     |___ ___ ___| |___ 
// |   __| . |  _|  _|  _| -_|_ -|_ -|  _|   __| . | . | |  |  |  _| .'|  _| | -_|
// |__|  |___|_| |_| |_| |___|___|___|___|__|  |___|___|_|_____|_| |__,|___|_|___|

// Github - https://github.com/FortressFinance

import {Math} from '@openzeppelin/contracts/utils/math/Math.sol';
import {ICurveV2Pool} from "../interfaces/ICurveV2Pool.sol";
import {IChainlinkAggregator} from "../interfaces/IChainlinkAggregator.sol"; 

import "./BaseOracle.sol";

contract Fortress2PoolOracle is BaseOracle {

    using SafeCast for uint256;

    IChainlinkAggregator public USDC = IChainlinkAggregator(address(0x50834F3163758fcC1Df9973b6e91f0F0F0434aD3));
    IChainlinkAggregator public USDT = IChainlinkAggregator(address(0x3f3f5dF88dC9F13eac63DF89EC16ef6e7E25DdE7));

    /********************************** Constructor **********************************/

    constructor(address _owner, address _vault) BaseOracle(_owner, _vault) {}

    /********************************** External Functions **********************************/

    function description() external pure override returns (string memory) {
        return "fc2Pool USD Oracle";
    }

    /********************************** Internal Functions **********************************/

    function _getPrice() internal view override returns (int256) {
        address _twoPool = address(0x7f90122BF0700F9E7e1F688fe926940E8839F353);
        uint256 minAssetPrice = uint256(_getMinAssetPrice());
        uint256 _assetPrice = ICurveV2Pool(_twoPool).get_virtual_price() * minAssetPrice;

        uint256 _sharePrice = ((ERC4626(vault).convertToAssets(_assetPrice) * DECIMAL_DIFFERENCE) / BASE);

        // check that vault share price deviation did not exceed the configured bounds
        if (isCheckPriceDeviation) _checkPriceDeviation(_sharePrice);
        _checkVaultSpread();

        return _sharePrice.toInt256();
    }

    function _getMinAssetPrice() internal view returns (uint256) {
        (, int256 usdcPrice, ,uint256 usdcUpdatedAt, ) = USDC.latestRoundData();
        if (usdcPrice == 0) revert zeroPrice();
        if (usdcUpdatedAt < block.timestamp - (24 * 3600)) revert stalePrice();

        (, int256 usdtPrice, ,uint256 usdtUpdatedAt, ) = USDT.latestRoundData();
        if (usdtPrice == 0) revert zeroPrice();
        if (usdtUpdatedAt < block.timestamp - (24 * 3600)) revert stalePrice();
        
        return Math.min(uint256(usdcPrice), uint256(usdtPrice));
    }

    /********************************** Owner Functions **********************************/

    /// @notice this function needs to be called periodically to update the last share price
    function updateLastSharePrice() external override onlyOwner {
        address _twoPool = address(0x7f90122BF0700F9E7e1F688fe926940E8839F353);
        uint256 minAssetPrice = uint256(_getMinAssetPrice());
        uint256 _assetPrice = ICurveV2Pool(_twoPool).get_virtual_price() * minAssetPrice;

        lastSharePrice = ((ERC4626(vault).convertToAssets(_assetPrice) * DECIMAL_DIFFERENCE) / BASE);

        emit LastSharePriceUpdated(lastSharePrice);
    }

    function updatePriceFeed(address _usdtPriceFeed, address _usdcPriceFeed) external onlyOwner {
        USDC = IChainlinkAggregator(_usdcPriceFeed);
        USDT = IChainlinkAggregator(_usdtPriceFeed);

        emit PriceFeedUpdated(_usdtPriceFeed, _usdcPriceFeed);
    }
}