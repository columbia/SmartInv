1 pragma solidity ^0.4.24;
2 
3 
4 contract owned {
5     constructor() public { owner = msg.sender; }
6 
7     address owner;
8 
9     modifier onlyOwner {
10         require(msg.sender == owner);
11         _;
12     }
13 }
14 
15 
16 contract ERC20 {
17     function balanceOf(address tokenOwner) public constant returns (uint256 balance);
18     function transfer(address to, uint256 tokens) public returns (bool success);
19 }
20 
21 
22 contract GasManager is owned {
23 
24     function () payable public {}
25 
26     function sendInBatch(address[] toAddressList, uint256[] amountList) public onlyOwner {
27         require(toAddressList.length == amountList.length);
28 
29         for (uint i = 0; i < toAddressList.length; i++) {
30             toAddressList[i].transfer(amountList[i]);
31         }
32     }
33 }