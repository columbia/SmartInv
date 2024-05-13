1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 /// @title interface for putting a rate limit on how fast a contract can perform an action, e.g. Minting
5 /// @author Fei Protocol
6 interface IMultiRateLimited {
7     // ----------- Events -----------
8 
9     /// @notice emitted when a buffer is eaten into
10     event IndividualBufferUsed(address rateLimitedAddress, uint256 amountUsed, uint256 bufferRemaining);
11 
12     /// @notice emitted when rate limit is updated
13     event IndividualRateLimitPerSecondUpdate(
14         address rateLimitedAddress,
15         uint256 oldRateLimitPerSecond,
16         uint256 newRateLimitPerSecond
17     );
18 
19     /// @notice emitted when the non gov buffer cap max is updated
20     event MultiBufferCapUpdate(uint256 oldBufferCap, uint256 newBufferCap);
21 
22     /// @notice emitted when the non gov buffer rate limit per second max is updated
23     event MultiMaxRateLimitPerSecondUpdate(uint256 oldMaxRateLimitPerSecond, uint256 newMaxRateLimitPerSecond);
24 
25     // ----------- View API -----------
26 
27     /// @notice the rate per second for each address
28     function getRateLimitPerSecond(address) external view returns (uint256);
29 
30     /// @notice the last time the buffer was used by each address
31     function getLastBufferUsedTime(address) external view returns (uint256);
32 
33     /// @notice the cap of the buffer that can be used at once
34     function getBufferCap(address) external view returns (uint256);
35 
36     /// @notice the amount of action that can be used before hitting limit
37     /// @dev replenishes at rateLimitPerSecond per second up to bufferCap
38     function individualBuffer(address) external view returns (uint112);
39 
40     // ----------- Governance State Changing API -----------
41 
42     /// @notice update the non gov max rate limit per second
43     function updateMaxRateLimitPerSecond(uint256 newMaxRateLimitPerSecond) external;
44 
45     /// @notice update the non gov max buffer cap
46     function updateMaxBufferCap(uint256 newBufferCap) external;
47 
48     /// @notice add an authorized contract, its per second replenishment and buffer set to the non governor caps
49     function addAddressAsMinter(address) external;
50 
51     /// @notice add an authorized contract, its per second replenishment and buffer
52     function addAddress(
53         address,
54         uint112,
55         uint112
56     ) external;
57 
58     /// @notice update an authorized contract
59     function updateAddress(
60         address,
61         uint112,
62         uint112
63     ) external;
64 
65     /// @notice remove an authorized contract
66     function removeAddress(address) external;
67 }
