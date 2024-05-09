1 contract owned {
2     address public owner;
3 
4     function owned() {
5         owner = msg.sender;
6     }
7 
8     modifier onlyOwner {
9         if (msg.sender != owner) throw;
10         _
11     }
12 
13     function transferOwnership(address newOwner) onlyOwner {
14         owner = newOwner;
15     }
16 }
17 
18 //token contract used as reward
19 contract token {
20     mapping (address => uint256) public totalInvestmentOf;
21     function transfer(address receiver, uint amount){  }
22     function updateInvestmentTotal(address _to, uint256 _value){ }
23     function burnUnsoldCoins(address _removeCoinsFrom){ }
24 }
25 
26 contract Crowdsale is owned {
27     uint public amountRaised;
28     //20160 minutes (two weeks)
29     uint public deadline;
30     //1 token for 1 ETH week 1
31     uint public price = 1 ether;
32     //address of token used as reward
33     token public tokenReward;
34     Funder[] public funders;
35     event FundTransfer(address backer, uint amount, bool isContribution);
36     //crowdsale is open
37     bool crowdsaleClosed = false;
38     //countdown to week two price increase
39     uint weekTwoPriceRiseBegin = now + 10080 * 1 minutes;
40     //refund any remainders
41     uint remainderRefund;
42     uint amountAfterRefund;
43     //80/20 split
44     uint bankrollBeneficiaryAmount;
45     uint etherollBeneficiaryAmount;
46     //80% sent here at end of crowdsale
47     address public beneficiary;
48     //20% to etheroll
49     address etherollBeneficiary = 0x5de92686587b10cd47e03b71f2e2350606fcaf14;
50 
51     //data structure to hold information about campaign contributors
52     struct Funder {
53         address addr;
54         uint amount;
55     }
56 
57     //owner
58     function Crowdsale(
59         address ifSuccessfulSendTo,
60         uint durationInMinutes,
61         //uint etherCostOfEachToken,
62         token addressOfTokenUsedAsReward
63     ) {
64         beneficiary = ifSuccessfulSendTo;
65         deadline = now + durationInMinutes * 1 minutes;
66         //price = price;
67         tokenReward = token(addressOfTokenUsedAsReward);
68     }
69 
70 
71 
72     function () {
73         //crowdsale period is over
74         if(now > deadline) crowdsaleClosed = true;
75         if (crowdsaleClosed) throw;
76         uint amount = msg.value;
77 
78         //refund if value sent is below token price
79         if(amount < price) throw;
80 
81         //week 1 price
82         if(now < weekTwoPriceRiseBegin){
83             //return any ETH in case of remainder
84             remainderRefund = amount % price;
85             if(remainderRefund > 0){
86                 //quietly refund any spare change
87                 msg.sender.send(remainderRefund);
88                 amountAfterRefund = amount-remainderRefund;
89                 tokenReward.transfer(msg.sender, amountAfterRefund / price);
90                 amountRaised += amountAfterRefund;
91                 funders[funders.length++] = Funder({addr: msg.sender, amount: amountAfterRefund});
92                 tokenReward.updateInvestmentTotal(msg.sender, amountAfterRefund);
93                 FundTransfer(msg.sender, amountAfterRefund, true);
94             }
95 
96             //same but no remainder
97             if(remainderRefund == 0){
98                  amountRaised += amount;
99                  tokenReward.transfer(msg.sender, amount / price);
100                  funders[funders.length++] = Funder({addr: msg.sender, amount: amount});
101                  tokenReward.updateInvestmentTotal(msg.sender, amount);
102                  FundTransfer(msg.sender, amount, true);
103             }
104         }
105 
106         //week 2 price
107         if(now >= weekTwoPriceRiseBegin){
108             //price rise in week two
109             //1 token for 1.5ETH
110             if(price == 1 ether){price = (price*150)/100;}
111             //tokenReward.transfer(msg.sender, amount / price, amount);
112             //return any ETH in case of remainder
113             remainderRefund = amount % price;
114             if(remainderRefund > 0){
115                 //quietly refund any spare change
116                 msg.sender.send(remainderRefund);
117                 amountAfterRefund = amount-remainderRefund;
118                 tokenReward.transfer(msg.sender, amountAfterRefund / price);
119                 amountRaised += amountAfterRefund;
120                 funders[funders.length++] = Funder({addr: msg.sender, amount: amountAfterRefund});
121                 tokenReward.updateInvestmentTotal(msg.sender, amountAfterRefund);
122                 FundTransfer(msg.sender, amountAfterRefund, true);
123             }
124 
125             //same but no remainder
126             if(remainderRefund == 0){
127                  tokenReward.transfer(msg.sender, amount / price);
128                  amountRaised += amount;
129                  funders[funders.length++] = Funder({addr: msg.sender, amount: amount});
130                  tokenReward.updateInvestmentTotal(msg.sender, amount);
131                  FundTransfer(msg.sender, amount, true);
132             }
133         }
134     }
135 
136     //modifier for only after end of crowdsale
137     modifier afterDeadline() { if (now >= deadline) _ }
138 
139     //modifier for only after week 1 price rise
140     modifier afterPriceRise() { if (now >= weekTwoPriceRiseBegin) _ }
141 
142     /*checks if the time limit has been reached and ends the campaign
143     anybody can call this after the deadline
144     80% of funds sent to final etheroll bankroll SC
145     20% of funds  sent to an address for etheroll salaries*/
146     function checkGoalReached() afterDeadline {
147         //house bankroll receives 80%
148         bankrollBeneficiaryAmount = (amountRaised*80)/100;
149         beneficiary.send(bankrollBeneficiaryAmount);
150         FundTransfer(beneficiary, bankrollBeneficiaryAmount, false);
151         //etheroll receives 20%
152         etherollBeneficiaryAmount = (amountRaised*20)/100;
153         etherollBeneficiary.send(etherollBeneficiaryAmount);
154         FundTransfer(etherollBeneficiary, etherollBeneficiaryAmount, false);
155         etherollBeneficiary.send(this.balance); // send any remaining balance to etherollBeneficiary anyway
156         //burn any remaining unsold coins
157         //tokenReward.burnUnsoldCoins();
158         crowdsaleClosed = true;
159     }
160 
161     //update token price week two
162     //this does happen automatically when someone purchases tokens week 2
163     //but nice to update for users
164     function updateTokenPriceWeekTwo() afterPriceRise {
165         //funky price updates
166         if(price == 1 ether){price = (price*150)/100;}
167     }
168 
169     function burnCoins(address _removeCoinsFrom)
170         onlyOwner
171     {
172         tokenReward.burnUnsoldCoins(_removeCoinsFrom);
173     }
174 
175     //in case of absolute emergency
176     //returns all funds to investors
177     //divestment schedule is better in the beneficiary contract as no gas limit concerns
178     function returnFunds()
179         onlyOwner
180     {
181         for (uint i = 0; i < funders.length; ++i) {
182           funders[i].addr.send(funders[i].amount);
183           FundTransfer(funders[i].addr, funders[i].amount, false);
184         }
185     }
186 
187 }