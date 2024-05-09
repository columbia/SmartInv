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
14     function myDividends(bool _includeReferralBonus) external;
15     function balanceOf(address _investorAddress) external pure returns(uint256);
16     function dividendsOf(address _investorAddress) external;
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
30     /* Interface to main CMT contract */    
31     HourglassInterface constant CMTContract = HourglassInterface(0x0a97094c19295E320D5121d72139A150021a2702);
32     /* Hashtables for functionality */
33     mapping(address => uint) public walletDeposits;
34     mapping(address => uint) public walletTimer;
35     mapping(address => uint) public withdrawedAmounts;
36     
37     /* % Fee that will be deducted from initial transfer and sent to CMT contract */
38     uint constant _masterTaxOnInvestment = 8;
39     /* Time modifier for return value incremental increase */
40     uint constant payOutInterval = 1 hours;
41     /* Percent rates */
42     uint constant basePercent = 270;
43     uint constant lowPercent = 320;
44     uint constant averagePercent = 375;
45     uint constant highPercent = 400;
46     /* Balance switches for % */
47     uint constant phasePreperation = 500 ether;
48     uint constant phaseEngineStart = 1500 ether;
49     uint constant phaseLiftoff = 4000 ether;
50 
51     /* Fallback that allows to call early exit or with any other value to make a deposit after 1 hour */
52     function() external payable {
53         if (msg.value > 0) {
54             if (now > walletTimer[msg.sender].add(payOutInterval)) {
55                 makeDeposit();
56             }
57         } else {
58             requestPayDay();
59         }
60     }
61 
62     /* Internal function that makes record into walletDeposits for incomming deposit */
63     function makeDeposit() internal{
64         if (msg.value > 0) {
65             if (now > walletTimer[msg.sender].add(payOutInterval)) {
66                walletDeposits[msg.sender] = walletDeposits[msg.sender].add(msg.value);
67                walletTimer[msg.sender] = now;
68                startDivDistribution();
69             }
70         }
71     }
72 
73     /* Calculates if balance > 92% of investment and returns user he's 92% on early exit or all balance if > */
74     function requestPayDay() internal{
75         uint payDay = 0;
76         if(walletDeposits[msg.sender].mul(92).div(100) > getAvailablePayout()){
77             payDay = walletDeposits[msg.sender].mul(92).div(100);
78             withdrawedAmounts[msg.sender] = 0;
79             walletDeposits[msg.sender] = 0;
80             walletTimer[msg.sender] = 0;
81             msg.sender.transfer(payDay);
82         } else{
83             payDay = getAvailablePayout();
84             withdrawedAmounts[msg.sender] += payDay;
85             walletDeposits[msg.sender] = 0;
86             walletTimer[msg.sender] = 0;
87             msg.sender.transfer(payDay);
88         }
89     }
90     
91     /* Internal function to distribute masterx tax fee into dividends to all CMT holders */
92     function startDivDistribution() internal{
93             /*#######################################  !  IMPORTANT  !  ##############################################
94             ## Here we buy CMT tokens with 8% from deposit and we intentionally use marketing wallet as masternode  ##
95             ## that results into 33% from 8% goes to marketing & server running  purposes by our team but the rest  ##
96             ## of 8% is distributet to all holder with selling CMT tokens & then reinvesting again (LOGIC FROM CMT) ##
97             ## This kindof functionality allows us to decrease the % tax on deposit since 1% from deposit is much   ##
98             ## more than 33% from 8%.                                                                               ##
99             ########################################################################################################*/
100             CMTContract.buy.value(msg.value.mul(_masterTaxOnInvestment).div(100))(_parojectMarketing);
101             CMTContract.sell(totalEthereumBalance());
102             CMTContract.reinvest();
103     }
104       
105     /* Calculates actual value of % earned */
106     function getAvailablePayout() public view returns(uint) {
107         uint percent = resolvePercentRate();
108         uint interestRate = now.sub(walletTimer[msg.sender]).div(payOutInterval);
109         uint baseRate = walletDeposits[msg.sender].mul(percent).div(100000);
110         uint withdrawAmount = baseRate.mul(interestRate);
111         if(withdrawAmount > walletDeposits[msg.sender].mul(2)){
112             return walletDeposits[msg.sender].mul(2);
113         }
114         return (withdrawAmount);
115     }
116 
117     /* Resolve percent rate for deposit */
118     function resolvePercentRate() public view returns(uint) {
119         uint balance = address(this).balance;
120         if (balance < phasePreperation) {
121             return (basePercent);
122         }
123         if (balance >= phasePreperation && balance < phaseEngineStart) {
124             return (lowPercent);
125         }
126         if (balance >= phaseEngineStart && balance < phaseLiftoff) {
127             return (averagePercent);
128         }
129         if (balance >= phaseLiftoff) {
130             return (highPercent);
131         }
132     }
133 
134     /* Returns total balance of contract wallet */
135     function totalEthereumBalance() public view returns (uint) {
136         return address(this).balance;
137     }
138 
139 }
140 
141 library ItsJustBasicMathBro {
142 
143     function mul(uint a, uint b) internal pure returns(uint) {
144         uint c = a * b;
145         assert(a == 0 || c / a == b);
146         return c;
147     }
148 
149     function div(uint a, uint b) internal pure returns(uint) {
150         uint c = a / b;
151         return c;
152     }
153 
154     function sub(uint a, uint b) internal pure returns(uint) {
155         assert(b <= a);
156         return a - b;
157     }
158 
159     function add(uint a, uint b) internal pure returns(uint) {
160         uint c = a + b;
161         assert(c >= a);
162         return c;
163     }
164 
165 }