1 pragma solidity ^0.8.4;
2 
3 interface IPriceBound {
4     // ----------- Events -----------
5 
6     /// @notice event emitted when minimum floor price is updated
7     event OracleFloorUpdate(uint256 oldFloor, uint256 newFloor);
8 
9     /// @notice event emitted when maximum ceiling price is updated
10     event OracleCeilingUpdate(uint256 oldCeiling, uint256 newCeiling);
11 
12     // ----------- Governor or admin only state changing api -----------
13 
14     /// @notice sets the floor price in BP
15     function setOracleFloorBasisPoints(uint256 newFloor) external;
16 
17     /// @notice sets the ceiling price in BP
18     function setOracleCeilingBasisPoints(uint256 newCeiling) external;
19 
20     // ----------- Getters -----------
21 
22     /// @notice get the floor price in basis points
23     function floor() external view returns (uint256);
24 
25     /// @notice get the ceiling price in basis points
26     function ceiling() external view returns (uint256);
27 
28     /// @notice return wether the current oracle price is valid or not
29     function isPriceValid() external view returns (bool);
30 }
