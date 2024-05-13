1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.6;
3 
4 import "./interfaces/ICvx.sol";
5 
6 /// @notice Contains function to calc amount of CVX to mint from a given amount of CRV
7 library CvxMining {
8     ICvx public constant cvx = ICvx(0x4e3FBD56CD56c3e72c1403e103b45Db9da5B9D2B);
9 
10     /// @param _amount The amount of CRV to burn
11     /// @return The amount of CVX to mint
12     function ConvertCrvToCvx(uint256 _amount) internal view returns (uint256) {
13         uint256 supply = cvx.totalSupply();
14         uint256 reductionPerCliff = cvx.reductionPerCliff();
15         uint256 totalCliffs = cvx.totalCliffs();
16         uint256 maxSupply = cvx.maxSupply();
17 
18         uint256 cliff = supply / reductionPerCliff;
19         //mint if below total cliffs
20         if (cliff < totalCliffs) {
21             //for reduction% take inverse of current cliff
22             uint256 reduction = totalCliffs - cliff;
23             //reduce
24             _amount = (_amount * reduction) / totalCliffs;
25 
26             //supply cap check
27             uint256 amtTillMax = maxSupply - supply;
28             if (_amount > amtTillMax) {
29                 _amount = amtTillMax;
30             }
31 
32             //mint
33             return _amount;
34         }
35         return 0;
36     }
37 }