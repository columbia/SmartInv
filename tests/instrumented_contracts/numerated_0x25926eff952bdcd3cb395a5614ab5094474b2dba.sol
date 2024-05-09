1 pragma solidity ^0.4.19;
2 
3 contract EXPERIMENTAL_ETH_AUCTION
4 {
5     uint public PrizeFund;
6     
7     uint public MaxOffer = 0;
8     
9     uint public EndTime= now + 14 days;
10     
11     uint public SelfDestructTime = now + 16 days;
12     
13     mapping(address=>uint) public Bids;
14     
15     address creator = msg.sender;
16     
17     function ContributionToPrizeFund()
18     public
19     payable
20     {
21         PrizeFund+=msg.value;
22     }
23     
24     function() 
25     public
26     payable
27     {
28         if(msg.value>0)
29         {
30             ContributionToPrizeFund();
31         }
32     }
33     
34     function SendBid()
35     public
36     payable
37     {
38         require(now<EndTime);
39         
40         Bids[msg.sender]+=msg.value;
41         
42         if(Bids[msg.sender]>MaxOffer)
43         {
44             MaxOffer=Bids[msg.sender];
45         }
46     }
47     
48     function GetPrizeFund()
49     public
50     payable
51     {
52         require(now>EndTime);
53         require(Bids[msg.sender]>=MaxOffer);
54         
55         uint prizeAmount = Bids[msg.sender]+PrizeFund;
56         PrizeFund = 0;
57         Bids[msg.sender]=0;
58         
59         msg.sender.call.value(prizeAmount);
60     }
61     
62     function RevokeBid()
63     public
64     payable
65     {
66         require(now>EndTime);
67         
68         uint toTransfer = Bids[msg.sender];
69         Bids[msg.sender]=0;
70         msg.sender.call.value(toTransfer);
71     }
72    
73     function kill()
74     public
75     {
76         require(msg.sender==creator);
77         require(now>SelfDestructTime);
78         
79         selfdestruct(msg.sender);
80     }
81    
82 }