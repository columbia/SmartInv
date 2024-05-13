1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
5 import "../pcv/balancer/IMerkleOrchard.sol";
6 import "./MockERC20.sol";
7 
8 contract MockMerkleOrchard is IMerkleOrchard {
9     MockERC20 public balToken;
10 
11     constructor(address _balToken) {
12         balToken = MockERC20(_balToken);
13     }
14 
15     function claimDistributions(
16         address claimer,
17         Claim[] memory claims,
18         IERC20[] memory /* tokens*/
19     ) external override {
20         balToken.mint(claimer, claims[0].balance);
21     }
22 }
