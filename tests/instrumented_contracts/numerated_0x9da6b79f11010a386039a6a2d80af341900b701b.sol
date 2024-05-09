1 pragma solidity ^0.4.25;
2 
3 //This contract is for anyone that interacts with a p3d style contract that didn't publish their code on etherscan
4 
5 contract contractX 
6 {
7   function exit() public;
8 }
9 
10 contract EmergencyExit {
11   address unknownContractAddress;
12 
13   function callExitFromUnknownContract(address contractAddress) public 
14   {
15      contractX(contractAddress).exit();
16      address(msg.sender).transfer(address(this).balance);
17   }
18 }