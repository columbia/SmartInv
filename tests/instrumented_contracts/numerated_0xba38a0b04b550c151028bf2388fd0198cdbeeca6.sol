1 pragma solidity ^0.4.24;
2 
3 interface ERC20 {
4     function transferFrom(address _from, address _to, uint _value) external returns (bool success);
5 }
6 
7 contract Airdrop {
8     ERC20 token;
9     function airdrop(address tokenAddress, address[] addresses, uint256 amount) public {
10         token = ERC20(tokenAddress);
11         for(uint i = 0; i < addresses.length; i++) {
12             token.transferFrom(msg.sender, addresses[i], amount);
13         }
14     }
15 }