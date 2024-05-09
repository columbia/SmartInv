1 pragma solidity ^0.4.1;
2 
3 contract ForceSendHelper
4 {
5     function ForceSendHelper(address _to) payable
6     {
7         selfdestruct(_to);
8     }
9 }
10 
11 contract ForceSend
12 {
13     function send(address _to) payable
14     {
15         if (_to == 0x0) {
16             throw;
17         }
18         ForceSendHelper s = (new ForceSendHelper).value(msg.value)(_to);
19         if (address(s) == 0x0) {
20             throw;
21         }
22     }
23     
24     function withdraw(address _to)
25     {
26         if (_to == 0x0) {
27             throw;
28         }
29         if (!_to.send(this.balance)) {
30             throw;
31         }
32     }
33 }