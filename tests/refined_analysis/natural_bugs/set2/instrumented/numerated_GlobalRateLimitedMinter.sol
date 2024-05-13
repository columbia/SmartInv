1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import {MultiRateLimited} from "./MultiRateLimited.sol";
5 import {IGlobalRateLimitedMinter} from "./IGlobalRateLimitedMinter.sol";
6 import {CoreRef} from "./../refs/CoreRef.sol";
7 import {Math} from "@openzeppelin/contracts/utils/math/Math.sol";
8 
9 /// @notice global contract to handle rate limited minting of Fei on a global level
10 /// allows whitelisted minters to call in and specify the address to mint Fei to within
11 /// that contract's limits
12 contract GlobalRateLimitedMinter is MultiRateLimited, IGlobalRateLimitedMinter {
13     /// @param coreAddress address of the core contract
14     /// @param _globalMaxRateLimitPerSecond maximum amount of Fei that can replenish per second ever, this amount cannot be changed by governance
15     /// @param _perAddressRateLimitMaximum maximum rate limit per second per address
16     /// @param _maxRateLimitPerSecondPerAddress maximum rate limit per second per address in multi rate limited
17     /// @param _maxBufferCap maximum buffer cap in multi rate limited contract
18     /// @param _globalBufferCap maximum global buffer cap
19     constructor(
20         address coreAddress,
21         uint256 _globalMaxRateLimitPerSecond,
22         uint256 _perAddressRateLimitMaximum,
23         uint256 _maxRateLimitPerSecondPerAddress,
24         uint256 _maxBufferCap,
25         uint256 _globalBufferCap
26     )
27         CoreRef(coreAddress)
28         MultiRateLimited(
29             _globalMaxRateLimitPerSecond,
30             _perAddressRateLimitMaximum,
31             _maxRateLimitPerSecondPerAddress,
32             _maxBufferCap,
33             _globalBufferCap
34         )
35     {}
36 
37     /// @notice mint Fei to the target address and deplete the buffer
38     /// pausable and depletes the msg.sender's buffer
39     /// @param to the recipient address of the minted Fei
40     /// @param amount the amount of Fei to mint
41     function mint(address to, uint256 amount) external virtual override whenNotPaused {
42         _depleteIndividualBuffer(msg.sender, amount);
43         _mintFei(to, amount);
44     }
45 
46     /// @notice mint Fei to the target address and deplete the whole rate limited
47     ///  minter's buffer, pausable and completely depletes the msg.sender's buffer
48     /// @param to the recipient address of the minted Fei
49     /// mints all Fei that msg.sender has in the buffer
50     function mintMaxAllowableFei(address to) external virtual override whenNotPaused {
51         uint256 amount = Math.min(individualBuffer(msg.sender), buffer());
52 
53         _depleteIndividualBuffer(msg.sender, amount);
54         _mintFei(to, amount);
55     }
56 }
