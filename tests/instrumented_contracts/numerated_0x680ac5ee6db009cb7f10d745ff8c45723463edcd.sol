1 pragma solidity ^0.5.1;
2 
3 interface ELFToken {
4   function burnTokens(uint256 _amount) external returns (bool);
5   function balanceOf(address who) external view returns (uint256);
6 }
7 
8 contract ELFBurner {
9     address public token = 0xbf2179859fc6D5BEE9Bf9158632Dc51678a4100e;
10     
11     function burn() public returns (bool) {
12         uint256 balance = ELFToken(token).balanceOf(address(this));
13         return ELFToken(token).burnTokens(balance);
14     }
15 }