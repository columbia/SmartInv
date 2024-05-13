1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
5 
6 interface ITribe is IERC20 {
7     function mint(address to, uint256 amount) external;
8 
9     function setMinter(address newMinter) external;
10 }
11 
12 /// @title TribeMinter interface
13 /// @author Fei Protocol
14 interface ITribeMinter {
15     // ----------- Events -----------
16     event AnnualMaxInflationUpdate(uint256 oldAnnualMaxInflationBasisPoints, uint256 newAnnualMaxInflationBasisPoints);
17     event TribeTreasuryUpdate(address indexed oldTribeTreasury, address indexed newTribeTreasury);
18     event TribeRewardsDripperUpdate(address indexed oldTribeRewardsDripper, address indexed newTribeRewardsDripper);
19 
20     // ----------- Public state changing api -----------
21 
22     function poke() external;
23 
24     // ----------- Owner only state changing api -----------
25 
26     function setMinter(address newMinter) external;
27 
28     // ----------- Governor or Admin only state changing api -----------
29 
30     function mint(address to, uint256 amount) external;
31 
32     function setTribeTreasury(address newTribeTreasury) external;
33 
34     function setTribeRewardsDripper(address newTribeRewardsDripper) external;
35 
36     function setAnnualMaxInflationBasisPoints(uint256 newAnnualMaxInflationBasisPoints) external;
37 
38     // ----------- Getters -----------
39 
40     function annualMaxInflationBasisPoints() external view returns (uint256);
41 
42     function idealBufferCap() external view returns (uint256);
43 
44     function tribeCirculatingSupply() external view returns (uint256);
45 
46     function totalSupply() external view returns (uint256);
47 
48     function isPokeNeeded() external view returns (bool);
49 
50     function tribeTreasury() external view returns (address);
51 
52     function tribeRewardsDripper() external view returns (address);
53 }
