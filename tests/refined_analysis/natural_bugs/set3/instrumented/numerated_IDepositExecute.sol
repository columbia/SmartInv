1 // SPDX-License-Identifier: LGPL-3.0-only
2 pragma solidity 0.8.11;
3 
4 /**
5     @title Interface for handler contracts that support deposits and deposit executions.
6     @author ChainSafe Systems.
7  */
8 interface IDepositExecute {
9     /**
10         @notice It is intended that deposit are made using the Bridge contract.
11         @param depositer Address of account making the deposit in the Bridge contract.
12         @param data Consists of additional data needed for a specific deposit.
13      */
14     function deposit(bytes32 resourceID, address depositer, bytes calldata data) external returns (bytes memory);
15 
16     /**
17         @notice It is intended that proposals are executed by the Bridge contract.
18         @param data Consists of additional data needed for a specific deposit execution.
19      */
20     function executeProposal(bytes32 resourceID, bytes calldata data) external;
21 }
