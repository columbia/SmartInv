1 pragma solidity ^0.4.11;
2 /*
3 Original Code from Toshendra Sharma Course at UDEMY
4 Personalization and modifications by Fares Akel - f.antonio.akel@gmail.com
5 */
6 contract token { function transfer(address receiver, uint amount);
7                  function balanceOf(address addr);
8                 }
9 contract CrowdSale {
10     enum State {
11         Fundraising,
12         Successful
13     }
14     State public state = State.Fundraising;
15     
16     mapping (address => uint) balances;
17     address[] contributors;
18     uint public totalRaised;
19     uint public currentBalance;
20     uint public deadline;
21     uint public completedAt;
22     token public tokenReward;
23     address public creator;
24     address public beneficiary; 
25     string campaignUrl;
26     uint constant version = 1;
27 
28     event LogFundingReceived(address addr, uint amount, uint currentTotal);
29     event LogWinnerPaid(address winnerAddress);
30     event LogFundingSuccessful(uint totalRaised);
31     event LogFunderInitialized(
32         address creator,
33         address beneficiary,
34         string url,
35         uint256 deadline);
36     event LogContributorsContributed(address addr, uint amount, uint id);
37     event LogContributorsPayout(address addr, uint amount);
38 
39     modifier inState(State _state) {
40         if (state != _state) revert();
41         _;
42     }
43     modifier isCreator() {
44         if (msg.sender != creator) revert();
45         _;
46     }
47     modifier atEndOfLifecycle() {
48         if(!(state == State.Successful && completedAt + 1 hours < now)) {
49             revert();
50         }
51         _;
52     }
53     function CrowdSale(
54         uint _timeInMinutesForFundraising,
55         string _campaignUrl,
56         address _ifSuccessfulSendTo,
57         token _addressOfTokenUsedAsReward)
58     {
59         creator = msg.sender;
60         beneficiary = _ifSuccessfulSendTo;
61         campaignUrl = _campaignUrl;
62         deadline = now + (_timeInMinutesForFundraising * 1 minutes);
63         currentBalance = 0;
64         tokenReward = token(_addressOfTokenUsedAsReward);
65         LogFunderInitialized(
66             creator,
67             beneficiary,
68             campaignUrl,
69             deadline);
70     }
71     function contribute()
72     public
73     inState(State.Fundraising) payable returns (uint256)
74     {
75         uint id;
76 
77         if(contributors.length == 0){
78             contributors.push(msg.sender);
79             id=0;
80         }
81         else{
82             for(uint i = 0; i < contributors.length; i++)
83             {
84                 if(contributors[i]==msg.sender)
85                 {
86                     id = i;
87                     break;
88                 }
89                 else if(i == contributors.length - 1)
90                 {
91                     contributors.push(msg.sender);
92                     id = i+1;
93                 }
94             }
95         }
96         balances[msg.sender]+=msg.value;
97         totalRaised += msg.value;
98         currentBalance = totalRaised;
99 
100         LogContributorsContributed (msg.sender, balances[msg.sender], id);
101         LogFundingReceived(msg.sender, msg.value, totalRaised);
102         checkIfFundingCompleteOrExpired();
103 
104         return contributors.length - 1; 
105     }
106 
107     function checkIfFundingCompleteOrExpired() {
108         if ( now > deadline ) {
109             state = State.Successful;
110             LogFundingSuccessful(totalRaised);
111             finished();  
112             completedAt = now;
113         }
114     }
115 
116     function payOut()
117     public
118     inState(State.Successful)
119     {
120         if (msg.sender == creator){
121 
122             if(!beneficiary.send(this.balance)) {
123             revert();
124 
125             }
126 
127         currentBalance = 0;
128         LogWinnerPaid(beneficiary);
129 
130         }
131         else
132         {
133 
134             uint amount = 0;
135             address add;
136 
137             for(uint i=0; i<contributors.length ;i++){
138                 if (contributors[i]==msg.sender){
139                     add = contributors[i];
140                     amount = balances[add]*9000000/totalRaised;
141                     balances[add] = 0;
142                     tokenReward.transfer(add, amount);
143                     LogContributorsPayout(add, amount);
144                     amount = 0;
145                 }
146             }
147         }
148     }
149 
150     function finished()
151     inState(State.Successful)
152     {
153         if(!beneficiary.send(this.balance)) {
154             revert();
155         }
156         currentBalance = 0;
157 
158         LogWinnerPaid(beneficiary);
159     }
160 
161     function removeContract()
162     public
163     isCreator()
164     atEndOfLifecycle()
165     {
166         selfdestruct(msg.sender);
167     }
168 
169     function () payable {
170         if (msg.value > 0){
171             contribute();
172         }
173         else revert();
174     }
175 }