1 pragma solidity ^0.4.4;
2 
3 contract DutchAuctionInterface {
4     function bid(address receiver) payable returns (uint);
5     function claimTokens(address receiver);
6     function stage() returns (uint);
7     TokenInterface public gnosisToken;
8 }
9 
10 
11 contract TokenInterface {
12     function transfer(address to, uint256 value) returns (bool success);
13     function balanceOf(address owner) constant returns (uint256 balance);
14 }
15 
16 
17 contract ProxySender {
18 
19     event BidSubmission(address indexed sender, uint256 amount);
20     event RefundSubmission(address indexed sender, uint256 amount);
21     event RefundReceived(uint256 amount);
22 
23     uint public constant AUCTION_STARTED = 2;
24     uint public constant TRADING_STARTED = 4;
25 
26     DutchAuctionInterface public dutchAuction;
27     TokenInterface public gnosisToken;
28     uint public totalContributions;
29     uint public totalTokens;
30     uint public totalBalance;
31     mapping (address => uint) public contributions;
32     Stages public stage;
33 
34     enum Stages {
35         ContributionsCollection,
36         ContributionsSent,
37         TokensClaimed
38     }
39 
40     modifier atStage(Stages _stage) {
41         if (stage != _stage)
42             throw;
43         _;
44     }
45 
46     function ProxySender(address _dutchAuction)
47         public
48     {
49         if (_dutchAuction == 0) throw;
50         dutchAuction = DutchAuctionInterface(_dutchAuction);
51         gnosisToken = dutchAuction.gnosisToken();
52         if (address(gnosisToken) == 0) throw;
53         stage = Stages.ContributionsCollection;
54     }
55 
56     function()
57         public
58         payable
59     {
60         if (msg.sender == address(dutchAuction))
61             RefundReceived(msg.value);
62         else if (stage == Stages.ContributionsCollection)
63             contribute();
64         else if(stage == Stages.TokensClaimed)
65             transfer();
66         else
67             throw;
68     }
69 
70     function contribute()
71         public
72         payable
73         atStage(Stages.ContributionsCollection)
74     {
75         contributions[msg.sender] += msg.value;
76         totalContributions += msg.value;
77         BidSubmission(msg.sender, msg.value);
78     }
79 
80     function refund()
81         public
82         atStage(Stages.ContributionsCollection)
83     {
84         uint contribution = contributions[msg.sender];
85         contributions[msg.sender] = 0;
86         totalContributions -= contribution;
87         RefundSubmission(msg.sender, contribution);
88         if (!msg.sender.send(contribution)) throw;
89     }
90 
91     function bidProxy()
92         public
93         atStage(Stages.ContributionsCollection)
94         returns(bool)
95     {
96         // Check auction has started
97         if (dutchAuction.stage() != AUCTION_STARTED)
98             throw;
99         // Send all money to auction contract
100         stage = Stages.ContributionsSent;
101         dutchAuction.bid.value(this.balance)(0);
102         return true;
103     }
104 
105     function claimProxy()
106         public
107         atStage(Stages.ContributionsSent)
108     {
109         // Auction is over
110         if (dutchAuction.stage() != TRADING_STARTED)
111             throw;
112         dutchAuction.claimTokens(0);
113         totalTokens = gnosisToken.balanceOf(this);
114         totalBalance = this.balance;
115         stage = Stages.TokensClaimed;
116     }
117 
118     function transfer()
119         public
120         atStage(Stages.TokensClaimed)
121         returns (uint amount)
122     {
123         uint contribution = contributions[msg.sender];
124         contributions[msg.sender] = 0;
125         // Calc. percentage of tokens for sender
126         amount = totalTokens * contribution / totalContributions;
127         gnosisToken.transfer(msg.sender, amount);
128         // Send possible refund share
129         uint refund = totalBalance * contribution / totalContributions;
130         if (refund > 0)
131             if (!msg.sender.send(refund)) throw;
132     }
133 }