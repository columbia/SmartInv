1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "../fei/minter/RateLimitedMinter.sol";
5 
6 contract MockRateLimitedMinter is RateLimitedMinter {
7     constructor(
8         address _core,
9         uint256 _feiLimitPerSecond,
10         uint256 _mintingBufferCap,
11         bool _doPartialMint
12     ) CoreRef(_core) RateLimitedMinter(_feiLimitPerSecond, _mintingBufferCap, _doPartialMint) {}
13 
14     function setDoPartialMint(bool _doPartialMint) public {
15         doPartialAction = _doPartialMint;
16     }
17 
18     function mint(address to, uint256 amount) public {
19         _mintFei(to, amount);
20     }
21 }
