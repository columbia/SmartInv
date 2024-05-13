1 // SPDX-License-Identifier: GNU-GPL v3.0 or later
2 
3 pragma solidity >=0.8.0;
4 
5 interface IOracleDispatch {
6 
7     // Attempts to update oracle and returns true if successful. Returns true if update unnecessary
8     function updateOracle(address asset, address compareTo) external returns (bool);
9 
10     // Will return true if oracle does not need to be poked or if poke was successful
11     function pokeOracle(address asset, address compareTo) external returns (bool);
12 
13     // Will return true if oracle already initialized, if oracle has successfully been initialized by this call,
14     // or if oracle does not need to be initialized
15     function initializeOracle(address asset, address compareTo) external returns (bool);
16 
17     // Gets the value of the asset
18     // Oracle = the oracle address in specific. Optional parameter
19     // Inverted pair = whether or not this call represents an inversion of typical type (ERC20 underlying, USDC compareTo) to (USDC underlying, ERC20 compareTo)
20     // Must take inverse of value in this case to get REAL value
21     function getValueOfAsset(
22         address asset,
23         address compareTo,
24         bool risingEdge
25     )  external view returns (uint);
26 
27     // Does this oracle need to be updated prior to our reading the price?
28     // Return false if we are within desired time period
29     // Or if this type of oracle does not require updates
30     function oracleNeedsUpdates(address asset, address compareTo) external view returns (bool);
31 
32     // Does this oracle need to be poked prior to update and withdrawal?
33     function oracleNeedsPoking(address asset, address compareTo) external view returns (bool);
34 
35     function oracleNeedsInitialization(address asset, address compareTo) external view returns (bool);
36 
37     //Only ever called if oracle needs initialization
38     function canOracleBeCreatedForRoute(address asset, address compareTo) external view returns (bool);
39 
40     // How long to wait after poking the oracle before you can update it again and withdraw
41     function getTimePeriodAfterPoke(address asset, address compareTo) external view returns (uint);
42 
43     // Returns a direct reference to the address that the specific contract for this pair is registered at
44     function getOracleForPair(address asset, address compareTo) external view returns (address);
45 
46     // Returns a boolean if this oracle can provide data for the requested pair, used during FNFT creation
47     function getPairHasOracle(address asset, address compareTo) external view returns (bool);
48 
49     //Returns the instantaneous price of asset and the decimals for that price
50     function getInstantPrice(address asset, address compareTo) external view returns (uint);
51 }
