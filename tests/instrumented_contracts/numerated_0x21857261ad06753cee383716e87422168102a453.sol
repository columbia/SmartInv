1 pragma solidity ^0.4.24;
2 
3 contract Doubler{
4     uint public price = 1 wei;
5     address public winner = msg.sender;
6     
7     function() public payable {
8         require(msg.value >= price); 
9         if (msg.value > price){
10             msg.sender.transfer(msg.value - price);
11         }
12         if (!winner.send(price)){
13             msg.sender.transfer(price);
14         }
15         winner = msg.sender;
16         price = price * 2;
17     }
18     
19     
20 }