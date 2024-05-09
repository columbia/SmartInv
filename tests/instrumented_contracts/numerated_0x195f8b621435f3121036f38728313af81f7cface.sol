1 pragma solidity 0.4.11;
2 
3 contract CrowdWithUs {
4     
5     address public creator;
6     address public fundRecipient; // creator may be different than recipient
7     uint public minimumToRaise; // required to reach at least this much, else everyone gets refund
8     string campaignUrl; 
9     byte constant version = 1;
10 
11     // Data structures
12     enum State {
13         Fundraising,
14         ExpiredRefund,
15         Successful,
16         Closed
17     }
18 
19     struct Contribution {
20         uint amount;
21         address contributor;
22     }
23 
24     // State variables
25     State public state = State.Fundraising; // initialize on create
26     uint public totalRaised;
27     uint public currentBalance;
28     uint public raiseBy;
29     uint public completeAt;
30     Contribution[] contributions;
31 
32     event LogFundingReceived(address addr, uint amount, uint currentTotal);
33     event LogWinnerPaid(address winnerAddress);
34     event LogFunderInitialized(
35         address creator,
36         address fundRecipient,
37         string url,
38         uint _minimumToRaise, 
39         uint256 raiseby
40     );
41 
42     modifier inState(State _state) {
43         if (state != _state) throw;
44         _;
45     }
46 
47     modifier isCreator() {
48         if (msg.sender != creator) throw;
49         _;
50     }
51 
52     // Wait 1 hour after final contract state before allowing contract destruction
53     modifier atEndOfLifecycle() {
54         if(!((state == State.ExpiredRefund || state == State.Successful) && completeAt + 1 hours < now)) {
55             throw;
56         }
57         _;
58     }
59 
60     function CrowdWithUs(
61         uint timeInHoursForFundraising,
62         string _campaignUrl,
63         address _fundRecipient,
64         uint _minimumToRaise)
65     {
66         creator = msg.sender;
67         fundRecipient = _fundRecipient;
68         campaignUrl = _campaignUrl;
69         minimumToRaise = _minimumToRaise * 1 ether; //convert to wei
70         raiseBy = now + (timeInHoursForFundraising * 1 hours);
71         currentBalance = 0;
72         LogFunderInitialized(
73             creator,
74             fundRecipient,
75             campaignUrl,
76             minimumToRaise,
77             raiseBy);
78     }
79 
80     function contribute()
81     public
82     inState(State.Fundraising) payable returns (uint256)
83     {
84         contributions.push(
85             Contribution({
86                 amount: msg.value,
87                 contributor: msg.sender
88                 }) // use array, so can iterate
89             );
90         totalRaised += msg.value;
91         currentBalance = totalRaised;
92         LogFundingReceived(msg.sender, msg.value, totalRaised);
93 
94         checkIfFundingCompleteOrExpired();
95         return contributions.length - 1; // return id
96     }
97 
98     function checkIfFundingCompleteOrExpired() {
99         if (totalRaised > minimumToRaise) {
100             state = State.Successful;
101             payOut();
102 
103             // could incentivize sender who initiated state change here
104             } else if ( now > raiseBy )  {
105                 state = State.ExpiredRefund; // backers can now collect refunds by calling getRefund(id)
106             }
107             completeAt = now;
108         }
109 
110         function payOut()
111         public
112         inState(State.Successful)
113         {
114             if(!fundRecipient.send(this.balance)) {
115                 throw;
116             }
117             state = State.Closed;
118             currentBalance = 0;
119             LogWinnerPaid(fundRecipient);
120         }
121 
122         function getRefund(uint256 id)
123         public
124         inState(State.ExpiredRefund) 
125         returns (bool)
126         {
127             if (contributions.length <= id || id < 0 || contributions[id].amount == 0 ) {
128                 throw;
129             }
130 
131             uint amountToRefund = contributions[id].amount;
132             contributions[id].amount = 0;
133 
134             if(!contributions[id].contributor.send(amountToRefund)) {
135                 contributions[id].amount = amountToRefund;
136                 return false;
137             }
138             else{
139                 totalRaised -= amountToRefund;
140                 currentBalance = totalRaised;
141             }
142 
143             return true;
144         }
145 
146         function removeContract()
147         public
148         isCreator()
149         atEndOfLifecycle()
150         {
151             selfdestruct(msg.sender);
152             // creator gets all money that hasn't be claimed
153 
154 
155         }
156 
157         function () { throw; }
158     }