1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 interface IGuard {
5     event Guarded(string reason);
6 
7     function check() external view returns (bool);
8 
9     function getProtecActions()
10         external
11         view
12         returns (
13             address[] memory targets,
14             bytes[] memory datas,
15             uint256[] memory values
16         );
17 }
