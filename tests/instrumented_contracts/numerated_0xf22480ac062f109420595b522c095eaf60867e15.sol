1 pragma solidity ^0.4.18;
2 
3 interface token {
4     function transfer(address receiver, uint amount) external;
5 }
6 
7 contract Ownable {
8   address public owner;
9 
10   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
11 
12   function Ownable() public {
13     owner = msg.sender;
14   }
15 
16   modifier onlyOwner() {
17     require(msg.sender == owner);
18     _;
19   }
20 
21   function transferOwnership(address newOwner) public onlyOwner {
22     require(newOwner != address(0));
23     OwnershipTransferred(owner, newOwner);
24     owner = newOwner;
25   }
26 
27 }
28 
29 contract I2Crowdsale is Ownable {
30     using SafeMath for uint256;
31 
32     address public beneficiary;
33     uint public fundingGoal;
34     uint public amountRaised;
35     uint public deadline;
36     uint public price;
37     uint public usd = 550;
38     uint public tokensPerDollar = 10; // $0.1 = 10
39     uint public bonus = 30;
40     token public tokenReward;
41     mapping(address => uint256) public balanceOf;
42     bool fundingGoalReached = false;
43     bool crowdsaleClosed = false;
44 
45     event GoalReached(address recipient, uint totalAmountRaised);
46     event FundTransfer(address backer, uint amount, bool isContribution);
47 
48     /**
49      * Constrctor function
50      *
51      * Setup the owner
52      */
53     function I2Crowdsale (
54         address ifSuccessfulSendTo,
55         uint fundingGoalInEthers,
56         uint durationInMinutes,
57         // how many token units a buyer gets per dollar
58         // how many token units a buyer gets per wei
59         // uint etherCostOfEachToken,
60         // uint bonusInPercent,
61         address addressOfTokenUsedAsReward
62     ) public {
63         beneficiary = ifSuccessfulSendTo;
64         // mean set 100-1000 ETH
65         fundingGoal = fundingGoalInEthers.mul(1 ether); 
66         deadline = now.add(durationInMinutes.mul(1 minutes));
67         price = 10**18 / tokensPerDollar / usd; 
68         // price = etherCostOfEachToken * 1 ether;
69         // price = etherCostOfEachToken.mul(1 ether).div(1000).mul(usd);
70         // bonus = bonusInPercent;
71 
72         tokenReward = token(addressOfTokenUsedAsReward);
73     }
74 
75     /**
76     * Change Crowdsale bonus rate
77     */
78     function changeBonus (uint _bonus) public onlyOwner {
79         bonus = _bonus;
80     }
81     
82     /**
83     * Set USD/ETH rate in USD (1000)
84     */
85     function setUSDPrice (uint _usd) public onlyOwner {
86         usd = _usd;
87         price = 10**18 / tokensPerDollar / usd; 
88     }
89     
90     /**
91     * Finish Crowdsale in some reason like Goals Reached or etc
92     */
93     function finishCrowdsale () public onlyOwner {
94         deadline = now;
95         crowdsaleClosed = true;
96     }
97 
98     /**
99      * Fallback function
100      *
101      * The function without name is the default function that is called whenever anyone sends funds to a contract
102      */
103     function () public payable {
104         require(beneficiary != address(0));
105         require(!crowdsaleClosed);
106         require(msg.value != 0);
107         
108         uint amount = msg.value;
109         balanceOf[msg.sender] += amount;
110         amountRaised += amount;
111         // bonus in percent 
112         // msg.value.add(msg.value.mul(bonus).div(100));
113         uint tokensToSend = amount.div(price).mul(10**18);
114         uint tokenToSendWithBonus = tokensToSend.add(tokensToSend.mul(bonus).div(100));
115         tokenReward.transfer(msg.sender, tokenToSendWithBonus);
116         FundTransfer(msg.sender, amount, true);
117     }
118 
119     modifier afterDeadline() { if (now >= deadline) _; }
120 
121     /**
122      * Check if goal was reached
123      *
124      * Checks if the goal or time limit has been reached and ends the campaign
125      */
126     function checkGoalReached() public afterDeadline {
127         if (amountRaised >= fundingGoal){
128             fundingGoalReached = true;
129             GoalReached(beneficiary, amountRaised);
130         }
131         crowdsaleClosed = true;
132     }
133 
134 
135     /**
136      * Withdraw the funds
137      *
138      * Checks to see if goal or time limit has been reached, and if so, and the funding goal was reached,
139      * sends the entire amount to the beneficiary. If goal was not reached, each contributor can withdraw
140      * the amount they contributed.
141      */
142     function safeWithdrawal() public afterDeadline {
143         if (!fundingGoalReached) {
144             uint amount = balanceOf[msg.sender];
145             balanceOf[msg.sender] = 0;
146             if (amount > 0) {
147                 if (msg.sender.send(amount)) {
148                     FundTransfer(msg.sender, amount, false);
149                 } else {
150                     balanceOf[msg.sender] = amount;
151                 }
152             }
153         }
154 
155         if (fundingGoalReached && beneficiary == msg.sender) {
156             if (beneficiary.send(amountRaised)) {
157                 FundTransfer(beneficiary, amountRaised, false);
158             } else {
159                 //If we fail to send the funds to beneficiary, unlock funders balance
160                 fundingGoalReached = false;
161             }
162         }
163     }
164 }
165 
166 library SafeMath {
167 
168   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
169     if (a == 0) {
170       return 0;
171     }
172     uint256 c = a * b;
173     assert(c / a == b);
174     return c;
175   }
176 
177   function div(uint256 a, uint256 b) internal pure returns (uint256) {
178     uint256 c = a / b;
179     return c;
180   }
181 
182   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
183     assert(b <= a);
184     return a - b;
185   }
186 
187   function add(uint256 a, uint256 b) internal pure returns (uint256) {
188     uint256 c = a + b;
189     assert(c >= a);
190     return c;
191   }
192 }