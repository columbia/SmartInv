1 pragma solidity ^0.4.18;
2 
3 interface token {
4     function transferFrom(address _from, address _to, uint256 _value) public;
5 }
6 
7 contract CrowdSale {
8     address public beneficiary;
9     uint public fundingGoal;
10     uint public amountRaised;
11     uint public startTime;
12     uint public deadline;
13     uint public endFirstBonus;
14     uint public endSecondBonus;
15     uint public endThirdBonus;
16     uint public hardCap;
17     uint public price;
18     uint public minPurchase;
19     token public tokenReward;
20     mapping(address => uint256) public balanceOf;
21     bool fundingGoalReached = false;
22     bool public crowdsaleClosed = false;
23 
24     event GoalReached(address recipient, uint totalAmountRaised);
25     event FundTransfer(address backer, uint amount, bool isContribution);
26     event CrowdsaleClose(uint totalAmountRaised, bool fundingGoalReached);
27 
28     /**
29      * Constrctor function
30      *
31      * Setup the owner
32      */
33     function CrowdSale(
34         address ifSuccessfulSendTo,
35         address addressOfTokenUsedAsReward,
36         uint tokensPerEth,
37         uint _minPurchase,
38         uint fundingGoalInWei,
39         uint hardCapInWei,
40         uint startTimeInSeconds,
41         uint durationInMinutes,
42         uint _endFirstBonus,
43         uint _endSecondBonus,
44         uint _endThirdBonus
45     ) public {
46         beneficiary = ifSuccessfulSendTo;
47         tokenReward = token(addressOfTokenUsedAsReward);
48         price = tokensPerEth;
49         minPurchase = _minPurchase;
50         fundingGoal = fundingGoalInWei;
51         hardCap = hardCapInWei;
52         startTime = startTimeInSeconds;
53         deadline = startTimeInSeconds + durationInMinutes * 1 minutes;
54         endFirstBonus = _endFirstBonus;
55         endSecondBonus = _endSecondBonus;
56         endThirdBonus = _endThirdBonus;
57     }
58 
59     /**
60      * Do purchase process
61      *
62      */
63     function purchase() internal {
64         uint amount = msg.value;
65         uint vp = amount * price;
66         uint tokens = ((vp + ((vp * getBonus()) / 100))) / 1 ether;
67         balanceOf[msg.sender] += amount;
68         amountRaised += amount;
69         tokenReward.transferFrom(beneficiary, msg.sender, tokens);
70         checkGoalReached();
71         FundTransfer(msg.sender, amount, true);
72     }
73 
74     /**
75      * Fallback function
76      *
77      * The function without name is the default function that is called whenever anyone sends funds to a contract
78      */
79     function()
80     payable
81     isOpen
82     afterStart
83     hardCapNotReached
84     aboveMinValue
85     public {
86         purchase();
87     }
88 
89     /**
90      * The function called only from shiftsale
91      *
92      */
93     function shiftSalePurchase()
94     payable
95     isOpen
96     afterStart
97     hardCapNotReached
98     aboveMinValue
99     public returns (bool success) {
100         purchase();
101         return true;
102     }
103 
104     modifier afterStart() {
105         require(now >= startTime);
106         _;
107     }
108 
109     modifier afterDeadline() {
110         require(now >= deadline);
111         _;
112     }
113 
114     modifier previousDeadline() {
115         require(now <= deadline);
116         _;
117     }
118 
119     modifier isOwner() {
120         require(msg.sender == beneficiary);
121         _;
122     }
123 
124     modifier isClosed() {
125         require(crowdsaleClosed);
126         _;
127     }
128 
129     modifier isOpen() {
130         require(!crowdsaleClosed);
131         _;
132     }
133 
134     modifier hardCapNotReached() {
135         require(amountRaised < hardCap);
136         _;
137     }
138 
139     modifier aboveMinValue() {
140         require(msg.value >= minPurchase);
141         _;
142     }
143 
144     /**
145      * Check if goal was reached
146      *
147      */
148     function checkGoalReached() internal {
149         if (amountRaised >= fundingGoal && !fundingGoalReached) {
150             fundingGoalReached = true;
151             GoalReached(beneficiary, amountRaised);
152         }
153     }
154 
155     /**
156      * Close the crowdsale
157      *
158      */
159     function closeCrowdsale()
160     isOwner
161     public {
162         crowdsaleClosed = true;
163         CrowdsaleClose(amountRaised, fundingGoalReached);
164     }
165 
166     /**
167      * Change min purchase value
168      *
169      */
170     function setMinPurchaseValue(uint _minPurchase)
171     isOwner
172     public {
173         minPurchase = _minPurchase;
174     }
175 
176     /**
177      * Withdraw the funds
178      *
179      * Checks to see if goal or time limit has been reached, and if so, and the funding goal was reached,
180      * sends the entire amount to the beneficiary. If goal was not reached, each contributor can withdraw
181      * the amount they contributed.
182      */
183     function safeWithdrawal()
184     afterDeadline
185     isClosed
186     public {
187         if (!fundingGoalReached) {
188             uint amount = balanceOf[msg.sender];
189             balanceOf[msg.sender] = 0;
190             if (amount > 0) {
191                 if (msg.sender.send(amount)) {
192                     FundTransfer(msg.sender, amount, false);
193                 } else {
194                     balanceOf[msg.sender] = amount;
195                 }
196             }
197         }
198 
199         if (fundingGoalReached && beneficiary == msg.sender) {
200             if (beneficiary.send(amountRaised)) {
201                 FundTransfer(beneficiary, amountRaised, false);
202             } else {
203                 //If we fail to send the funds to beneficiary, unlock funders balance
204                 fundingGoalReached = false;
205             }
206         }
207     }
208 
209     function getBonus() view public returns (uint) {
210         if (startTime <= now) {
211             if (now <= endFirstBonus) {
212                 return 50;
213             } else if (now <= endSecondBonus) {
214                 return 40;
215             } else if (now <= endThirdBonus) {
216                 return 30;
217             } else {
218                 return 20;
219             }
220         }
221         return 0;
222     }
223 }