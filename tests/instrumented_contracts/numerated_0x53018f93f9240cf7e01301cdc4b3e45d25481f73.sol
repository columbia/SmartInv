1 pragma solidity ^0.4.20;
2 
3 contract BRTH_GFT
4 {
5     address sender;
6     
7     address reciver;
8     
9     bool closed = false;
10     
11     uint unlockTime;
12  
13     function Put_BRTH_GFT(address _reciver) public payable {
14         if( (!closed&&(msg.value > 1 ether)) || sender==0x00 )
15         {
16             sender = msg.sender;
17             reciver = _reciver;
18             unlockTime = now;
19         }
20     }
21     
22     function SetGiftTime(uint _unixTime) public canOpen {
23         if(msg.sender==sender)
24         {
25             unlockTime = _unixTime;
26         }
27     }
28     
29     function GetGift() public payable canOpen {
30         if(reciver==msg.sender)
31         {
32             msg.sender.transfer(this.balance);
33         }
34     }
35     
36     function CloseGift() public {
37         if(sender == msg.sender && reciver != 0x0 )
38         {
39            closed=true;
40         }
41     }
42     
43     modifier canOpen(){
44         if(now>unlockTime)_;
45         else return;
46     }
47     
48     function() public payable{}
49 }