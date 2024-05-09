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

//  _____         _                   _____             _____ _____ _____             _     
// |   __|___ ___| |_ ___ ___ ___ ___|   __|___ ___ _ _| __  |  _  |     |___ ___ ___| |___ 
// |   __| . |  _|  _|  _| -_|_ -|_ -|   __|  _| .'|_'_| __ -|   __|  |  |  _| .'|  _| | -_|
// |__|  |___|_| |_| |_| |___|___|___|__|  |_| |__,|_,_|_____|__|  |_____|_| |__,|___|_|___|

// Github - https://github.com/FortressFinance

import {Math} from '@openzeppelin/contracts/utils/math/Math.sol';
import {ICurveV2Pool} from "../interfaces/ICurveV2Pool.sol";
import {IChainlinkAggregator} from "../interfaces/IChainlinkAggregator.sol"; 

import "./BaseOracle.sol";

contract FortressFraxBPOracle is BaseOracle {

    using SafeCast for uint256;

    IChainlinkAggregator public FRAX = IChainlinkAggregator(address(0x0809E3d38d1B4214958faf06D8b1B1a2b73f2ab8));
    IChainlinkAggregator public USDC = IChainlinkAggregator(address(0x50834F3163758fcC1Df9973b6e91f0F0F0434aD3));

    /********************************** Constructor **********************************/

    constructor(address _owner, address _vault) BaseOracle(_owner, _vault) {}

    /********************************** External Functions **********************************/

    function description() external pure override returns (string memory) {
        return "fcFraxBP USD Oracle";
    }

    /********************************** Internal Functions **********************************/

    function _getPrice() internal view override returns (int256) {
        uint256 minAssetPrice = uint256(_getMinAssetPrice());
        address _fraxBP = address(0xC9B8a3FDECB9D5b218d02555a8Baf332E5B740d5);
        uint256 _assetPrice = ICurveV2Pool(_fraxBP).get_virtual_price() * minAssetPrice;

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

        (, int256 fraxPrice, ,uint256 fraxUpdatedAt, ) = FRAX.latestRoundData();
        if (fraxPrice == 0) revert zeroPrice();
        if (fraxUpdatedAt < block.timestamp - (24 * 3600)) revert stalePrice();
        
        return Math.min(uint256(usdcPrice), uint256(fraxPrice));
    }    

    /********************************** Owner Functions **********************************/

    /// @notice this function needs to be called periodically to update the last share price
    function updateLastSharePrice() external override onlyOwner {
        uint256 minAssetPrice = uint256(_getMinAssetPrice());
        address _fraxBP = address(0xC9B8a3FDECB9D5b218d02555a8Baf332E5B740d5);
        uint256 _assetPrice = ICurveV2Pool(_fraxBP).get_virtual_price() * minAssetPrice;

        lastSharePrice = ((ERC4626(vault).convertToAssets(_assetPrice) * DECIMAL_DIFFERENCE) / BASE);

        emit LastSharePriceUpdated(lastSharePrice);
    }

    function updatePriceFeed(address _fraxPriceFeed, address _usdcPriceFeed) external onlyOwner {
        USDC = IChainlinkAggregator(_usdcPriceFeed);
        FRAX = IChainlinkAggregator(_fraxPriceFeed);

        emit PriceFeedUpdated(_fraxPriceFeed, _usdcPriceFeed);
    }
}