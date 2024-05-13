1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 interface ICircleBridgeProxy {
5     /// @notice Deposits and burns tokens from sender to be minted on destination domain.
6     /// @dev reverts if:
7     ///      - given burnToken is not supported.
8     ///      - given destinationDomain has no TokenMessenger registered.
9     ///      - transferFrom() reverts. For example, if sender's burnToken balance
10     ///        or approved allowance to this contract is less than `amount`.
11     ///      - burn() reverts. For example, if `amount` is 0.
12     ///      - MessageTransmitter returns false or reverts.
13     /// @param _amount Amount of tokens to burn.
14     /// @param _dstChid Destination domain.
15     /// @param _mintRecipient Address of mint recipient on destination domain.
16     /// @param _burnToken Address of contract to burn deposited tokens, on local domain.
17     /// @return nonce Unique nonce reserved by message.
18     function depositForBurn(
19         uint256 _amount,
20         uint64 _dstChid,
21         bytes32 _mintRecipient,
22         address _burnToken
23     ) external returns (uint64 nonce);
24 }
