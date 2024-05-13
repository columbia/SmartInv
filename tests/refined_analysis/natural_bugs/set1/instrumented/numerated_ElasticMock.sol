1 //SPDX-License-Identifier: GPL-3.0
2 pragma solidity 0.8.4;
3 
4 import "@openzeppelin/contracts/token/ERC20/presets/ERC20PresetFixedSupply.sol";
5 import "@openzeppelin/contracts/access/Ownable.sol";
6 
7 /**
8 @notice DO NOT USE IN PRODUCTION. FOR TEST PURPOSES ONLY
9  */
10 contract ElasticMock is ERC20PresetFixedSupply, Ownable {
11 
12     constructor(
13         string memory name,
14         string memory symbol,
15         uint256 initialSupply,
16         address owner
17     ) ERC20PresetFixedSupply(name, symbol, initialSupply, owner) {}
18 
19     /**
20     @dev Allows us to transfer away tokens from an address in our tests simulating a rebase down occurring
21     */
22     function simulateRebaseDown(
23         address tokenHolder,
24         uint256 tokenAmountToRemove
25     ) external onlyOwner() {
26         _transfer(tokenHolder, address(this), tokenAmountToRemove);
27     }
28 }
