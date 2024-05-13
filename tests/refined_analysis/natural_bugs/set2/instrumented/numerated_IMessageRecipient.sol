1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 pragma solidity >=0.6.11;
3 
4 interface IMessageRecipient {
5     function handle(
6         uint32 _origin,
7         uint32 _nonce,
8         bytes32 _sender,
9         bytes memory _message
10     ) external;
11 }
