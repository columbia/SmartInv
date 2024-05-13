1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.19;
3 
4 import {DataTypes} from "../libraries/DataTypes.sol";
5 
6 /**
7  * @title IRewardRecipient
8  * @notice Interface for managing rewards and penalties in the validator system.
9  * @dev This interface defines functions related to dissolving and slashing validators in the Pirex protocol.
10  * @author redactedcartel.finance
11  */
12 interface IRewardRecipient {
13     /**
14      * @notice Dissolves a validator and transfers the specified ETH amount.
15      * @dev This function is responsible for dissolving a validator and transferring the specified ETH amount.
16      * @param _pubKey bytes   The public key of the validator to be dissolved.
17      * @param _amount uint256 The amount of ETH to be transferred during the dissolution.
18      */
19     function dissolveValidator(
20         bytes calldata _pubKey,
21         uint256 _amount
22     ) external;
23 
24     /**
25      * @notice Slashes a validator for misconduct, optionally removing it in a gas-efficient way.
26      * @dev This function is responsible for slashing a validator, removing it from the system, and handling burner accounts.
27      * @param _pubKey         bytes                     The public key of the validator to be slashed.
28      * @param _removeIndex    uint256                   The index of the validator's public key to be removed.
29      * @param _amount         uint256                   The amount of ETH to be slashed from the validator.
30      * @param _unordered      bool                      Flag indicating whether the removal is done in a gas-efficient way.
31      * @param _burnerAccounts DataTypes.BurnerAccount[] Array of burner accounts associated with the slashed validator.
32      */
33     function slashValidator(
34         bytes calldata _pubKey,
35         uint256 _removeIndex,
36         uint256 _amount,
37         bool _unordered,
38         DataTypes.BurnerAccount[] calldata _burnerAccounts
39     ) external;
40 }
