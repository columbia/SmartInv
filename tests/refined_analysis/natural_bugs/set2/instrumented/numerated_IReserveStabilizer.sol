1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 /// @title a Reserve Stabilizer interface
5 /// @author Fei Protocol
6 interface IReserveStabilizer {
7     // ----------- Events -----------
8     event FeiExchange(address indexed to, uint256 feiAmountIn, uint256 amountOut);
9 
10     event UsdPerFeiRateUpdate(uint256 oldUsdPerFeiBasisPoints, uint256 newUsdPerFeiBasisPoints);
11 
12     // ----------- State changing api -----------
13 
14     function exchangeFei(uint256 feiAmount) external returns (uint256);
15 
16     // ----------- Governor only state changing api -----------
17 
18     function setUsdPerFeiRate(uint256 exchangeRateBasisPoints) external;
19 
20     // ----------- Getters -----------
21 
22     function usdPerFeiBasisPoints() external view returns (uint256);
23 
24     function getAmountOut(uint256 amountIn) external view returns (uint256);
25 }
