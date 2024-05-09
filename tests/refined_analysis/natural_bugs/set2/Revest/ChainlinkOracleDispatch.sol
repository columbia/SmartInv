// SPDX-License-Identifier: GNU-GPL v3.0 or later

pragma solidity >=0.8.0;

import "../interfaces/IOracleDispatch.sol";
import "../interfaces/ILockManager.sol";
import "../utils/RevestAccessControl.sol";
import "../lib/chainlink/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "../lib/chainlink/Denominations.sol";

/**
 * @title Provider interface for Revest FNFTs
 * @dev Address locks MUST be non-upgradeable to be considered for trusted status
 *
 */
contract ChainlinkOracleDispatch is IOracleDispatch, RevestAccessControl {


    constructor(address provider) RevestAccessControl(provider) {}

    mapping(uint => address) public priceFeeds;

    //  Attempts to update oracle and returns true if successful. Returns true if update unnecessary
    function updateOracle(address asset, address compareTo) external pure override returns (bool) {
        return true;
    }

    //  Return true because no poke is needed
    function pokeOracle(address asset, address compareTo) external pure override returns (bool) {
        return true;
    }

    //  Will return true if oracle already initialized, if oracle has successfully been initialized by this call,
    //  or if oracle does not need to be initialized
    function initializeOracle(address asset, address compareTo) external pure override returns (bool) {
        return true;
    }


    //  Gets the value of the asset
    //  Oracle = the oracle address in specific. Optional parameter
    //  Inverted pair = whether or not this call represents an inversion of typical type (ERC20 underlying, USDC compareTo) to (USDC underlying, ERC20 compareTo)
    //  Must take inverse of value in this case to get REAL value
    function getValueOfAsset(
        address asset,
        address compareTo,
        bool risingEdge
    ) public view override returns (uint) {
        //This will never be called if there IS NOT a pair available
        //Implicit assumption for this function to be called is that getPairHasOracle has returned true


        return getPriceForOracle(asset, compareTo);
    }

    //  Oracle will never need updates
    function oracleNeedsUpdates(address asset, address compareTo) external pure override returns (bool) {
        return false;
    }

    function oracleNeedsInitialization(address asset, address compareTo) external pure override returns (bool) {
        return false;
    }

    function canOracleBeCreatedForRoute(address asset, address compareTo) external view override returns (bool) {
        return getPairHasOracle(asset, compareTo);
    }

    //  Oracle never needs poking
    function oracleNeedsPoking(address asset, address compareTo) external pure override returns (bool) {
        return false;
    }

    //  Oracle never needs poking
    function getTimePeriodAfterPoke(address asset, address compareTo) external pure override returns (uint) {
        return 0;
    }

    //  Returns a direct reference to the address that the specific contract for this pair is registered at
    function getOracleForPair(address asset, address compareTo) public view override returns (address) {
        return priceFeeds[getOracleID(asset, compareTo)];
    }

    // Returns a boolean if this oracle can provide data for the requested pair, used during FNFT creation
    function getPairHasOracle(address asset, address compareTo) public view override returns (bool) {

        return asset != compareTo && getOracleForPair(asset, compareTo) != address(0);
    }

    // Not terribly important for non-updateable oracles like Chainlink
    function getInstantPrice(address asset, address compareTo) external view override returns (uint) {
        return getValueOfAsset(asset, compareTo, true);
    }

    // INTERNAL FUNCTIONS


    //  Returns price and decimal precision
    function getPriceForOracle(address asset, address compareTo) internal view returns (uint) {
        uint id = getOracleID(asset, compareTo);
        address oracle = priceFeeds[id];
        AggregatorV3Interface priceFeed = AggregatorV3Interface(oracle);
        (, int256 answer, , , ) = priceFeed.latestRoundData();
        uint castAnswer = answer >= int256(0) ? uint(answer) : 0;
        uint linkDecimals = priceFeed.decimals();
        uint realDecimals = linkDecimals;

        if(isStandardAsset(compareTo)) {
            realDecimals = ERC20(compareTo).decimals();
        }
        // Standardize price to native precision
        return castAnswer * (10 ** realDecimals) / (10 ** linkDecimals);
    }

    function batchAddOracles(
        address[] memory asset1,
        address[] memory asset2,
        address[] memory oracle
    ) external onlyOwner {
        for (uint i = 0; i < asset1.length; i++) {
            priceFeeds[getOracleID(asset1[i], asset2[i])] = oracle[i];
        }
    }

    function addOracle(
        address asset1,
        address asset2,
        address oracle
    ) external onlyOwner {
        // Token will always be the first ID, followed by the address to compare to
        uint id = getOracleID(asset1, asset2);
        priceFeeds[id] = oracle;
    }



    //  Will return 0 if Oracle DNE
    function getOracleID(address asset, address compareTo) internal pure returns (uint) {
        return uint(keccak256(abi.encodePacked(asset, compareTo)));
    }

    //  Is the asset a real token or a denomination?
    function isStandardAsset(address asset) private pure returns (bool) {
        return asset != Denominations.USD &&
               asset != Denominations.ETH &&
               asset != Denominations.BTC &&
               asset != Denominations.GBP &&
               asset != Denominations.EUR;
    }

}
