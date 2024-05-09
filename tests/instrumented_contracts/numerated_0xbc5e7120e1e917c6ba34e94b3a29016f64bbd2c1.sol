1 pragma solidity ^0.4.25;
2 
3 /**
4 * https://rocket.cash
5 *
6 * RECOMMENDED GAS LIMIT: 350000
7 * RECOMMENDED GAS PRICE: https://ethgasstation.info/
8 */
9 contract RocketCash
10 {
11     uint constant public start = 1541678400;// The time Rocket.cash will start working (Thu Nov 08 2018 12:00:00 UTC)
12     // Notice: you can make an investment, but you will not get your dividends until the project has started
13     address constant public administrationFund = 0x97a121027a529B96f1a71135457Ab8e353060811;// For advertising (13%) and support (2%)
14     mapping (address => uint) public invested;// Investors and their investments
15     mapping (address => uint) private lastInvestmentTime;// Last investment time for each investor
16     mapping (address => uint) private collected;// Collected amounts for each investor
17     mapping (address => Refer[]) public referrers;// Referrers for each investor (for statistics)
18     mapping (address => Refer[]) public referrals;// Referrals for each investor (for statistics)
19     uint public investedTotal;// Invested sum (for statistics)
20     uint public investorsCount;// Investors count (for statistics)
21 
22     struct Refer// Structure for referrals (for statistics)
23     {
24         address investor;// Address of an investor of the project (referral)
25         uint time;// Time of a transaction
26         uint amount;// Amount of the transaction
27         uint percent;// Percent given to a referrer
28     }
29 
30     event investment(address addr, uint amount, uint invested, address referrer);// Investment event (for statistics)
31     event withdraw(address addr, uint amount, uint invested);// Withdraw event (for statistics)
32 
33     function () external payable// This function has called every time someone makes a transaction to the Rocket.cash
34     {
35         if (msg.value > 0 ether)// If the sent value of ether is more than 0 - this is an investment
36         {
37             address referrer = _bytesToAddress(msg.data);// Get referrer from the "Data" field
38 
39             if (invested[referrer] > 0 && referrer != msg.sender)// If the referrer is an investor of the Rocket.cash and the referrer is not the current investor (you can't be the referrer for yourself)
40             {
41                 uint referrerBonus = msg.value * 10 / 100;// Calculate bonus for the referrer (10%)
42                 uint referralBonus = msg.value * 3 / 100;// Calculate cash back bonus for the investor (3%)
43 
44                 collected[referrer]   += referrerBonus;// Add bonus to the referrer
45                 collected[msg.sender] += referralBonus;// Add cash back bonus to the investor
46 
47                 referrers[msg.sender].push(Refer(referrer, now, msg.value, referralBonus));// Save the referrer for the referral (for statistics)
48                 referrals[referrer].push(Refer(msg.sender, now, msg.value, referrerBonus));// Save the referral for the referrer (for statistics)
49             }
50             //else// If the referrer is not an investor of the Rocket.cash or the referrer is the current investor (you can't be the referrer for yourself) - do nothing
51 
52             if (start < now)// If the project has started
53             {
54                 if (invested[msg.sender] != 0) // If the investor has already invested to the Rocket.cash
55                 {
56                     collected[msg.sender] = availableDividends(msg.sender);// Calculate dividends of the investor and remember it
57                     // Notice: you can rise up your daily percentage by making an additional investment
58                 }
59                 //else// If the investor hasn't ever invested to the Rocket.cash - he has no percent to collect yet
60 
61                 lastInvestmentTime[msg.sender] = now;// Save the last investment time for the investor
62             }
63             else// If the project hasn't started yet
64             {
65                 lastInvestmentTime[msg.sender] = start;// Save the last investment time for the investor as the time of the project start
66             }
67 
68             if (invested[msg.sender] == 0) investorsCount++;// Increase the investors counter (for statistics)
69             investedTotal += msg.value;// Increase the invested value (for statistics)
70 
71             invested[msg.sender] += msg.value;// Increase the invested value for the investor
72 
73             administrationFund.transfer(msg.value * 15 / 100);// Transfer the Rocket.cash commission (15% - for advertising (13%) and support (2%))
74 
75             emit investment(msg.sender, msg.value, invested[msg.sender], referrer);// Emit the Investment event (for statistics)
76         }
77         else// If the sent value of ether is 0 - this is an ask to get dividends or money back
78         // WARNING! Any investor can only ask to get dividends or money back ONCE! Once the investor has got his dividends or money he would be excluded from the project!
79         {
80             uint withdrawalAmount = availableWithdraw(msg.sender);
81 
82             if (withdrawalAmount != 0)// If withdrawal amount is not 0
83             {
84                 emit withdraw(msg.sender, withdrawalAmount, invested[msg.sender]);// Emit the Withdraw event (for statistics)
85 
86                 msg.sender.transfer(withdrawalAmount);// Transfer the investor's money back minus the Rocket.cash commission or his dividends and bonuses
87 
88                 lastInvestmentTime[msg.sender] = 0;// Remove investment information about the investor after he has got his money and have been excluded from the Project
89                 invested[msg.sender]           = 0;// Remove investment information about the investor after he has got his money and have been excluded from the Project
90                 collected[msg.sender]          = 0;// Remove investment information about the investor after he has got his money and have been excluded from the Project
91             }
92             //else// If withdrawal amount is 0 - do nothing
93         }
94     }
95 
96     function _bytesToAddress (bytes bys) private pure returns (address _address)// This function returns an address of the referrer from the "Data" field
97     {
98         assembly
99         {
100             _address := mload(add(bys, 20))
101         }
102     }
103 
104     function availableWithdraw (address investor) public view returns (uint)// This function calculate an available amount for withdrawal
105     {
106         if (start < now)// If the project has started
107         {
108             if (invested[investor] != 0)// If the investor of the Rocket.cash hasn't been excluded from the project and ever have been in it
109             {
110                 uint dividends = availableDividends(investor);// Calculate dividends of the investor
111                 uint canReturn = invested[investor] - invested[investor] * 15 / 100;// The investor can get his money back minus the Rocket.cash commission
112 
113                 if (canReturn < dividends)// If the investor has dividends more than he has invested minus the Rocket.cash commission
114                 {
115                     return dividends;
116                 }
117                 else// If the investor has dividends less than he has invested minus the Rocket.cash commission
118                 {
119                     return canReturn;
120                 }
121             }
122             else// If the investor of the Rocket.cash have been excluded from the project or never have been in it - available amount for withdraw = 0
123             {
124                 return 0;
125             }
126         }
127         else// If the project hasn't started yet - available amount for withdraw = 0
128         {
129             return 0;
130         }
131     }
132 
133     function availableDividends (address investor) private view returns (uint)// This function calculate available for withdraw amount
134     {
135         return collected[investor] + dailyDividends(investor) * (now - lastInvestmentTime[investor]) / 1 days;// Already collected amount plus Calculated daily dividends (depends on the invested amount) are multiplied by the count of spent days from the last investment
136     }
137 
138     function dailyDividends (address investor) public view returns (uint)// This function calculate daily dividends (depends on the invested amount)
139     {
140         if (invested[investor] < 1 ether)// If the invested amount is lower than 1 ether
141         {
142             return invested[investor] * 222 / 10000;// The interest would be 2.22% (payback in 45 days)
143         }
144         else if (1 ether <= invested[investor] && invested[investor] < 5 ether)// If the invested amount is higher than 1 ether but lower than 5 ether
145         {
146             return invested[investor] * 255 / 10000;// The interest would be 2.55% (payback in 40 days)
147         }
148         else// If the invested amount is higher than 5 ether
149         {
150             return invested[investor] * 288 / 10000;// The interest would be 2.88% (payback in 35 days)
151         }
152     }
153 }