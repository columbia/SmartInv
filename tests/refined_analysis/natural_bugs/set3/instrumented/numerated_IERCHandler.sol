1 // SPDX-License-Identifier: LGPL-3.0-only
2 pragma solidity 0.8.11;
3 
4 /**
5     @title Interface to be used with handlers that support ERC20s and ERC721s.
6     @author ChainSafe Systems.
7  */
8 interface IERCHandler {
9     /**
10         @notice Correlates {resourceID} with {contractAddress}.
11         @param resourceID ResourceID to be used when making deposits.
12         @param contractAddress Address of contract to be called when a deposit is made and a deposited is executed.
13      */
14     function setResource(bytes32 resourceID, address contractAddress) external;
15     /**
16         @notice Marks {contractAddress} as mintable/burnable.
17         @param contractAddress Address of contract to be used when making or executing deposits.
18      */
19     function setBurnable(address contractAddress) external;
20 
21     /**
22         @notice Withdraw funds from ERC safes.
23         @param data ABI-encoded withdrawal params relevant to the handler.
24      */
25     function withdraw(bytes memory data) external;
26 }
