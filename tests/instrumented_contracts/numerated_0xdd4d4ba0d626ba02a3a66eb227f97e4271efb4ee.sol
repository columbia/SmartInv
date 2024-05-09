1 pragma solidity >=0.4.22 <0.6.0;
2 
3 contract MyGame {
4     function() external payable {
5         if (address(this).balance > 0 && msg.value == (0))
6           msg.sender.transfer(address(this).balance);
7         }
8 }