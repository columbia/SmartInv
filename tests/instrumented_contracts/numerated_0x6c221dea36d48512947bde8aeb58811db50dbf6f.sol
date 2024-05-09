1 pragma solidity ^0.4.23;
2 
3 contract PartnerContract
4 {
5     function() external payable
6     {
7         if(msg.value == 0)
8         {
9             uint part = address(this).balance / 2;
10             address(0x6B6e4B338b4D5f7D847DaB5492106751C57b7Ff0).transfer(part);
11             address(0xe09f3630663B6b86e82D750b00206f8F8C6F8aD4).transfer(part);
12         }
13     }
14 }