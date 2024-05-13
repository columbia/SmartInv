1 // SPDX-License-Identifier: LGPL-3.0-only
2 pragma solidity 0.8.11;
3 
4 /**
5     @title Interface for handler that handles generic deposits and deposit executions.
6     @author ChainSafe Systems.
7  */
8 interface IGenericHandler {
9     /**
10         @notice Correlates {resourceID} with {contractAddress}, {depositFunctionSig}, and {executeFunctionSig}.
11         @param resourceID ResourceID to be used when making deposits.
12         @param contractAddress Address of contract to be called when a deposit is made and a deposited is executed.
13         @param depositFunctionSig Function signature of method to be called in {contractAddress} when a deposit is made.
14         @param depositFunctionDepositerOffset Depositer address position offset in the metadata, in bytes.
15         @param executeFunctionSig Function signature of method to be called in {contractAddress} when a deposit is executed.
16      */
17     function setResource(
18         bytes32 resourceID,
19         address contractAddress,
20         bytes4 depositFunctionSig,
21         uint depositFunctionDepositerOffset,
22         bytes4 executeFunctionSig) external;
23 }