1 pragma solidity ^0.4.16;
2 
3 contract ERC20 {
4     function balanceOf(address tokenOwner) public constant returns (uint256 balance);
5     function transfer(address to, uint256 tokens) public returns (bool success);
6 }
7 
8 contract owned {
9     function owned() public { owner = msg.sender; }
10     address owner;
11 
12     modifier onlyOwner {
13         require(msg.sender == owner);
14         _;
15     }
16 }
17 
18 contract airdropManager is owned {
19 
20     function send(address tokenAddress, address[] addressList, uint256[] amountList) public onlyOwner {
21         require(addressList.length == amountList.length);
22         for (uint i = 0; i < addressList.length; i++) {
23             ERC20(tokenAddress).transfer(addressList[i], amountList[i] * 1e18);
24         }
25     }
26 }