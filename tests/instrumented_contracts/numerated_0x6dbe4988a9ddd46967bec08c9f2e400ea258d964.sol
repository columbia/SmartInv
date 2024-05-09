1 pragma solidity 0.4.10;
2 
3 
4 contract DutchAuction {
5     function bid(address receiver) payable returns (uint);
6     function claimTokens(address receiver);
7     function stage() returns (uint);
8     function calcTokenPrice() constant public returns (uint);
9     Token public gnosisToken;
10 }
11 
12 
13 contract Token {
14     function transfer(address to, uint256 value) returns (bool success);
15     function balanceOf(address owner) constant returns (uint256 balance);
16 }
17 
18 
19 contract BiddingRing {
20 
21     event BidSubmission(address indexed sender, uint256 amount);
22     event RefundSubmission(address indexed sender, uint256 amount);
23     event RefundReceived(uint256 amount);
24 
25     uint public constant AUCTION_STARTED = 2;
26     uint public constant TRADING_STARTED = 4;
27 
28     DutchAuction public dutchAuction;
29     Token public gnosisToken;
30     uint public maxPrice;
31     uint public totalContributions;
32     uint public totalTokens;
33     uint public totalBalance;
34     mapping (address => uint) public contributions;
35     Stages public stage;
36 
37     enum Stages {
38         ContributionsCollection,
39         ContributionsSent,
40         TokensClaimed
41     }
42 
43     modifier atStage(Stages _stage) {
44         if (stage != _stage)
45             throw;
46         _;
47     }
48 
49     function BiddingRing(address _dutchAuction, uint _maxPrice)
50         public
51     {
52         if (_dutchAuction == 0 || _maxPrice == 0)
53             throw;
54         dutchAuction = DutchAuction(_dutchAuction);
55         gnosisToken = dutchAuction.gnosisToken();
56         if (address(gnosisToken) == 0)
57             throw;
58         maxPrice = _maxPrice;
59         stage = Stages.ContributionsCollection;
60     }
61 
62     function()
63         public
64         payable
65     {
66         if (msg.sender == address(dutchAuction))
67             RefundReceived(msg.value);
68         else if (stage == Stages.ContributionsCollection)
69             contribute();
70         else if (stage == Stages.TokensClaimed)
71             transfer();
72         else
73             throw;
74     }
75 
76     function contribute()
77         public
78         payable
79         atStage(Stages.ContributionsCollection)
80     {
81         contributions[msg.sender] += msg.value;
82         totalContributions += msg.value;
83         BidSubmission(msg.sender, msg.value);
84     }
85 
86     function refund()
87         public
88         atStage(Stages.ContributionsCollection)
89     {
90         uint contribution = contributions[msg.sender];
91         contributions[msg.sender] = 0;
92         totalContributions -= contribution;
93         RefundSubmission(msg.sender, contribution);
94         if (!msg.sender.send(contribution))
95             throw;
96     }
97 
98     function bidProxy()
99         public
100         atStage(Stages.ContributionsCollection)
101     {
102         // Check auction has started and price is below max price
103         if (dutchAuction.stage() != AUCTION_STARTED || dutchAuction.calcTokenPrice() > maxPrice)
104             throw;
105         // Send all money to auction contract
106         stage = Stages.ContributionsSent;
107         dutchAuction.bid.value(this.balance)(0);
108     }
109 
110     function claimProxy()
111         public
112         atStage(Stages.ContributionsSent)
113     {
114         // Auction is over
115         if (dutchAuction.stage() != TRADING_STARTED)
116             throw;
117         dutchAuction.claimTokens(0);
118         totalTokens = gnosisToken.balanceOf(this);
119         totalBalance = this.balance;
120         stage = Stages.TokensClaimed;
121     }
122 
123     function transfer()
124         public
125         atStage(Stages.TokensClaimed)
126         returns (uint amount)
127     {
128         uint contribution = contributions[msg.sender];
129         contributions[msg.sender] = 0;
130         // Calc. percentage of tokens for sender
131         amount = totalTokens * contribution / totalContributions;
132         gnosisToken.transfer(msg.sender, amount);
133         // Send possible refund share, don't throw to make sure tokens are transferred
134         uint refund = totalBalance * contribution / totalContributions;
135         if (refund > 0)
136             msg.sender.send(refund);
137     }
138 }