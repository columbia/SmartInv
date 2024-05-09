// SPDX-License-Identifier: GNU-GPL v3.0 or later

pragma solidity >=0.8.0;

import "../interfaces/IOracleDispatch.sol";
import "../utils/RevestAccessControl.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import '@uniswap/v3-core/contracts/interfaces/pool/IUniswapV3PoolState.sol';


interface V3Oracle {
    function assetToAsset(address, uint, address, uint32) external view returns (uint);
}

contract UniswapV3CronjeSon is IOracleDispatch, RevestAccessControl {

    // Hardcoded mainnet deployment, sourced via Andre Cronje
    V3Oracle constant oracle = V3Oracle(0x0F1f5A87f99f0918e6C81F16E59F3518698221Ff);
    // Period to measure TWAP over, in seconds
    uint32 public constant TWAP_PERIOD = 900;
    // Wrapped ETH address
    address public immutable WETH;
    // Mainnet: 0x1F98431c8aD98523631AE4a59f267346ea31F984
    address public immutable UNIV3_FACTORY;
    // Mainnet: 3000
    uint24 public immutable UNIV3_FEE;

    constructor(address provider, address weth, address uni_v3, uint24 uniFee) RevestAccessControl(provider) {
        WETH = weth;
        UNIV3_FACTORY = uni_v3;
        UNIV3_FEE = uniFee;
    }

    // Attempts to update oracle and returns true if successful. Returns true if update unnecessary
    function updateOracle(address asset, address compareTo) external pure override returns (bool) {
        return true;
    }

    // Will return true if oracle does not need to be poked or if poke was successful
    function pokeOracle(address asset, address compareTo) external pure override returns (bool) {
        return true;
    }

    // Will return true if oracle already initialized, if oracle has successfully been initialized by this call,
    // or if oracle does not need to be initialized
    function initializeOracle(address asset, address compareTo) external override returns (bool) {
        return true;
    }

    // Gets the value of the asset
    // Oracle = the oracle address in specific. Optional parameter
    function getValueOfAsset(
        address asset,
        address compareTo,
        bool risingEdge
    )  external view override returns (uint) {
        uint decimals = ERC20(asset).decimals();
        uint price = oracle.assetToAsset(asset, 10**decimals, compareTo, TWAP_PERIOD);
        return price;
    }

    // Does this oracle need to be updated prior to our reading the price?
    // Return false if we are within desired time period
    // Or if this type of oracle does not require updates
    function oracleNeedsUpdates(address asset, address compareTo) external pure override returns (bool) {
        return false;
    }

    // Does this oracle need to be poked prior to update and withdrawal?
    function oracleNeedsPoking(address asset, address compareTo) external pure override returns (bool) {
        return false;
    }

    function oracleNeedsInitialization(address asset, address compareTo) external view override returns (bool) {
        return false;
    }

    //Only ever called if oracle needs initialization
    function canOracleBeCreatedForRoute(address asset, address compareTo) external view override returns (bool) {
        return getPairHasOracle(asset, compareTo);
    }

    // How long to wait after poking the oracle before you can update it again and withdraw
    function getTimePeriodAfterPoke(address asset, address compareTo) external pure override returns (uint) {
        return 0;
    }

    // Returns a direct reference to the address that the specific contract for this pair is registered at
    function getOracleForPair(address asset, address compareTo) external pure override returns (address) {
        return 0x0F1f5A87f99f0918e6C81F16E59F3518698221Ff;
    }

    // Returns a boolean if this oracle can provide data for the requested pair, used during FNFT creation
    // If the oracle does not exist, this will revert the transaction
    function getPairHasOracle(address asset, address compareTo) public view override returns (bool) {
        //First, check if standard ERC20 with decimals() method
        uint decimals = ERC20(asset).decimals();
        uint price = oracle.assetToAsset(asset, 10**decimals, compareTo, TWAP_PERIOD);
        return true;
    }

    //Returns the instantaneous price of asset and the decimals for that price
    function getInstantPrice(address asset, address compareTo) external view override returns (uint) {
        uint decimals = ERC20(asset).decimals();
        return oracle.assetToAsset(asset, 10**decimals, compareTo, TWAP_PERIOD);
    }

}
