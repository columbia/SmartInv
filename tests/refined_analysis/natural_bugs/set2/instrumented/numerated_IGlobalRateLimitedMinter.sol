1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "./IMultiRateLimited.sol";
5 
6 /// @notice global contract to handle rate limited minting of Fei on a global level
7 /// allows whitelisted minters to call in and specify the address to mint Fei to within
8 /// the calling contract's limits
9 interface IGlobalRateLimitedMinter is IMultiRateLimited {
10     /// @notice function that all Fei minters call to mint Fei
11     /// pausable and depletes the msg.sender's buffer
12     /// @param to the recipient address of the minted Fei
13     /// @param amount the amount of Fei to mint
14     function mint(address to, uint256 amount) external;
15 
16     /// @notice mint Fei to the target address and deplete the whole rate limited
17     ///  minter's buffer, pausable and completely depletes the msg.sender's buffer
18     /// @param to the recipient address of the minted Fei
19     /// mints all Fei that msg.sender has in the buffer
20     function mintMaxAllowableFei(address to) external;
21 }
