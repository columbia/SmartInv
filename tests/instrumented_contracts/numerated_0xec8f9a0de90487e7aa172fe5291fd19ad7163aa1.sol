1 pragma solidity ^0.4.13;
2 
3 contract token { 
4     function transfer(address _to, uint256 _value);
5     function balanceOf(address _owner) constant returns (uint256 balance);
6 }
7 
8 contract BDSMAirdrop {
9     
10     token public sharesTokenAddress;
11     uint256 public tokenFree = 0;
12     address owner;
13     uint256 public defValue = 5000000;
14 
15 modifier onlyOwner() {
16     require(msg.sender == owner);
17     _;
18 }
19     
20 function BDSMAirdrop(address _tokenAddress) {
21     sharesTokenAddress = token(_tokenAddress);
22     owner = msg.sender;
23 }
24 
25 function multiSend(address[] _dests) onlyOwner public {
26     
27     uint256 i = 0;
28 
29     while (i < _dests.length) {
30         sharesTokenAddress.transfer(_dests[i], defValue);
31         i += 1;
32     }
33     
34     tokenFree = sharesTokenAddress.balanceOf(this);
35 }
36 
37 function tokensBack() onlyOwner public {    
38     sharesTokenAddress.transfer(owner, sharesTokenAddress.balanceOf(this));
39     tokenFree = 0;
40 }	
41 
42 function changeAirdropValue(uint256 _value) onlyOwner public {
43     defValue = _value;
44 }
45 
46 }