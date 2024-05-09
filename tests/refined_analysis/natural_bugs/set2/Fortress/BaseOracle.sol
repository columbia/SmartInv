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

//  _____             _____             _     
// | __  |___ ___ ___|     |___ ___ ___| |___ 
// | __ -| .'|_ -| -_|  |  |  _| .'|  _| | -_|
// |_____|__,|___|___|_____|_| |__,|___|_|___|

// Github - https://github.com/FortressFinance

import {ERC4626} from "@solmate/mixins/ERC4626.sol";
import {AggregatorV3Interface} from "@chainlink/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {SafeCast} from "@openzeppelin/contracts/utils/math/SafeCast.sol";

contract BaseOracle is AggregatorV3Interface {

    using SafeCast for uint256;

    uint256 public lastSharePrice;
    uint256 public lowerBoundPercentage;
    uint256 public upperBoundPercentage;
    uint256 public vaultMaxSpread;

    address public owner;
    address public vault;

    bool public isCheckPriceDeviation;

    uint256 constant internal DECIMAL_DIFFERENCE = 1e6;
    uint256 constant internal BASE = 1e18;

    /********************************** Constructor **********************************/

    constructor(address _owner, address _vault) {

        lowerBoundPercentage = 20;
        upperBoundPercentage = 20;
        
        owner = _owner;
        vault = _vault;

        uint256 _vaultSpread = ERC4626(_vault).convertToAssets(1e18);
        vaultMaxSpread = _vaultSpread * 110 / 100; // limit to 10% of the vault spread

        lastSharePrice = uint256(_getPrice());

        isCheckPriceDeviation = true;
    }

    /********************************** Modifiers **********************************/

    modifier onlyOwner() {
        if (msg.sender != owner) revert notOwner();
        _;
    }

    /********************************** External Functions **********************************/

    function decimals() external pure virtual returns (uint8) {
        return 18;
    }

    function description() external pure virtual returns (string memory) {
        return "Fortress Oracle";
    }

    function version() external pure virtual returns (uint256) {
        return 1;
    }

    function getRoundData(uint80) external pure virtual returns (uint80, int256, uint256, uint256, uint80) {
        revert("Not implemented");
    }

    function latestRoundData() external view virtual returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound) {
        return (0, _getPrice(), 0, 0, 0);
    }

    /********************************** Internal Functions **********************************/

    function _getPrice() internal view virtual returns (int256) {}

    /// @dev make sure that lp token price has not deviated by more than x% since last recorded price
    /// @dev used to limit the risk of lp token price manipulation
    function _checkPriceDeviation(uint256 _sharePrice) internal view {
        uint256 _lastSharePrice = lastSharePrice;
        uint256 _lowerBound = (_lastSharePrice * (100 - lowerBoundPercentage)) / 100;
        uint256 _upperBound = (_lastSharePrice * (100 + upperBoundPercentage)) / 100;

        if (_sharePrice < _lowerBound || _sharePrice > _upperBound) revert priceDeviationTooHigh();
    }

    function _checkVaultSpread() internal view {
        if (ERC4626(vault).convertToAssets(1e18) > vaultMaxSpread) revert vaultMaxSpreadExceeded();
    }

    /********************************** Owner Functions **********************************/

    /// @notice this function needs to be called periodically to update the last share price
    function updateLastSharePrice() external virtual onlyOwner {}

    function shouldCheckPriceDeviation(bool _check) external onlyOwner {
        isCheckPriceDeviation = _check;

        emit PriceDeviationCheckUpdated(_check);
    }

    function updatePriceDeviationBounds(uint256 _lowerBoundPercentage, uint256 _upperBoundPercentage) external onlyOwner {
        lowerBoundPercentage = _lowerBoundPercentage;
        upperBoundPercentage = _upperBoundPercentage;

        emit PriceDeviationBoundsUpdated(_lowerBoundPercentage, _upperBoundPercentage);
    }

    function updateVaultMaxSpread(uint256 _vaultMaxSpread) external onlyOwner {
        vaultMaxSpread = _vaultMaxSpread;

        emit VaultMaxSpreadUpdated(_vaultMaxSpread);
    }

    function updateOwner(address _owner) external onlyOwner {
        owner = _owner;

        emit OwnershipTransferred(owner, _owner);
    }

    /********************************** Events **********************************/

    event LastSharePriceUpdated(uint256 lastSharePrice);
    event PriceDeviationCheckUpdated(bool isCheckPriceDeviation);
    event PriceDeviationBoundsUpdated(uint256 lowerBoundPercentage, uint256 upperBoundPercentage);
    event VaultMaxSpreadUpdated(uint256 vaultMaxSpread);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event PriceFeedUpdated(address indexed usdtPriceFeed, address indexed usdcPriceFeed);

    /********************************** Errors **********************************/

    error priceDeviationTooHigh();
    error vaultMaxSpreadExceeded();
    error notOwner();
    error zeroPrice();
    error stalePrice();
}