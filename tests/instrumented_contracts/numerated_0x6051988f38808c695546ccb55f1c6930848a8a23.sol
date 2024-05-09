1 pragma solidity ^0.4.25;
2 
3 /** KPI is 100k USD (~ETH rate fix at start of contract) target selling period is 45 days*/
4 
5 /** If NCryptBit reached 100k before 45 days -> payoff immediately 10% commission through `claim` function */
6 
7 /** 
8 Pay 4k USD (in ETH) first installment of comission fee immediately after startTime (confirm purchased) `ONE day` (through claimFirstInstallment())
9 
10 Remaining installment fee will be paid dependTime on KPI below:
11     
12     - Trunk payment period when reach partial KPI
13         * 0 -> 15 date reach >=25k -> 1/3 Remaining Installment Fee (~2k USD)
14         * 15 -> 30 date reach >=25k -> 1/3 Remaining Installment Fee (~2k USD)
15         * 45  reach >=25k -> 1/3 Remaining Installment Fee (~2k USD)
16         
17     NOTE: Remaining ETH will refund to Triip through `refund` function at endTime of this campaign
18 */
19 
20 contract TriipInvestorsServices {
21 
22     event ConfirmPurchase(address _sender, uint _startTime, uint _amount);
23 
24     event Payoff(address _seller, uint _amount, uint _kpi);
25     
26     event Refund(address _buyer, uint _amount);
27 
28     event Claim(address _sender, uint _counting, uint _buyerWalletBalance);
29 
30     enum PaidStage {
31         NONE,
32         FIRST_PAYMENT,
33         SECOND_PAYMENT,
34         FINAL_PAYMENT
35     }
36 
37     uint public KPI_0k = 0;
38     uint public KPI_25k = 25;
39     uint public KPI_50k = 50;
40     uint public KPI_100k = 100;    
41     
42     address public seller; // NCriptBit
43     address public buyer;  // Triip Protocol wallet use for refunding
44     address public buyerWallet; // Triip Protocol's raising ETH wallet
45     
46     uint public startTime = 0;
47     uint public endTime = 0;
48     bool public isEnd = false;    
49 
50     uint decimals = 18;
51     uint unit = 10 ** decimals;
52     
53     uint public paymentAmount = 69 * unit;                // 69 ETH equals to 10k USD upfront, fixed at deploy of contract manually
54     uint public targetSellingAmount = 10 * paymentAmount; // 690 ETH equals to 100k USD upfront
55     
56     uint claimCounting = 0;
57 
58     PaidStage public paidStage = PaidStage.NONE;
59 
60     uint public balance;
61 
62     // Begin: only for testing
63 
64     // function setPaymentAmount(uint _paymentAmount) public returns (bool) {
65     //     paymentAmount = _paymentAmount;
66     //     return true;
67     // }
68 
69     // function setStartTime(uint _startTime) public returns (bool) {
70     //     startTime = _startTime;
71     //     return true;
72     // }
73 
74     // function setEndTime(uint _endTime) public returns (bool) {
75     //     endTime = _endTime;
76     //     return true;
77     // }
78 
79     // function getNow() public view returns (uint) {
80     //     return now;
81     // }
82 
83     // End: only for testing
84 
85     constructor(address _buyer, address _seller, address _buyerWallet) public {
86 
87         seller = _seller;
88         buyer = _buyer;
89         buyerWallet = _buyerWallet;
90 
91     }
92 
93     modifier whenNotEnd() {
94         require(!isEnd, "This contract should not be endTime") ;
95         _;
96     }
97 
98     function confirmPurchase() public payable { // Trigger by Triip with the ETH amount agreed for installment
99 
100         require(startTime == 0);
101 
102         require(msg.value == paymentAmount, "Not equal installment fee");
103 
104         startTime = now;
105 
106         endTime = startTime + ( 45 * 1 days );
107 
108         balance += msg.value;
109 
110         emit ConfirmPurchase(msg.sender, startTime, balance);
111     }
112 
113     function contractEthBalance() public view returns (uint) {
114 
115         return balance;
116     }
117 
118     function buyerWalletBalance() public view returns (uint) {
119         
120         return address(buyerWallet).balance;
121     }
122 
123     function claimFirstInstallment() public whenNotEnd returns (bool) {
124 
125         require(paidStage == PaidStage.NONE, "First installment has already been claimed");
126 
127         require(now >= startTime + 1 days, "Require first installment fee to be claimed after startTime + 1 day");
128 
129         uint payoffAmount = balance * 40 / 100; // 40% of agreed commission
130 
131         // update balance
132         balance = balance - payoffAmount; // ~5k gas as of writing
133 
134         seller.transfer(payoffAmount); // ~21k gas as of writing
135 
136         emit Payoff(seller, payoffAmount, KPI_0k );
137         emit Claim(msg.sender, claimCounting, buyerWalletBalance());
138 
139         return true;
140     }
141     
142     function claim() public whenNotEnd returns (uint) {
143 
144         claimCounting = claimCounting + 1;
145 
146         uint payoffAmount = 0;
147 
148         uint sellingAmount  = targetSellingAmount;
149         uint buyerBalance = buyerWalletBalance();
150 
151         emit Claim(msg.sender, claimCounting, buyerWalletBalance());
152         
153         if ( buyerBalance >= sellingAmount ) {
154 
155             payoffAmount = balance;
156 
157             seller.transfer(payoffAmount);
158             paidStage = PaidStage.FINAL_PAYMENT;
159 
160             balance = 0;
161             endContract();
162 
163             emit Payoff(seller, payoffAmount, KPI_100k);
164 
165         }
166         else {
167             payoffAmount = claimByKPI();
168 
169         }
170 
171         return payoffAmount;
172     }
173 
174     function claimByKPI() private returns (uint) {
175 
176         uint payoffAmount = 0;
177         uint sellingAmount = targetSellingAmount;
178         uint buyerBalance = buyerWalletBalance();
179 
180         if ( buyerBalance >= ( sellingAmount * KPI_50k / 100) 
181             && now >= (startTime + ( 30 * 1 days) )
182             ) {
183 
184             uint paidPercent = 66;
185 
186             if ( paidStage == PaidStage.NONE) {
187                 paidPercent = 66; // 66% of 6k installment equals 4k
188             }else if( paidStage == PaidStage.FIRST_PAYMENT) {
189                 // 33 % of total balance
190                 // 50% of remaining balance
191                 paidPercent = 50;
192             }
193 
194             payoffAmount = balance * paidPercent / 100;
195 
196             // update balance
197             balance = balance - payoffAmount;
198 
199             seller.transfer(payoffAmount);
200 
201             emit Payoff(seller, payoffAmount, KPI_50k);
202 
203             paidStage = PaidStage.SECOND_PAYMENT;
204         }
205 
206         if( buyerBalance >= ( sellingAmount * KPI_25k / 100) 
207             && now >= (startTime + (15 * 1 days) )
208             && paidStage == PaidStage.NONE ) {
209 
210             payoffAmount = balance * 33 / 100;
211 
212             // update balance
213             balance = balance - payoffAmount;
214 
215             seller.transfer(payoffAmount);
216 
217             emit Payoff(seller, payoffAmount, KPI_25k );
218 
219             paidStage = PaidStage.FIRST_PAYMENT;
220 
221         }
222 
223         if(now >= (startTime + (45 * 1 days) )) {
224 
225             endContract();
226         }
227 
228         return payoffAmount;
229     }
230 
231     function endContract() private {
232         isEnd = true;
233     }
234     
235     function refund() public returns (uint) {
236 
237         require(now >= endTime);
238 
239         // refund remaining balance
240         uint refundAmount = address(this).balance;
241 
242         buyer.transfer(refundAmount);
243 
244         emit Refund(buyer, refundAmount);
245 
246         return refundAmount;
247     }
248 }