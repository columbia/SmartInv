1 //SPDX-License-Identifier: MIT
2 pragma solidity 0.7.5;
3 
4 // Inheritance
5 import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
6 
7 /// @title   Umbrella Airdrop contract
8 /// @author  umb.network
9 /// @notice  This contract provides Airdrop capability.
10 abstract contract Airdrop is ERC20 {
11     function airdropTokens(
12         address[] calldata _addresses,
13         uint256[] calldata _amounts
14     ) external {
15         require(_addresses.length != 0, "there are no _addresses");
16         require(_addresses.length == _amounts.length, "the number of _addresses should match _amounts");
17 
18         for(uint i = 0; i < _addresses.length; i++) {
19             transfer(_addresses[i], _amounts[i]);
20         }
21     }
22 }
