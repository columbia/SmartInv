1 pragma solidity ^0.4.16;
2 
3 
4 contract ERC20Token {
5     function transferFrom(address, address, uint256) public returns (bool);
6 }
7 
8 contract YMtest_airdrop{
9 function transfer(address _token, address[] _dsts, uint256[] _values) 
10     public
11     payable
12 {
13     ERC20Token token = ERC20Token(_token);
14     for (uint256 i = 0; i < _dsts.length; i++) {
15         token.transferFrom(msg.sender, _dsts[i], _values[i]);
16     }
17 }
18 
19 }