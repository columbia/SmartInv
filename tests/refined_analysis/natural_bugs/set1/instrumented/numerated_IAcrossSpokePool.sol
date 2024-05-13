1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 interface IAcrossSpokePool {
5     function deposit(
6         address recipient, // Recipient address
7         address originToken, // Address of the token
8         uint256 amount, // Token amount
9         uint256 destinationChainId, // ⛓ id
10         int64 relayerFeePct, // see #Fees Calculation
11         uint32 quoteTimestamp, // Timestamp for the quote creation
12         bytes memory message, // Arbitrary data that can be used to pass additional information to the recipient along with the tokens.
13         uint256 maxCount // Used to protect the depositor from frontrunning to guarantee their quote remains valid.
14     ) external payable;
15 }
