1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
5 import "../fei/IFei.sol";
6 
7 interface ITribe is IERC20 {
8     function delegate(address delegatee) external;
9 }
10 
11 /// @title TimelockedDelegator interface
12 /// @author Fei Protocol
13 interface ITimelockedDelegator {
14     // ----------- Events -----------
15 
16     event Delegate(address indexed _delegatee, uint256 _amount);
17 
18     event Undelegate(address indexed _delegatee, uint256 _amount);
19 
20     // ----------- Beneficiary only state changing api -----------
21 
22     function delegate(address delegatee, uint256 amount) external;
23 
24     function undelegate(address delegatee) external returns (uint256);
25 
26     // ----------- Getters -----------
27 
28     function delegateContract(address delegatee) external view returns (address);
29 
30     function delegateAmount(address delegatee) external view returns (uint256);
31 
32     function totalDelegated() external view returns (uint256);
33 
34     function tribe() external view returns (ITribe);
35 }
