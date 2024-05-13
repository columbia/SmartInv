1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /// @title a Fei Timed Minter
6 /// @author Fei Protocol
7 interface IFeiTimedMinter {
8     // ----------- Events -----------
9 
10     event FeiMinting(address indexed caller, uint256 feiAmount);
11 
12     event TargetUpdate(address oldTarget, address newTarget);
13 
14     event MintAmountUpdate(uint256 oldMintAmount, uint256 newMintAmount);
15 
16     // ----------- State changing api -----------
17 
18     function mint() external;
19 
20     // ----------- Governor only state changing api -----------
21 
22     function setTarget(address newTarget) external;
23 
24     // ----------- Governor or Admin only state changing api -----------
25 
26     function setFrequency(uint256 newFrequency) external;
27 
28     function setMintAmount(uint256 newMintAmount) external;
29 
30     // ----------- Getters -----------
31 
32     function mintAmount() external view returns (uint256);
33 
34     function MIN_MINT_FREQUENCY() external view returns (uint256);
35 
36     function MAX_MINT_FREQUENCY() external view returns (uint256);
37 
38     function target() external view returns (address);
39 }
