1 
2 // SPDX-License-Identifier: GNU-GPL v3.0 or later
3 
4 pragma solidity >=0.8.0;
5 
6 import "./IOutputReceiverV2.sol";
7 
8 /**
9  * @title Provider interface for Revest FNFTs
10  */
11 interface IOutputReceiverV3 is IOutputReceiverV2 {
12 
13     event DepositERC20OutputReceiver(address indexed mintTo, address indexed token, uint amountTokens, uint indexed fnftId, bytes extraData);
14 
15     event DepositERC721OutputReceiver(address indexed mintTo, address indexed token, uint[] tokenIds, uint indexed fnftId, bytes extraData);
16 
17     event DepositERC1155OutputReceiver(address indexed mintTo, address indexed token, uint tokenId, uint amountTokens, uint indexed fnftId, bytes extraData);
18 
19     event WithdrawERC20OutputReceiver(address indexed caller, address indexed token, uint amountTokens, uint indexed fnftId, bytes extraData);
20 
21     event WithdrawERC721OutputReceiver(address indexed caller, address indexed token, uint[] tokenIds, uint indexed fnftId, bytes extraData);
22 
23     event WithdrawERC1155OutputReceiver(address indexed caller, address indexed token, uint tokenId, uint amountTokens, uint indexed fnftId, bytes extraData);
24 
25     function handleTimelockExtensions(uint fnftId, uint expiration, address caller) external;
26 
27     function handleAdditionalDeposit(uint fnftId, uint amountToDeposit, uint quantity, address caller) external;
28 
29     function handleSplitOperation(uint fnftId, uint[] memory proportions, uint quantity, address caller) external;
30 
31 }
