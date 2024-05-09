1 pragma solidity ^0.4.16;
2 
3 contract token { function transfer(address receiver, uint amount) public ;
4                  function mintToken(address target, uint mintedAmount) public ;
5                 }
6 
7 contract CrowdSale {
8     enum State {
9         Fundraising,
10         Failed,
11         Successful,
12         Closed
13     }
14     State public state = State.Fundraising;
15 
16     struct Contribution {
17         uint amount;
18         address contributor;
19     }
20     Contribution[] contributions;
21 
22     
23     
24     uint public totalRaised;
25     uint public currentBalance;
26     uint public deadline;
27     uint public completedAt;
28     uint public priceInWei;
29     uint public fundingMinimumTargetInWei; 
30     uint public fundingMaximumTargetInWei; 
31     token public tokenReward;
32     address public creator;
33     address public beneficiary; 
34     string campaignUrl;
35     byte constant version = "1";
36 
37     
38     event LogFundingReceived(address addr, uint amount, uint currentTotal);
39     event LogWinnerPaid(address winnerAddress);
40     event LogFundingSuccessful(uint totalRaised);
41     event LogFunderInitialized(
42         address creator,
43         address beneficiary,
44         string url,
45         uint _fundingMaximumTargetInEther, 
46         uint256 deadline);
47 
48 
49     modifier inState(State _state) {
50         require(state == _state) ;
51         _;
52     }
53 
54      modifier isMinimum() {
55         require(msg.value > priceInWei) ;
56         _;
57     }
58 
59     modifier inMultipleOfPrice() {
60         require(msg.value%priceInWei == 0) ;
61         _;
62     }
63 
64     modifier isCreator() {
65         require(msg.sender == creator) ;
66         _;
67     }
68 
69     
70     modifier atEndOfLifecycle() {
71         if(!((state == State.Failed || state == State.Successful) && completedAt + 1 hours < now)) {
72             revert();
73         }
74         _;
75     }
76 
77     
78     function CrowdSale(
79         uint _timeInMinutesForFundraising,
80         string _campaignUrl,
81         address _ifSuccessfulSendTo,
82         uint _fundingMinimumTargetInEther,
83         uint _fundingMaximumTargetInEther,
84         token _addressOfTokenUsedAsReward,
85         uint _etherCostOfEachToken) public
86     {
87         creator = msg.sender;
88         beneficiary = _ifSuccessfulSendTo;
89         campaignUrl = _campaignUrl;
90         fundingMinimumTargetInWei = _fundingMinimumTargetInEther * 1 ether; 
91         fundingMaximumTargetInWei = _fundingMaximumTargetInEther * 1 ether; 
92         deadline = now + (_timeInMinutesForFundraising * 1 minutes);
93         currentBalance = 0;
94         tokenReward = token(_addressOfTokenUsedAsReward);
95         priceInWei = _etherCostOfEachToken * 1 ether;
96         LogFunderInitialized(
97             creator,
98             beneficiary,
99             campaignUrl,
100             fundingMaximumTargetInWei,
101             deadline);
102     }
103 
104     function contribute()
105     public
106     inState(State.Fundraising) isMinimum() inMultipleOfPrice() payable returns (uint256)
107     {
108         uint256 amountInWei = msg.value;
109 
110         
111         contributions.push(
112             Contribution({
113                 amount: msg.value,
114                 contributor: msg.sender
115                 }) 
116             );
117 
118         totalRaised += msg.value;
119         currentBalance = totalRaised;
120 
121 
122         if(fundingMaximumTargetInWei != 0){
123             
124             tokenReward.transfer(msg.sender, amountInWei / priceInWei);
125         }
126         else{
127             tokenReward.mintToken(msg.sender, amountInWei / priceInWei);
128         }
129 
130         LogFundingReceived(msg.sender, msg.value, totalRaised);
131 
132         
133 
134         checkIfFundingCompleteOrExpired();
135         return contributions.length - 1; 
136     }
137 
138     function checkIfFundingCompleteOrExpired() public {
139         
140        
141         if (fundingMaximumTargetInWei != 0 && totalRaised > fundingMaximumTargetInWei) {
142             state = State.Successful;
143             LogFundingSuccessful(totalRaised);
144             payOut();
145             completedAt = now;
146             
147             } else if ( now > deadline )  {
148                 if(totalRaised >= fundingMinimumTargetInWei){
149                     state = State.Successful;
150                     LogFundingSuccessful(totalRaised);
151                     payOut();  
152                     completedAt = now;
153                 }
154                 else{
155                     state = State.Failed; 
156                     completedAt = now;
157                 }
158             } 
159         
160     }
161 
162         function payOut()
163         public
164         inState(State.Successful)
165         {
166             
167             if(!beneficiary.send(this.balance)) {
168                 revert();
169             }
170 
171             state = State.Closed;
172             currentBalance = 0;
173             LogWinnerPaid(beneficiary);
174         }
175 
176         function getRefund()
177         public
178         inState(State.Failed) 
179         returns (bool)
180         {
181             for(uint i=0; i<=contributions.length; i++)
182             {
183                 if(contributions[i].contributor == msg.sender){
184                     uint amountToRefund = contributions[i].amount;
185                     contributions[i].amount = 0;
186                     if(!contributions[i].contributor.send(amountToRefund)) {
187                         contributions[i].amount = amountToRefund;
188                         return false;
189                     }
190                     else{
191                         totalRaised -= amountToRefund;
192                         currentBalance = totalRaised;
193                     }
194                     return true;
195                 }
196             }
197             return false;
198         }
199 
200         function removeContract()
201         public
202         isCreator()
203         atEndOfLifecycle()
204         {
205             selfdestruct(msg.sender);
206             
207         }
208 
209         function () public { revert(); }
210 }