1 pragma solidity ^0.5.16;
2 
3 import "../CToken.sol";
4 
5 contract PriceOracle {
6     /// @notice Indicator that this is a PriceOracle contract (for inspection)
7     bool public constant isPriceOracle = true;
8 
9     /**
10      * @notice Get the underlying price of a cToken asset
11      * @param cToken The cToken to get the underlying price of
12      * @return The underlying asset price mantissa (scaled by 1e18).
13      *  Zero means the price is unavailable.
14      */
15     function getUnderlyingPrice(CToken cToken) external view returns (uint256);
16 }
