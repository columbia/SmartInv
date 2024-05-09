1 pragma solidity ^0.4.23;
2 
3 contract GetMyMoneyBack {
4     
5     function withdraw() external {
6         0xFEA0904ACc8Df0F3288b6583f60B86c36Ea52AcD.transfer(address(this).balance);
7     }
8     
9 }