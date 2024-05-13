1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.0;
3 
4 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
5 
6 // Interface for Balancer's MerkleOrchard
7 interface IMerkleOrchard {
8     struct Claim {
9         uint256 distributionId;
10         uint256 balance;
11         address distributor;
12         uint256 tokenIndex;
13         bytes32[] merkleProof;
14     }
15 
16     function claimDistributions(
17         address claimer,
18         Claim[] memory claims,
19         IERC20[] memory tokens
20     ) external;
21 }
