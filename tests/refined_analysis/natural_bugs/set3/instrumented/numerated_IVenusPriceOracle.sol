1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.6.12;
3 
4 import "./IVToken.sol";
5 
6 
7 interface IVenusPriceOracle {
8     function getUnderlyingPrice(IVToken vToken) external view returns (uint);
9 }
