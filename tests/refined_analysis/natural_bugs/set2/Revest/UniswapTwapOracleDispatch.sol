// SPDX-License-Identifier: GNU-GPL v3.0 or later

pragma solidity >=0.8.0;

import "../interfaces/IOracleDispatch.sol";
import "../lib/uniswap/IUniswapV2Pair.sol";
import "../lib/uniswap/IUniswapV2Factory.sol";
import "../utils/RevestAccessControl.sol";
import "../lib/FixedPoint.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * TWAPs are uninitialized when created. Then immediately queried for their first datapoint.
 * On the second updateTwap() call, initialization becomes true.
 */
contract UniswapTwapOracleDispatch is IOracleDispatch, RevestAccessControl {

    // Maps oracle id to twap oracle struct
    mapping(uint => TwapLock) public twaps;

    // 30 seconds
    uint public constant MIN_UPDATE = 30;

    address public uniswap;

    struct TwapLock {
        // Should conform to IUniswapV2Pair interface
        address pairAddress;
        // Handle edge case where price could be 0 at first init
        bool initialized;
        uint timestampLatest;
        uint lastUpdateCumulativePrice;
        uint lastUpdateTwapPrice;
    }
    constructor(address provider, address uni) RevestAccessControl(provider) {
        uniswap = uni;
    }

    //  Will return true if oracle already initialized, if oracle has successfully been initialized by this call,
    //  or if oracle does not need to be initialized
    function initializeOracle(address asset, address compareTo) external override returns (bool) {
        address pair = IUniswapV2Factory(uniswap).getPair(asset, compareTo);
        IUniswapV2Pair uni_pair = IUniswapV2Pair(pair);
        bool inverted = uni_pair.token1() == asset;
        ERC20 metaTest = ERC20(asset);
        {
            // Check that the contract supports the decimals() method as a smoke test for ERC20 validity
            metaTest.decimals();
        }
        if(pair == address(0)) {
            // If pair DNE, cannot create oracle
            return false;
        }
        TwapLock memory twap;
        (, , twap.timestampLatest) = IUniswapV2Pair(pair).getReserves();
        twap.lastUpdateCumulativePrice = inverted ?  IUniswapV2Pair(pair).price1CumulativeLast() : IUniswapV2Pair(pair).price0CumulativeLast();
        twap.pairAddress = pair;
        twaps[getOracleID(asset, compareTo)] = twap;
        return true;
    }

    //  Attempts to update oracle and returns true if successful. Returns true if update unnecessary
    function updateOracle(address asset, address compareTo) external override returns (bool) {
        uint oracleId = getOracleID(asset, compareTo);
        TwapLock storage twap = twaps[oracleId];

        if(block.timestamp <= twap.timestampLatest + MIN_UPDATE) {
            // Wait until safe update period has passed to update TWAP
            return false;
        }
        IUniswapV2Pair pair = IUniswapV2Pair(twap.pairAddress);
        bool inverted = pair.token1() == asset;
        uint cumLast = inverted ? pair.price1CumulativeLast() : pair.price0CumulativeLast();

        uint lastTimeTwapUpdated = twap.timestampLatest;
        uint lastPrice = twap.lastUpdateCumulativePrice;

        (, , uint lastTime) = pair.getReserves();

        if(cumLast - lastPrice <= 0 || lastTime - lastTimeTwapUpdated <= 0) {
            // There has been no value on the Uniswap pair since the last update
            // Attempt to force the uni pair to sync
            pair.sync();
            // Reset variables
            cumLast = inverted ? pair.price1CumulativeLast() : pair.price0CumulativeLast();
            (, , lastTime) = pair.getReserves();
            if(cumLast - lastPrice <= 0 || lastTime - lastTimeTwapUpdated <= 0) {
                // If this has failed, we must return false
                return false;
            }
        }

        if(!twap.initialized) {
            if(twap.timestampLatest == 0) {
                twap.timestampLatest = lastTime;
                twap.pairAddress = IUniswapV2Factory(uniswap).getPair(asset, compareTo);
            }
            else {
                twap.lastUpdateTwapPrice = getTwapPrice(asset, cumLast, lastTime, lastTimeTwapUpdated, lastPrice);
                twap.lastUpdateCumulativePrice = cumLast;
                twap.timestampLatest = lastTime;
                twap.initialized = true;
            }
        }
        else {
            twap.lastUpdateTwapPrice = getTwapPrice(asset, cumLast, lastTime, lastTimeTwapUpdated, lastPrice);
            twap.lastUpdateCumulativePrice = cumLast;
            twap.timestampLatest = lastTime;
        }
        return true;
    }

    //  Return true because no poke is needed
    function pokeOracle(address asset, address compareTo) external pure override returns (bool) {
        return true;
    }

    //  Gets the value of the asset
    function getValueOfAsset(
        address asset,
        address compareTo,
        bool risingEdge
    ) external view override returns (uint) {
        if(twaps[getOracleID(asset, compareTo)].initialized) {
            return twaps[getOracleID(asset, compareTo)].lastUpdateTwapPrice;
        } else {
            if(risingEdge) {
                return 0;
            } else {
                return 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
            }
        }

    }

    function oracleNeedsInitialization(address asset, address compareTo) external pure override returns (bool) {
        return true;
    }

    //  Oracle will need updatess
    function oracleNeedsUpdates(address asset, address compareTo) external pure override returns (bool) {
        return true;
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
        return twaps[getOracleID(asset, compareTo)].pairAddress;
    }

    //  Returns a boolean if this oracle can provide data for the requested pair, used during FNFT creation
    function getPairHasOracle(address asset, address compareTo) external view override returns (bool) {
        return twaps[getOracleID(asset, compareTo)].pairAddress != address(0);
    }

    function canOracleBeCreatedForRoute(address asset, address compareTo) external view override returns (bool) {
        return asset != compareTo && IUniswapV2Factory(uniswap).getPair(asset, compareTo) != address(0);
    }

    function getInstantPrice(address asset, address compareTo) external view override returns (uint) {
        return getAssetPrice(asset, compareTo, address(0));
    }

    // INTERNAL FUNCTIONS

    function getTwapPrice(address asset, uint cumulativeLast, uint timestamp, uint lastTime, uint lastCumPrice) internal view returns (uint) {
        ERC20 erc20 = ERC20(asset);
        uint decimals = 10 ** erc20.decimals();
        FixedPoint.uq144x112 memory priceAverage = FixedPoint.uq144x112(decimals * ((cumulativeLast - lastCumPrice) / (timestamp - lastTime)));
        uint twapPrice = FixedPoint.decode144(priceAverage);
        return twapPrice;
    }

    function getAssetPrice(address asset, address compareTo, address pairAdd) internal view returns (uint) {
        IUniswapV2Pair pair = IUniswapV2Pair(pairAdd == address(0) ? getOracleForPair(asset, compareTo) : pairAdd );

        ERC20 erc20 = ERC20(asset);
        uint decimals = 10 ** erc20.decimals();

        (uint reserve0, uint reserve1, ) = pair.getReserves();

        if (pair.token0() == asset) {
            return decimals * reserve1 / reserve0;
        } else if (pair.token1() == asset) {
            return decimals * reserve0 / reserve1;
        } else {
            require(false, "Asset not part of oracle");
        }
    }

    //  Will return 0 if Oracle DNE
    function getOracleID(address asset, address compareTo) internal pure returns (uint) {
        return uint(keccak256(abi.encodePacked(asset, compareTo)));
    }



}
