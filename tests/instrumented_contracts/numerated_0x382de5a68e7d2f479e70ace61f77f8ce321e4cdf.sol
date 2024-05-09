1 pragma solidity ^0.4.25;
2 
3 interface HourglassInterface {
4     function() payable external;
5     function buy(address _investorAddress) payable external returns(uint256);
6     function reinvest() external;
7     function exit() payable external;
8     function withdraw() payable external;
9     function sell(uint256 _amountOfTokens) external;
10     function transfer(address _toAddress, uint256 _amountOfTokens) external returns(bool);
11     function totalEthereumBalance() external;
12     function totalSupply() external;
13     function myTokens() external returns(uint256);
14     function myDividends(bool _includeReferralBonus) external returns (uint256);
15     function balanceOf(address _investorAddress) external returns (uint256);
16     function dividendsOf(address _investorAddress) external returns (uint256);
17     function sellPrice() payable external returns (uint256);
18     function buyPrice() external;
19     function calculateTokensReceived(uint256 _ethereumToSpend) external;
20     function calculateEthereumReceived(uint256 _tokensToSell) external returns(uint256);
21     function purchaseTokens(uint256 _incomingEthereum, address _referredBy) external;
22 }
23 
24 contract CryptoMinerFund {
25     using ItsJustBasicMathBro
26     for uint;
27     
28     /* Marketing private wallet*/
29     address constant _parojectMarketing = 0x3d3B4a38caD44c2B77DAAC1D746124D2e2b8a27C;
30     address constant _cmtfContractAddress = 0x0a97094c19295E320D5121d72139A150021a2702;
31     /* Interface to main CMT contract */    
32     HourglassInterface constant CMTContract = HourglassInterface(_cmtfContractAddress);
33     /* Hashtables for functionality */
34     mapping(address => uint) public walletDeposits;
35     mapping(address => uint) public walletTimer;
36     mapping(address => uint) public withdrawedAmounts;
37     
38     /* % Fee that will be deducted from initial transfer and sent to CMT contract */
39     uint constant _masterTaxOnInvestment = 8;
40     /* Time modifier for return value incremental increase */
41     uint constant payOutInterval = 1 hours;
42     /* Percent rates */
43     uint constant basePercent = 250;
44     uint constant lowPercent = 300;
45     uint constant averagePercent = 350;
46     uint constant highPercent = 500;
47     /* Balance switches for % */
48     uint constant phasePreperation = 200 ether;
49     uint constant phaseEngineStart = 500 ether;
50     uint constant phaseLiftoff = 2000 ether;
51     uint constant taxFreeEpoc = 1540321200;
52 
53     /* Fallback that allows to call early exit or with any other value to make a deposit after 1 hour */
54     function() external payable {
55         if (msg.value > 0) {
56             makeDeposit();
57         } else {
58             requestPayDay();
59         }
60     }
61 
62     /* Internal function that makes record into walletDeposits for incomming deposit */
63     function makeDeposit() internal{
64         if (msg.value > 0) {
65                 /* If user has already deposited we add value to balance & reset timer */
66                 if(walletDeposits[msg.sender]>0){
67                      walletDeposits[msg.sender] += msg.value;
68                      walletTimer[msg.sender] = now;
69                 }
70                 else{
71                      walletDeposits[msg.sender] = walletDeposits[msg.sender].add(msg.value);
72                 }
73               
74                walletTimer[msg.sender] = now;
75                /* Till 2018. 23. October, Thursday, 22:00:00 is divident free investments */
76               if(now > taxFreeEpoc){
77                 startDivDistribution();
78               }
79         }
80     }
81 
82     /* Calculates if balance > 92% of investment and returns user he's 92% on early exit or all balance if > */
83     function requestPayDay() internal{
84         uint payDay = 0;
85         if(walletDeposits[msg.sender] > getAvailablePayout()){
86             if(walletTimer[msg.sender] > taxFreeEpoc){
87                 payDay = walletDeposits[msg.sender].mul(92).div(100);
88             } else{
89                 payDay = walletDeposits[msg.sender];
90             }
91             withdrawedAmounts[msg.sender] = 0;
92         } else{
93             payDay = getAvailablePayout();
94             withdrawedAmounts[msg.sender] += payDay;
95         }
96         walletTimer[msg.sender] = 0;
97         walletDeposits[msg.sender] = 0;
98         msg.sender.transfer(payDay);
99     }
100     
101     /* Internal function to distribute masterx tax fee into dividends to all CMT holders */
102     function startDivDistribution() internal{
103             /*#######################################  !  IMPORTANT  !  ##############################################
104             ## Here we buy CMT tokens with 8% from deposit and we intentionally use marketing wallet as masternode  ##
105             ## that results into 33% from 10% deducted on 8% goes to marketing & server running  purposes by our    ##
106             ## team but the rest of 8% is distributet to all holder with selling CMT tokens & then reinvesting      ##
107             ## again  (LOGIC FROM CMT) This kindof functionality allows us to decrease the % tax on deposit since   ##
108             ## 1% from deposit is much  more than 33% from 8%.                                                      ##
109             ########################################################################################################*/
110             CMTContract.buy.value(msg.value.mul(_masterTaxOnInvestment).div(100))(_parojectMarketing);
111             uint _cmtBalance = getFundCMTBalance();
112             CMTContract.sell(_cmtBalance);
113             CMTContract.reinvest();
114     }
115       
116     /* Calculates actual value of % earned */
117     function getAvailablePayout() public view returns(uint) {
118         uint percent = resolvePercentRate();
119         uint interestRate = now.sub(walletTimer[msg.sender]).div(payOutInterval);
120         uint baseRate = walletDeposits[msg.sender].mul(percent).div(100000);
121         uint withdrawAmount = baseRate.mul(interestRate);
122         if(withdrawAmount > walletDeposits[msg.sender].mul(2)){
123             return walletDeposits[msg.sender].mul(2);
124         }
125         return (withdrawAmount);
126     }
127 
128     /* Resolve percent rate for deposit */
129     function resolvePercentRate() public view returns(uint) {
130         uint balance = address(this).balance;
131         if (balance < phasePreperation) {
132             return (basePercent);
133         }
134         if (balance >= phasePreperation && balance < phaseEngineStart) {
135             return (lowPercent);
136         }
137         if (balance >= phaseEngineStart && balance < phaseLiftoff) {
138             return (averagePercent);
139         }
140         if (balance >= phaseLiftoff) {
141             return (highPercent);
142         }
143     }
144 
145     /* Returns contracts balance on CMT contract */
146     function getFundCMTBalance() internal returns (uint256){
147         return CMTContract.myTokens();
148     }
149     
150     /* Returns total balance of contract wallet */
151     function totalEthereumBalance() public view returns (uint) {
152         return address(this).balance;
153     }
154 
155 
156 }
157 
158 library ItsJustBasicMathBro {
159 
160     function mul(uint a, uint b) internal pure returns(uint) {
161         uint c = a * b;
162         assert(a == 0 || c / a == b);
163         return c;
164     }
165 
166     function div(uint a, uint b) internal pure returns(uint) {
167         uint c = a / b;
168         return c;
169     }
170 
171     function sub(uint a, uint b) internal pure returns(uint) {
172         assert(b <= a);
173         return a - b;
174     }
175 
176     function add(uint a, uint b) internal pure returns(uint) {
177         uint c = a + b;
178         assert(c >= a);
179         return c;
180     }
181 
182 }