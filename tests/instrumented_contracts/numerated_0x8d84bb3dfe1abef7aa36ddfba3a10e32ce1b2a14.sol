1 pragma solidity ^0.4.0;
2 contract OWN_ME {
3     address public owner = msg.sender;
4     uint256 public price = 1 finney;
5     
6     modifier onlyOwner() {
7         require(msg.sender == owner);
8         _;
9     }
10     
11     function change_price(uint256 newprice) onlyOwner public {
12         price = newprice;
13     }
14    
15     function BUY_ME() public payable {
16         require(msg.value >= price);
17         address tmp = owner;
18         owner = msg.sender;
19         tmp.transfer(msg.value);
20     }
21 }