1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 import "../../oracle/collateralization/ICollateralizationOracle.sol";
6 
7 /// @title a PCV Equity Minter Interface
8 /// @author Fei Protocol
9 interface IPCVEquityMinter {
10     // ----------- Events -----------
11 
12     event APRUpdate(uint256 oldAprBasisPoints, uint256 newAprBasisPoints);
13 
14     event CollateralizationOracleUpdate(address oldCollateralizationOracle, address newCollateralizationOracle);
15 
16     // ----------- Governor only state changing api -----------
17 
18     function setCollateralizationOracle(ICollateralizationOracle newCollateralizationOracle) external;
19 
20     // ----------- Governor or Admin only state changing api -----------
21 
22     function setAPRBasisPoints(uint256 newAprBasisPoints) external;
23 
24     // ----------- Getters -----------
25 
26     function MAX_APR_BASIS_POINTS() external view returns (uint256);
27 
28     function collateralizationOracle() external view returns (ICollateralizationOracle);
29 
30     function aprBasisPoints() external view returns (uint256);
31 }
