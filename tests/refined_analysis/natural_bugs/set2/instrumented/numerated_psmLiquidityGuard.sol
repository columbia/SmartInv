1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "../IGuard.sol";
5 
6 contract PSMLiquidityGuard is IGuard {
7     // Hardcoded addresses to check
8     // Or address to use as lens to look up what to check
9 
10     function check() external pure override returns (bool) {
11         // logic here to determine if the any of the fuse pool oracles are illiquid
12         // we could check just one fuse pool, or many
13     }
14 
15     function getProtecActions()
16         external
17         pure
18         override
19         returns (
20             address[] memory targets,
21             bytes[] memory datas,
22             uint256[] memory values
23         )
24     {
25         // Grab
26         // logic here to compute and output the actions to take
27         // this could involve pausing a single pool
28         // this could involve rugging everything
29         // whatever we want to do
30         // eg fusePoolAdmin.disableBorrowing(Pool19);
31     }
32 }
