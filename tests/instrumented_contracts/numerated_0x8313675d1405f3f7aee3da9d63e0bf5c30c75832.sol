1 /*
2 * ETHEREUM SMARTCONTRACT - ALTES FINANCE GROUP PTY LTD
3 *
4 * - Plans with daily payments! Receive from 1.5% to 2% of the amount of your deposit within 24 hours (every 86400 seconds)
5 * - Plans with capitalization, the body of the contribution and the profit returned at the end of the term. Receive from 1.5% to 2% of the amount of your deposit, for a period of 1 month to 3
6 * - reliable and unique project
7 * - minimum deposit 0.6 ETH
8 * - minimum payout 0.01 ETH
9 * - Currency and payment - ETH
10 * - !!! You cannot transfer from exchanges, only from your personal ETH wallet !!!
11 * - Distribution schemes for contributions:
12 * - 90% on payments on deposits
13 * - 10% for advertising and contract support + Operating expenses
14 *
15 *
16 * You can check payments on the etherscan.io website, on the “Internal Txns” tab of your wallet.
17 *
18 *
19 * The contract has been reviewed and approved by professionals!
20 *
21 * Contracts reviewed and approved by pros!
22 */
23 
24 pragma solidity ^0.4.25;
25 
26 contract ALTESFINANCEGROUP {
27 
28     struct Investor
29     {
30         uint amount; //amount of deposit
31         uint dateUpdate; //date of deposit
32         uint dateEnd;
33         address refer; //address of referrer
34         bool active; //he has deposit
35         bool typePlan;
36     }
37 
38     uint256 constant private MINIMUM_INVEST = 0.6 ether; //minimal amount for deposit
39     uint256 constant private MINIMUM_PAYMENT = 0.01 ether; //minimal amount for withdrawal
40     uint constant private PERCENT_FOR_ADMIN = 10; //fee for admin
41     uint constant private PERCENT_FOR_REFER = 5; //fee for refer
42     uint constant private PROFIT_PERIOD = 86400; //time of create profit, every 1 dey
43     address constant private ADMIN_ADDRESS = 0x2803Ef1dFF52D6bEDE1B2714A8Dd4EA82B8aE733; //fee for refer
44 
45     mapping(address => Investor) investors; //investors list
46 
47     event Transfer (address indexed _to, uint256 indexed _amount);
48 
49     constructor () public {
50     }
51 
52     /**
53      * This function calculated percent
54      */
55     function getPercent(Investor investor) private pure returns (uint256) {
56         uint256 amount = investor.amount;
57 
58         if (amount >= 0.60 ether && amount <= 5.99 ether) {
59             return 150;
60         } else if (amount >= 29 ether && amount <= 58.99 ether) {
61             return 175;
62         } else if (amount >= 119 ether && amount <= 298.99 ether) {
63             return 200;
64         } else if (amount >= 6 ether && amount <= 28.99 ether) {
65             return 38189;
66         } else if (amount >= 59.99 ether && amount <= 118.99 ether) {
67             return 28318;
68         } else if (amount >=  299.99 ether && amount <= 600 ether) {
69             return 18113;
70         }
71         return 0;
72     }
73 
74     function getDate(Investor investor) private view returns (uint256) {
75         uint256 amount = investor.amount;
76         if (amount >= 0.60 ether && amount <= 5.99 ether) {
77             return PROFIT_PERIOD * 120 + now;
78         } else if (amount >= 29 ether && amount <= 58.99 ether) {
79             return PROFIT_PERIOD * 150 + now;
80         } else if (amount >= 119 ether && amount <= 298.99 ether) {
81             return PROFIT_PERIOD * 180 + now;
82         } else if (amount >= 6 ether && amount <= 28.99 ether) {
83             return PROFIT_PERIOD * 90 + now;
84         } else if (amount >= 59.99 ether && amount <= 118.99 ether) {
85             return PROFIT_PERIOD * 60 + now;
86         } else if (amount >=  299.99 ether && amount <= 600 ether) {
87             return PROFIT_PERIOD * 30 + now;
88         }
89         return 0;
90     }
91 
92     function getTypePlan(Investor investor) private pure returns (bool) {
93         uint256 amount = investor.amount;
94         if (amount >= 0.60 ether && amount <= 5.99 ether) {
95             return false;
96         } else if (amount >= 29 ether && amount <= 58.99 ether) {
97             return false;
98         } else if (amount >= 119 ether && amount <= 298.99 ether) {
99             return false;
100         } else if (amount >= 6 ether && amount <= 28.99 ether) {
101             return true;
102         } else if (amount >= 59.99 ether && amount <= 118.99 ether) {
103             return true;
104         } else if (amount >=  299.99 ether && amount <= 600 ether) {
105             return true;
106         }
107         return false;
108     }
109 
110     /**
111      * This function calculated the remuneration for the administrator
112      */
113     function getFeeForAdmin(uint256 amount) private pure returns (uint256) {
114         return amount * PERCENT_FOR_ADMIN / 100;
115     }
116 
117     /**
118      * This function calculated the remuneration for the refer
119      */
120     function getFeeForRefer(uint256 amount) private pure returns (uint256) {
121         return amount * PERCENT_FOR_REFER / 100;
122     }
123 
124     /**
125      * This function calculated the remuneration for the administrator
126      */
127     function getRefer(bytes bys) public pure returns (address addr) {
128         assembly {
129             addr := mload(add(bys, 20))
130         }
131     }
132 
133     function getProfit(Investor investor) private view returns (uint256) {
134         uint256 amountProfit = 0;
135         if (!investor.typePlan) {
136             if (now >= investor.dateEnd) {
137                 amountProfit = investor.amount * getPercent(investor) * (investor.dateEnd - investor.dateUpdate) / (PROFIT_PERIOD * 10000);
138             } else {
139                 amountProfit = investor.amount * getPercent(investor) * (now - investor.dateUpdate) / (PROFIT_PERIOD * 10000);
140             }
141         } else {
142             amountProfit = investor.amount / 10000 * getPercent(investor);
143         }
144         return amountProfit;
145     }
146 
147 
148     /**
149      * Main function
150      */
151     function() external payable {
152         uint256 amount = msg.value;
153         //amount to deposit
154         address userAddress = msg.sender;
155         //address of sender
156         address referAddress = getRefer(msg.data);
157         //refer or empty
158 
159         require(amount == 0 || amount >= MINIMUM_INVEST, "Min Amount for investing is MINIMUM_INVEST.");
160 
161         //check Profit
162         if (amount == 0 && investors[userAddress].active) {
163             //profit
164             require(!investors[userAddress].typePlan && now <= investors[userAddress].dateEnd, 'the Deposit is not finished');
165 
166             uint256 amountProfit = getProfit(investors[userAddress]);
167             require(amountProfit > MINIMUM_PAYMENT, 'amountProfit must be > MINIMUM_PAYMENT');
168 
169             if (now >= investors[userAddress].dateEnd) {
170                 investors[userAddress].active = false;
171             }
172 
173             investors[userAddress].dateUpdate = now;
174 
175             userAddress.transfer(amountProfit);
176             emit Transfer(userAddress, amountProfit);
177 
178         } else if (amount >= MINIMUM_INVEST && !investors[userAddress].active) {//if this deposit request
179             //fee admin
180             ADMIN_ADDRESS.transfer(getFeeForAdmin(amount));
181             emit Transfer(ADMIN_ADDRESS, getFeeForAdmin(amount));
182 
183             investors[userAddress].active = true;
184             investors[userAddress].dateUpdate = now;
185             investors[userAddress].amount = amount;
186             investors[userAddress].dateEnd = getDate(investors[userAddress]);
187             investors[userAddress].typePlan = getTypePlan(investors[userAddress]);
188 
189 
190             //if refer exist
191             if (investors[referAddress].active && referAddress != address(0)) {
192                 investors[userAddress].refer = referAddress;
193             }
194 
195             //send refer fee
196             if (investors[userAddress].refer != address(0)) {
197                 investors[userAddress].refer.transfer(getFeeForRefer(amount));
198                 emit Transfer(investors[userAddress].refer, getFeeForRefer(amount));
199             }
200         }
201     }
202 
203     /**
204      * This function show deposit
205      */
206     function showDeposit(address _deposit) public view returns (uint256) {
207         return investors[_deposit].amount;
208     }
209 
210     /**
211      * This function show block of last change
212      */
213     function showLastChange(address _deposit) public view returns (uint256) {
214         return investors[_deposit].dateUpdate;
215     }
216 
217     /**
218      * This function show unpayed percent of deposit
219      */
220     function showUnpayedPercent(address _deposit) public view returns (uint256) {
221         uint256 amount = getProfit(investors[_deposit]);
222         return amount;
223     }
224 
225 
226 }