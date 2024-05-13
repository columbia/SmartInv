1 // SPDX-License-Identifier: BUSL-1.1
2 pragma solidity ^0.8.0;
3 
4 import "@openzeppelin/contracts/access/Ownable.sol";
5 
6 /// @title Manage permissions of contracts
7 contract Roles is Ownable {
8     mapping(address => mapping(uint256 => bool)) public roles;
9     mapping(uint256 => address) public mainCharacters;
10 
11     constructor() Ownable() {
12         // token activation from the get-go
13         roles[msg.sender][9] = true;
14     }
15 
16     function giveRole(uint256 role, address actor) external onlyOwner {
17         roles[actor][role] = true;
18     }
19 
20     function removeRole(uint256 role, address actor) external onlyOwner {
21         roles[actor][role] = false;
22     }
23 
24     function setMainCharacter(uint256 role, address actor) external onlyOwner {
25         mainCharacters[role] = actor;
26     }
27 
28     function getRole(uint256 role, address contr) external view returns (bool) {
29         return roles[contr][role];
30     }
31 }
