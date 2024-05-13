1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 interface ITeleportGateway {
5     /// @notice Initiate DAI transfer.
6     /// @param targetDomain Domain of destination chain.
7     /// @param receiver Receiver address.
8     /// @param amount The amount of DAI to transfer.
9     function initiateTeleport(
10         bytes32 targetDomain,
11         address receiver,
12         uint128 amount
13     ) external;
14 }
