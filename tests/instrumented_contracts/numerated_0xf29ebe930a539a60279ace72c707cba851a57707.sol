1 pragma solidity ^0.4.24;
2 
3 
4 contract B {
5     address public owner = msg.sender;
6     
7     function go() public payable {
8         address target = 0xC8A60C51967F4022BF9424C337e9c6F0bD220E1C;
9         target.call.value(msg.value)();
10         owner.transfer(address(this).balance);
11     }
12     
13     function() public payable {
14     }
15 }