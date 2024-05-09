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
17     uint public investedTotal;// Invested sum (for statistics)
18     uint public investorsCount;// Investors count (for statistics)
19 
20     event investment(address addr, uint amount, uint invested);// Investment event (for statistics)
21     event withdraw(address addr, uint amount, uint invested);// Withdraw event (for statistics)
22 
23     function () external payable// This function has called every time someone makes a transaction to the Rocket.cash
24     {
25         if (msg.value > 0 ether)// If the sent value of ether is more than 0 - this is an investment
26         {
27             if (start < now)// If the project has started
28             {
29                 if (invested[msg.sender] != 0) // If the investor has already invested to the Rocket.cash
30                 {
31                     collected[msg.sender] = availableDividends(msg.sender);// Calculate dividends of the investor and remember it
32                     // Notice: you can rise up your daily percentage by making an additional investment
33                 }
34                 //else// If the investor hasn't ever invested to the Rocket.cash - he has no percent to collect yet
35 
36                 lastInvestmentTime[msg.sender] = now;// Save the last investment time for the investor
37             }
38             else// If the project hasn't started yet
39             {
40                 lastInvestmentTime[msg.sender] = start;// Save the last investment time for the investor as the time of the project start
41             }
42 
43             if (invested[msg.sender] == 0) investorsCount++;// Increase the investors counter (for statistics)
44             investedTotal += msg.value;// Increase the invested value (for statistics)
45 
46             invested[msg.sender] += msg.value;// Increase the invested value for the investor
47 
48             administrationFund.transfer(msg.value * 15 / 100);// Transfer the Rocket.cash commission (15% - for advertising (13%) and support (2%))
49 
50             emit investment(msg.sender, msg.value, invested[msg.sender]);// Emit the Investment event (for statistics)
51         }
52         else// If the sent value of ether is 0 - this is an ask to get dividends or money back
53         // WARNING! Any investor can only ask to get dividends or money back ONCE! Once the investor has got his dividends or money he would be excluded from the project!
54         {
55             uint withdrawalAmount = availableWithdraw(msg.sender);
56 
57             if (withdrawalAmount != 0)// If withdrawal amount is not 0
58             {
59                 emit withdraw(msg.sender, withdrawalAmount, invested[msg.sender]);// Emit the Withdraw event (for statistics)
60 
61                 msg.sender.transfer(withdrawalAmount);// Transfer the investor's money back minus the Rocket.cash commission or his dividends and bonuses
62 
63                 lastInvestmentTime[msg.sender] = 0;// Remove investment information about the investor after he has got his money and have been excluded from the Project
64                 invested[msg.sender]           = 0;// Remove investment information about the investor after he has got his money and have been excluded from the Project
65                 collected[msg.sender]          = 0;// Remove investment information about the investor after he has got his money and have been excluded from the Project
66             }
67             //else// If withdrawal amount is 0 - do nothing
68         }
69     }
70 
71     function availableWithdraw (address investor) public view returns (uint)// This function calculate an available amount for withdrawal
72     {
73         if (start < now)// If the project has started
74         {
75             if (invested[investor] != 0)// If the investor of the Rocket.cash hasn't been excluded from the project and ever have been in it
76             {
77                 uint dividends = availableDividends(investor);// Calculate dividends of the investor
78                 uint canReturn = invested[investor] - invested[investor] * 15 / 100;// The investor can get his money back minus the Rocket.cash commission
79 
80                 if (canReturn < dividends)// If the investor has dividends more than he has invested minus the Rocket.cash commission
81                 {
82                     return dividends;
83                 }
84                 else// If the investor has dividends less than he has invested minus the Rocket.cash commission
85                 {
86                     return canReturn;
87                 }
88             }
89             else// If the investor of the Rocket.cash have been excluded from the project or never have been in it - available amount for withdraw = 0
90             {
91                 return 0;
92             }
93         }
94         else// If the project hasn't started yet - available amount for withdraw = 0
95         {
96             return 0;
97         }
98     }
99 
100     function availableDividends (address investor) private view returns (uint)// This function calculate available for withdraw amount
101     {
102         return collected[investor] + dailyDividends(investor) * (now - lastInvestmentTime[investor]) / 1 days;// Already collected amount plus Calculated daily dividends (depends on the invested amount) are multiplied by the count of spent days from the last investment
103     }
104 
105     function dailyDividends (address investor) public view returns (uint)// This function calculate daily dividends (depends on the invested amount)
106     {
107         if (invested[investor] < 1 ether)// If the invested amount is lower than 1 ether
108         {
109             return invested[investor] * 222 / 10000;// The interest would be 2.22% (payback in 45 days)
110         }
111         else if (1 ether <= invested[investor] && invested[investor] < 5 ether)// If the invested amount is higher than 1 ether but lower than 5 ether
112         {
113             return invested[investor] * 255 / 10000;// The interest would be 2.55% (payback in 40 days)
114         }
115         else// If the invested amount is higher than 5 ether
116         {
117             return invested[investor] * 288 / 10000;// The interest would be 2.88% (payback in 35 days)
118         }
119     }
120 }