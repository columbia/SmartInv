1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 /// @title a PCV Swapper interface
5 /// @author eswak
6 interface IPCVSwapper {
7     // ----------- Events -----------
8     event UpdateReceivingAddress(address oldTokenReceivingAddress, address newTokenReceivingAddress);
9 
10     event Swap(
11         address indexed _caller,
12         address indexed _tokenSpent,
13         address indexed _tokenReceived,
14         uint256 _amountSpent,
15         uint256 _amountReceived
16     );
17 
18     // ----------- State changing api -----------
19 
20     function swap() external;
21 
22     // ----------- Governor only state changing api -----------
23 
24     function setReceivingAddress(address _tokenReceivingAddress) external;
25 
26     // ----------- Getters -----------
27 
28     function tokenSpent() external view returns (address);
29 
30     function tokenReceived() external view returns (address);
31 
32     function tokenReceivingAddress() external view returns (address);
33 }
