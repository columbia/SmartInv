// SPDX-License-Identifier: GNU-GPL v3.0 or later

pragma solidity >=0.8.0;

interface IOracleDispatch {

    // Attempts to update oracle and returns true if successful. Returns true if update unnecessary
    function updateOracle(address asset, address compareTo) external returns (bool);

    // Will return true if oracle does not need to be poked or if poke was successful
    function pokeOracle(address asset, address compareTo) external returns (bool);

    // Will return true if oracle already initialized, if oracle has successfully been initialized by this call,
    // or if oracle does not need to be initialized
    function initializeOracle(address asset, address compareTo) external returns (bool);

    // Gets the value of the asset
    // Oracle = the oracle address in specific. Optional parameter
    // Inverted pair = whether or not this call represents an inversion of typical type (ERC20 underlying, USDC compareTo) to (USDC underlying, ERC20 compareTo)
    // Must take inverse of value in this case to get REAL value
    function getValueOfAsset(
        address asset,
        address compareTo,
        bool risingEdge
    )  external view returns (uint);

    // Does this oracle need to be updated prior to our reading the price?
    // Return false if we are within desired time period
    // Or if this type of oracle does not require updates
    function oracleNeedsUpdates(address asset, address compareTo) external view returns (bool);

    // Does this oracle need to be poked prior to update and withdrawal?
    function oracleNeedsPoking(address asset, address compareTo) external view returns (bool);

    function oracleNeedsInitialization(address asset, address compareTo) external view returns (bool);

    //Only ever called if oracle needs initialization
    function canOracleBeCreatedForRoute(address asset, address compareTo) external view returns (bool);

    // How long to wait after poking the oracle before you can update it again and withdraw
    function getTimePeriodAfterPoke(address asset, address compareTo) external view returns (uint);

    // Returns a direct reference to the address that the specific contract for this pair is registered at
    function getOracleForPair(address asset, address compareTo) external view returns (address);

    // Returns a boolean if this oracle can provide data for the requested pair, used during FNFT creation
    function getPairHasOracle(address asset, address compareTo) external view returns (bool);

    //Returns the instantaneous price of asset and the decimals for that price
    function getInstantPrice(address asset, address compareTo) external view returns (uint);
}
