1 pragma solidity 0.4.25;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
10         uint256 c = a * b;
11         assert(a == 0 || c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure returns(uint256) {
16         // assert(b > 0); // Solidity automatically throws when dividing by 0
17         uint256 c = a / b;
18         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19         return c;
20     }
21 
22     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
23         assert(b <= a);
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal pure returns(uint256) {
28         uint256 c = a + b;
29         assert(c >= a);
30         return c;
31     }
32 
33 }
34 
35 /**
36  * In the event of the shortage of funds for the level payments
37  * stabilization the contract of the stabilization fund provides backup support to the investment fund. 
38  */
39 contract EtherheroStabilizationFund {
40 
41     address public etherHero;
42     uint public investFund;
43     uint estGas = 200000;
44     event MoneyWithdraw(uint balance);
45     event MoneyAdd(uint holding);
46 
47     constructor() public {
48         etherHero = msg.sender;
49     }
50     /**
51      * @dev Throws if called by any account other than the owner.
52      */
53     modifier onlyHero() {
54         require(msg.sender == etherHero, 'Only Hero call');
55         _;
56     }
57 
58     function ReturnEthToEtherhero() public onlyHero returns(bool) {
59 
60         uint balance = address(this).balance;
61         require(balance > estGas, 'Not enough funds for transaction');
62 
63         if (etherHero.call.value(address(this).balance).gas(estGas)()) {
64             emit MoneyWithdraw(balance);
65             investFund = address(this).balance;
66             return true;
67         } else {
68             return false;
69         }
70     }
71 
72     function() external payable {
73         investFund += msg.value;
74         emit MoneyAdd(msg.value);
75     }
76 }
77 
78 contract Etherhero{
79 
80     using SafeMath
81     for uint;
82     // array containing information about beneficiaries
83     mapping(address => uint) public userDeposit;
84     //array containing information about the time of payment
85     mapping(address => uint) public userTime;
86     //fund fo transfer percent
87     address public projectFund = 0xf846f84841b3242Ccdeac8c43C9cF73Bd781baA7;
88     EtherheroStabilizationFund public stubF = new EtherheroStabilizationFund();
89     uint public percentProjectFund = 10;
90     uint public percentDevFund = 1;
91     uint public percentStubFund = 10;
92     address public addressStub;
93     //Gas cost
94     uint estGas = 150000;
95     uint standartPercent = 30; //3%
96     uint responseStubFundLimit = 150; //15%
97     uint public minPayment = 5 finney;
98     //time through which you can take dividends
99     uint chargingTime = 1 days;
100 
101     event NewInvestor(address indexed investor, uint deposit);
102     event dividendPayment(address indexed investor, uint value);
103     event NewDeposit(address indexed investor, uint value);
104 
105     //public variables for DAPP
106     uint public counterDeposits;
107     uint public counterPercents;
108     uint public counterBeneficiaries;
109     uint public timeLastayment;
110 
111     //Memory for user for DAPP
112     struct Beneficiaries {
113         address investorAddress;
114         uint registerTime;
115         uint percentWithdraw;
116         uint ethWithdraw;
117         uint deposits;
118         bool real;
119     }
120 
121     mapping(address => Beneficiaries) beneficiaries;
122 
123     constructor() public {
124         addressStub = stubF;
125     }
126     //Add beneficiary record
127     function insertBeneficiaries(address _address, uint _percentWithdraw, uint _ethWithdraw, uint _deposits) private {
128 
129         Beneficiaries storage s_beneficiaries = beneficiaries[_address];
130 
131         if (!s_beneficiaries.real) {
132             s_beneficiaries.real = true;
133             s_beneficiaries.investorAddress = _address;
134             s_beneficiaries.percentWithdraw = _percentWithdraw;
135             s_beneficiaries.ethWithdraw = _ethWithdraw;
136             s_beneficiaries.deposits = _deposits;
137             s_beneficiaries.registerTime = now;
138             counterBeneficiaries += 1;
139         } else {
140             s_beneficiaries.percentWithdraw += _percentWithdraw;
141             s_beneficiaries.ethWithdraw += _ethWithdraw;
142         }
143     }
144     
145     //Get beneficiary record
146     function getBeneficiaries(address _address) public view returns(address investorAddress, uint persentWithdraw, uint ethWithdraw, uint registerTime) {
147 
148         Beneficiaries storage s_beneficiaries = beneficiaries[_address];
149 
150         require(s_beneficiaries.real, 'Investor Not Found');
151 
152         return (
153             s_beneficiaries.investorAddress,
154             s_beneficiaries.percentWithdraw,
155             s_beneficiaries.ethWithdraw,
156             s_beneficiaries.registerTime
157         );
158     }
159 
160     modifier isIssetUser() {
161         require(userDeposit[msg.sender] > 0, "Deposit not found");
162         _;
163     }
164 
165     modifier timePayment() {
166         require(now >= userTime[msg.sender].add(chargingTime), "Too fast payout request");
167         _;
168     }
169 
170     function calculationOfPayment() public view returns(uint) {
171         uint interestRate = now.sub(userTime[msg.sender]).div(chargingTime);
172         //If the contribution is less than 1 ether, dividends can be received only once a day
173         if (userDeposit[msg.sender] < 10 ether) {
174             if (interestRate >= 1) {
175                 return (1);
176             } else {
177                 return (interestRate);
178             }
179         }
180         //If the contribution is less than 10 ether, dividends can be received only once a 3 day
181         if (userDeposit[msg.sender] >= 10 ether && userDeposit[msg.sender] < 50 ether) {
182             if (interestRate > 3) {
183                 return (3);
184             } else {
185                 return (interestRate);
186             }
187         }
188         //If the contribution is less than 50 ether, dividends can be received only once a 7 day
189         if (userDeposit[msg.sender] >= 50 ether) {
190             if (interestRate > 7) {
191                 return (7);
192             } else {
193                 return (interestRate);
194             }
195         }
196     }
197     
198     function receivePercent() isIssetUser timePayment internal {
199        // verification that funds on the balance sheet are more than 15% of the total number of deposits
200         uint balanceLimit = counterDeposits.mul(responseStubFundLimit).div(1000);
201         uint payoutRatio = calculationOfPayment();
202         //calculate 6% of total deposits
203         uint remain = counterDeposits.mul(6).div(100);
204         
205         if(addressStub.balance > 0){
206             if (address(this).balance < balanceLimit) {
207                 stubF.ReturnEthToEtherhero();
208             }
209         }
210         //If the balance is less than 6% of total deposits, stop paying
211         require(address(this).balance >= remain, 'contract balance is too small');
212 
213         uint rate = userDeposit[msg.sender].mul(standartPercent).div(1000).mul(payoutRatio);
214         userTime[msg.sender] = now;
215         msg.sender.transfer(rate);
216         counterPercents += rate;
217         timeLastayment = now;
218         insertBeneficiaries(msg.sender, standartPercent, rate, 0);
219         emit dividendPayment(msg.sender, rate);
220     }
221 
222     function makeDeposit() private {
223         uint value = msg.value;
224         uint calcProjectPercent = value.mul(percentProjectFund).div(100);
225         uint calcStubFundPercent = value.mul(percentStubFund).div(100);
226         
227         if (msg.value > 0) {
228             //check for minimum deposit 
229             require(msg.value >= minPayment, 'Minimum deposit 1 finney');
230             
231             if (userDeposit[msg.sender] == 0) {
232                 emit NewInvestor(msg.sender, msg.value);
233             }
234             
235             userDeposit[msg.sender] = userDeposit[msg.sender].add(msg.value);
236             userTime[msg.sender] = now;
237             insertBeneficiaries(msg.sender, 0, 0, msg.value);
238             projectFund.transfer(calcProjectPercent);
239             stubF.call.value(calcStubFundPercent).gas(estGas)();
240             counterDeposits += msg.value;
241             emit NewDeposit(msg.sender, msg.value);
242         } else {
243             receivePercent();
244         }
245     }
246 
247     function() external payable {
248         if (msg.sender != addressStub) {
249             makeDeposit();
250         }
251     }
252 }