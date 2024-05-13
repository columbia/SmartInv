1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.19;
4 
5 import {DataTypes} from "../libraries/DataTypes.sol";
6 
7 /**
8  * @title IPirexEth
9  * @notice Interface for the PirexEth contract
10  * @dev This interface defines the methods for interacting with PirexEth.
11  * @author redactedcartel.finance
12  */
13 interface IPirexEth {
14     /**
15      * @notice Initiate redemption by burning pxETH in return for upxETH
16      * @dev This function allows the initiation of redemption by burning pxETH in exchange for upxETH.
17      * @param _assets                     uint256 The amount of assets to burn. If the caller is AutoPxEth, then apxETH; pxETH otherwise.
18      * @param _receiver                   address The address to receive upxETH.
19      * @param _shouldTriggerValidatorExit bool    Whether the initiation should trigger voluntary exit.
20      * @return postFeeAmount              uint256 The amount of pxETH burnt for the receiver.
21      * @return feeAmount                  uint256 The amount of pxETH distributed as fees.
22      */
23     function initiateRedemption(
24         uint256 _assets,
25         address _receiver,
26         bool _shouldTriggerValidatorExit
27     ) external returns (uint256 postFeeAmount, uint256 feeAmount);
28 
29     /**
30      * @notice Dissolve validator
31      * @dev This function dissolves a validator.
32      * @param _pubKey bytes The public key of the validator.
33      */
34     function dissolveValidator(bytes calldata _pubKey) external payable;
35 
36     /**
37      * @notice Update validator state to be slashed
38      * @dev This function updates the validator state to be slashed.
39      * @param _pubKey         bytes                     The public key of the validator.
40      * @param _removeIndex    uint256                   The index of the validator to be slashed.
41      * @param _amount         uint256                   The ETH amount released from the Beacon chain.
42      * @param _unordered      bool                      Whether to remove from the staking validator queue in order or not.
43      * @param _useBuffer      bool                      Whether to use a buffer to compensate for the loss.
44      * @param _burnerAccounts DataTypes.BurnerAccount[] Burner accounts.
45      */
46     function slashValidator(
47         bytes calldata _pubKey,
48         uint256 _removeIndex,
49         uint256 _amount,
50         bool _unordered,
51         bool _useBuffer,
52         DataTypes.BurnerAccount[] calldata _burnerAccounts
53     ) external payable;
54 
55     /**
56      * @notice Harvest and mint staking rewards when available
57      * @dev This function harvests and mints staking rewards when available.
58      * @param _endBlock uint256 The block until which ETH rewards are computed.
59      */
60     function harvest(uint256 _endBlock) external payable;
61 }
