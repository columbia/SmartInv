1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "../../utils/RateLimited.sol";
5 
6 /// @title abstract contract for putting a rate limit on how fast a contract can mint FEI
7 /// @author Fei Protocol
8 abstract contract RateLimitedMinter is RateLimited {
9     uint256 private constant MAX_FEI_LIMIT_PER_SECOND = 10_000e18; // 10000 FEI/s or ~860m FEI/day
10 
11     constructor(
12         uint256 _feiLimitPerSecond,
13         uint256 _mintingBufferCap,
14         bool _doPartialMint
15     ) RateLimited(MAX_FEI_LIMIT_PER_SECOND, _feiLimitPerSecond, _mintingBufferCap, _doPartialMint) {}
16 
17     /// @notice override the FEI minting behavior to enforce a rate limit
18     function _mintFei(address to, uint256 amount) internal virtual override {
19         uint256 mintAmount = _depleteBuffer(amount);
20         super._mintFei(to, mintAmount);
21     }
22 }
