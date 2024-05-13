1 // SPDX-License-Identifier: GNU-GPL v3.0 or later
2 
3 pragma solidity >=0.8.0;
4 
5 import "./IOutputReceiver.sol";
6 import "./IRevest.sol";
7 import '@openzeppelin/contracts/utils/introspection/IERC165.sol';
8 
9 
10 /**
11  * @title Provider interface for Revest FNFTs
12  */
13 interface IOutputReceiverV2 is IOutputReceiver {
14 
15     // Future proofing for secondary callbacks during withdrawal
16     // Could just use triggerOutputReceiverUpdate and call withdrawal function
17     // But deliberately using reentry is poor form and reminds me too much of OAuth 2.0 
18     function receiveSecondaryCallback(
19         uint fnftId,
20         address payable owner,
21         uint quantity,
22         IRevest.FNFTConfig memory config,
23         bytes memory args
24     ) external payable;
25 
26     // Allows for similar function to address lock, updating state while still locked
27     // Called by the user directly
28     function triggerOutputReceiverUpdate(
29         uint fnftId,
30         bytes memory args
31     ) external;
32 
33     // This function should only ever be called when a split or additional deposit has occurred 
34     function handleFNFTRemaps(uint fnftId, uint[] memory newFNFTIds, address caller, bool cleanup) external;
35 
36     // This function provides more info about the additional deposit made
37     function handleAdditionalDeposit(uint fnftId, uint amountToDeposit, address depositCaller) external;
38 
39 }
