1 pragma solidity 0.4.11;
2 
3 contract token { function transfer(address receiver, uint amount);
4                  function mintToken(address target, uint mintedAmount);
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
35     byte constant version = 1;
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
50         if (state != _state) throw;
51         _;
52     }
53 
54      modifier isMinimum() {
55         if(msg.value < priceInWei) throw;
56         _;
57     }
58 
59 
60 
61     modifier isCreator() {
62         if (msg.sender != creator) throw;
63         _;
64     }
65 
66     
67     modifier atEndOfLifecycle() {
68         if(!((state == State.Failed || state == State.Successful) && completedAt + 1 hours < now)) {
69             throw;
70         }
71         _;
72     }
73 
74     
75     function CrowdSale(
76         uint _timeInMinutesForFundraising,
77         string _campaignUrl,
78         address _ifSuccessfulSendTo,
79         uint _fundingMinimumTargetInEther,
80         uint _fundingMaximumTargetInEther,
81         token _addressOfTokenUsedAsReward,
82         uint _etherCostOfEachToken)
83     {
84         creator = msg.sender;
85         beneficiary = _ifSuccessfulSendTo;
86         campaignUrl = _campaignUrl;
87         fundingMinimumTargetInWei = _fundingMinimumTargetInEther * 1 ether; 
88         fundingMaximumTargetInWei = _fundingMaximumTargetInEther * 1 ether; 
89         deadline = now + (_timeInMinutesForFundraising * 1 minutes);
90         currentBalance = 0;
91         tokenReward = token(_addressOfTokenUsedAsReward);
92         priceInWei = _etherCostOfEachToken ;
93         LogFunderInitialized(
94             creator,
95             beneficiary,
96             campaignUrl,
97             fundingMaximumTargetInWei,
98             deadline);
99     }
100 
101     function contribute()
102     public
103     inState(State.Fundraising) isMinimum() payable returns (uint256)
104     {
105         uint256 amountInWei = msg.value;
106 
107         
108         contributions.push(
109             Contribution({
110                 amount: msg.value,
111                 contributor: msg.sender
112                 }) 
113             );
114 
115         totalRaised += msg.value;
116         currentBalance = totalRaised;
117 
118 
119         if(fundingMaximumTargetInWei != 0){
120             
121             tokenReward.transfer(msg.sender, amountInWei * 1000000000000000000 / priceInWei);
122         }
123         else{
124             tokenReward.mintToken(msg.sender, amountInWei * 1000000000000000000 / priceInWei);
125         }
126 
127         LogFundingReceived(msg.sender, msg.value, totalRaised);
128 
129         
130 
131         checkIfFundingCompleteOrExpired();
132         return contributions.length - 1; 
133     }
134 
135     function checkIfFundingCompleteOrExpired() {
136         
137        
138         if (fundingMaximumTargetInWei != 0 && totalRaised > fundingMaximumTargetInWei) {
139             state = State.Successful;
140             LogFundingSuccessful(totalRaised);
141             payOut();
142             completedAt = now;
143             
144             } else if ( now > deadline )  {
145                 if(totalRaised >= fundingMinimumTargetInWei){
146                     state = State.Successful;
147                     LogFundingSuccessful(totalRaised);
148                     payOut();  
149                     completedAt = now;
150                 }
151                 else{
152                     state = State.Failed; 
153                     completedAt = now;
154                 }
155             } 
156         
157     }
158 
159         function payOut()
160         public
161         inState(State.Successful)
162         {
163             
164             if(!beneficiary.send(this.balance)) {
165                 throw;
166             }
167 
168             state = State.Closed;
169             currentBalance = 0;
170             LogWinnerPaid(beneficiary);
171         }
172 
173         function getRefund()
174         public
175         inState(State.Failed) 
176         returns (bool)
177         {
178             for(uint i=0; i<=contributions.length; i++)
179             {
180                 if(contributions[i].contributor == msg.sender){
181                     uint amountToRefund = contributions[i].amount;
182                     contributions[i].amount = 0;
183                     if(!contributions[i].contributor.send(amountToRefund)) {
184                         contributions[i].amount = amountToRefund;
185                         return false;
186                     }
187                     else{
188                         totalRaised -= amountToRefund;
189                         currentBalance = totalRaised;
190                     }
191                     return true;
192                 }
193             }
194             return false;
195         }
196 
197         function removeContract()
198         public
199         isCreator()
200         atEndOfLifecycle()
201         {
202             selfdestruct(msg.sender);
203             
204         }
205 
206         function () { throw; }
207 }