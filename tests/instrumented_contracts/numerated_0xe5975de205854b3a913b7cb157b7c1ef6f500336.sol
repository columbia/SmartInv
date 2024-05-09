1 pragma solidity ^0.4.13;
2 
3 contract token { 
4     function transfer(address _to, uint256 _value);
5     function balanceOf(address _owner) constant returns (uint256 balance);
6 }
7 
8 contract stopScamHolder {
9     
10     token public sharesTokenAddress;
11     address public owner;
12     uint public endTime = 1510664400;////10 symbols
13     uint256 public tokenFree;
14 
15 modifier onlyOwner() {
16     require(msg.sender == owner);
17     _;
18 }
19 
20 function stopScamHolder(address _tokenAddress) {
21     sharesTokenAddress = token(_tokenAddress);
22     owner = msg.sender;
23 }
24 
25 function tokensBack() onlyOwner public {
26     if(now > endTime){
27         sharesTokenAddress.transfer(owner, sharesTokenAddress.balanceOf(this));
28     }
29     tokenFree = sharesTokenAddress.balanceOf(this);
30 }	
31 
32 }