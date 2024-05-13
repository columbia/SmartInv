1 // SPDX-License-Identifier: GPL-2.0-or-later
2 pragma solidity 0.8.10;
3 
4 /******************************************************************************\
5 * Author: Evert Kors <dev@sherlock.xyz> (https://twitter.com/evert0x)
6 * Sherlock Protocol: https://sherlock.xyz
7 /******************************************************************************/
8 
9 import '@openzeppelin/contracts/token/ERC721/IERC721.sol';
10 import './ISherlockStake.sol';
11 import './ISherlockGov.sol';
12 import './ISherlockPayout.sol';
13 import './ISherlockStrategy.sol';
14 
15 interface ISherlock is ISherlockStake, ISherlockGov, ISherlockPayout, ISherlockStrategy, IERC721 {
16   // msg.sender is not authorized to call this function
17   error Unauthorized();
18 
19   // An address or other value passed in is equal to zero (and shouldn't be)
20   error ZeroArgument();
21 
22   // Occurs when a value already holds the desired property, or is not whitelisted
23   error InvalidArgument();
24 
25   // Required conditions are not true/met
26   error InvalidConditions();
27 
28   // If the SHER tokens held in a contract are not the value they are supposed to be
29   error InvalidSherAmount(uint256 expected, uint256 actual);
30 
31   // Checks the ERC-721 functions _exists() to see if an NFT ID actually exists and errors if not
32   error NonExistent();
33 
34   event ArbRestaked(uint256 indexed tokenID, uint256 reward);
35 
36   event Restaked(uint256 indexed tokenID);
37 }
