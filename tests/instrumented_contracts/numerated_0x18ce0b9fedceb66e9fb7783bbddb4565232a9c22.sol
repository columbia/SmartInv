1 pragma solidity ^0.4.11;
2 
3 
4 contract ERC20 {
5     function transfer(address _to, uint _value) returns (bool success);
6     function transferFrom(address _from, address _to, uint _value) returns (bool success);
7 }
8 
9 contract TimeBankToken {
10 
11     struct tokenDeposit{
12     uint256 timeToWithdraw;
13     uint256 numTokens;
14     }
15 
16     mapping (address => mapping(address => tokenDeposit)) tokenBalances;
17 
18     function getInfo(address _tokenAddress, address _holder) constant returns(uint, uint, uint){
19         return(tokenBalances[_tokenAddress][_holder].timeToWithdraw,tokenBalances[_tokenAddress][_holder].numTokens, block.timestamp);
20     }
21 
22     function depositTokens(ERC20 _token, uint256 _time, uint256 _amount) returns (bool){
23         require(_amount > 0 && _time > block.timestamp && _time < block.timestamp + 157680000);
24 
25         if (!(tokenBalances[_token][msg.sender].timeToWithdraw > 0)) tokenBalances[_token][msg.sender].timeToWithdraw = _time;
26 
27         tokenBalances[_token][msg.sender].numTokens += _amount;
28 
29         require(_token.transferFrom(msg.sender, this, _amount));
30 
31         return true;
32     }
33 
34     function withdrawTokens(ERC20 _token) returns (bool){
35 
36         uint tokens = tokenBalances[_token][msg.sender].numTokens;
37         tokenBalances[_token][msg.sender].numTokens = 0;
38 
39         require(tokenBalances[_token][msg.sender].timeToWithdraw < block.timestamp && tokens > 0);
40 
41         tokenBalances[_token][msg.sender].timeToWithdraw = 0;
42 
43         require(_token.transfer(msg.sender, tokens));
44 
45         return true;
46     }
47 }