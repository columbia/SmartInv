1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.4.24 <0.6.0;

3 contract revest {
        
4         uint newFNFTId_previous;
5         uint fnftId_previous; 
       
6         newFNFTId_previous = newFNFTId; 
7         fnftId_previous = fnftId; 
8         function handleMultipleDeposits(
9                 uint fnftId,
10                 uint newFNFTId,
11                 uint amount
12                 ) external override onlyRevestController {
13                 require(amount >= fnfts[fnftId].depositAmount, 'E003');
14                 IRevest.FNFTConfig memory config = fnfts[fnftId];
15                 config.depositAmount = amount;
16                 if(newFNFTId != 0) {
17                     mapFNFTToToken(newFNFTId, config);
18                 }
19              }
20  }