1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
6 import "@openzeppelin/contracts/access/Ownable.sol";
7 
8 contract BGLDToken is ERC20("BAG Gold", "BGLD"), Ownable {
9   function mint(address _to, uint256 _amount) public onlyOwner {
10         _mint(_to, _amount);
11     }
12 }