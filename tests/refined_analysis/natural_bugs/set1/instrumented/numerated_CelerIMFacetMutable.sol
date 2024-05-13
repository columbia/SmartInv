1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 import { CelerIMFacetBase, IMessageBus, MsgDataTypes, IERC20, CelerIM } from "../Helpers/CelerIMFacetBase.sol";
5 
6 /// @title CelerIMFacetMutable
7 /// @author LI.FI (https://li.fi)
8 /// @notice Provides functionality for bridging tokens and data through CBridge
9 /// @notice This contract is exclusively used for mutable diamond contracts
10 /// @custom:version 2.0.0
11 contract CelerIMFacetMutable is CelerIMFacetBase {
12     /// Constructor ///
13 
14     /// @notice Initialize the contract.
15     /// @param _messageBus The contract address of the cBridge Message Bus
16     /// @param _relayerOwner The address that will become the owner of the RelayerCelerIM contract
17     /// @param _diamondAddress The address of the diamond contract that will be connected with the RelayerCelerIM
18     /// @param _cfUSDC The contract address of the Celer Flow USDC
19     constructor(
20         IMessageBus _messageBus,
21         address _relayerOwner,
22         address _diamondAddress,
23         address _cfUSDC
24     ) CelerIMFacetBase(_messageBus, _relayerOwner, _diamondAddress, _cfUSDC) {}
25 }
