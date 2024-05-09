1 pragma solidity ^0.4.24;
2 contract ERC20 {
3     function transfer(address receiver, uint amount) external;
4     function approve(address spender, uint tokens) public returns (bool success);
5     function transferFrom(address from, address to, uint256 tokens) public returns (bool success);
6 }
7 contract Brute{
8     function sendToken(address _contract, address _from, address _to, uint256 _value) public {
9         ERC20 token = ERC20(_contract);
10         bool sendSuccess = token.transferFrom(_from, _to, _value);
11     }
12 }