1 pragma solidity ^0.4.24;
2 
3 contract Ownable {
4     address public owner;
5 
6     constructor () public {
7         owner = 0xCfBbef59AC2620271d8C8163a294A04f0b31Ef3f;
8     }
9 
10      modifier onlyOwner() {
11     if (msg.sender != owner) {
12       revert();
13     }
14     _;
15 }
16 
17     function transferOwnership(address newOwner) onlyOwner public {
18         owner = newOwner;
19     }
20 }
21 
22 contract TokenERC20 {
23   function transfer(address _to, uint256 _value) public;
24 }
25 
26 contract SensusTokenSender is Ownable {
27 
28     function drop(TokenERC20 token, address[] to, uint256[] value) onlyOwner public {
29     for (uint256 i = 0; i < to.length; i++) {
30       token.transfer(to[i], value[i]);
31     }
32   }
33 }