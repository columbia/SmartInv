1 pragma solidity ^0.8.0;
2 
3 contract RevertReceiver {
4     fallback() external payable {
5         revert("RevertReceiver: cannot accept eth");
6     }
7 }
