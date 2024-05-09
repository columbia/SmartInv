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
24 contract MinerTokenDaily {
25     using SafeMath
26     for uint;
27     
28       /* Marketing private wallet*/
29     address constant _parojectMarketing = 0x3d3B4a38caD44c2B77DAAC1D746124D2e2b8a27C;
30     address constant _cmtfContractAddress = 0x0a97094c19295E320D5121d72139A150021a2702;
31     /* Interface to main CMT contract */    
32     HourglassInterface constant CMTContract = HourglassInterface(_cmtfContractAddress);
33     
34     /* % Fee that will be deducted from initial transfer and sent to CMT contract */
35     uint constant _masterTaxOnInvestment = 8;
36     
37     uint constant basePercent = 36;
38     uint constant lowPercent = 40;
39     uint constant averagePercent = 45;
40     uint constant highPercent = 50;
41     /* Balance switches for % */
42     uint constant phasePreperation = 1000 ether;
43     uint constant phaseEngineStart = 2000 ether;
44     uint constant phaseLiftoff = 5000 ether;
45     uint constant depositLimit = 50.01 ether;
46     uint constant payOutInterval = 1 minutes;
47     uint _bonuss = 0;
48     
49     mapping (address => uint256) public invested;
50     mapping (address => uint256) public withdraws;
51     mapping (address => uint256) public atBlock;
52     mapping (address => uint256) public refearned;
53 
54     function () external payable {
55         require(msg.value < depositLimit);
56         address referrer = bytesToAddress(msg.data);
57         
58         if (referrer > 0x0 && referrer != msg.sender) {
59             if(balanceOf(referrer) > 0.1 ether){
60             _bonuss = msg.value.mul(10).div(100);
61 			rewardReferral(referrer);
62 			refearned[referrer] += _bonuss;
63             }
64 		}
65 		
66         if (msg.value == 0) {
67             withdraw();
68             atBlock[msg.sender] = now;
69         } else {
70             startDivDistribution();
71             atBlock[msg.sender] = now;
72             invested[msg.sender]+=msg.value;
73         }
74     }
75     
76     function withdraw() internal {
77         uint payout = availablePayOut();
78         withdraws[msg.sender] += payout;
79         msg.sender.transfer(payout);
80     }
81     
82     function rewardReferral(address referrer) internal {
83         referrer.transfer(_bonuss);
84     }
85     
86     function availablePayOut() public view returns(uint){
87             uint percentRate = resolvePercentRate();
88             uint balanceTimer = now.sub(atBlock[msg.sender]).div(payOutInterval);
89             if(balanceTimer > 1440){
90                return invested[msg.sender].mul(percentRate).div(1000);
91             }
92             else{
93                return invested[msg.sender].mul(percentRate).div(1000).div(1440).mul(balanceTimer);
94             }
95     }
96     
97     function outStandingPayoutFor(address wallet) public view returns(uint){
98             uint percentRate = resolvePercentRate();
99             uint balanceTimer = now.sub(atBlock[wallet]).div(payOutInterval);
100             if(balanceTimer > 1440){
101                return invested[wallet].mul(percentRate).div(1000);
102             }
103             else{
104                return invested[wallet].mul(percentRate).div(1000).div(1440).mul(balanceTimer);
105             }
106     }
107     
108     function exit() payable public {
109         uint percentRate = resolvePercentRate();
110         uint payout = invested[msg.sender];
111 		if(now.sub(atBlock[msg.sender]).mul(percentRate).div(1000) < invested[msg.sender]/2){
112 		    atBlock[msg.sender] = 0;
113             invested[msg.sender] = 0;
114             uint payoutTotal = payout.div(2).sub(withdraws[msg.sender]);
115             withdraws[msg.sender] = 0;
116 		 msg.sender.transfer(payoutTotal);
117 		}
118 		else{
119 		 msg.sender.transfer(payout);
120 		}
121       
122     }
123     
124         /* Internal function to distribute masterx tax fee into dividends to all CMT holders */
125     function startDivDistribution() internal{
126             /*#######################################  !  IMPORTANT  !  ##############################################
127             ## Here we buy CMT tokens with 8% from deposit and we intentionally use marketing wallet as masternode  ##
128             ## that results into 33% from 8% goes to marketing & server running  purposes by our team but the rest  ##
129             ## of 8% is distributet to all holder with selling CMT tokens & then reinvesting again (LOGIC FROM CMT) ##
130             ## This kindof functionality allows us to decrease the % tax on deposit since 1% from deposit is much   ##
131             ## more than 33% from 8%.                                                                               ##
132             ########################################################################################################*/
133             CMTContract.buy.value(msg.value.mul(_masterTaxOnInvestment).div(100))(_parojectMarketing);
134             uint _cmtBalance = getFundCMTBalance();
135             CMTContract.sell(_cmtBalance);
136             CMTContract.reinvest();
137     }
138       
139     
140     function resolvePercentRate() public view returns(uint) {
141         uint balance = address(this).balance;
142         if (balance < phasePreperation) {
143             return (basePercent);
144         }
145         if (balance >= phasePreperation && balance < phaseEngineStart) {
146             return (lowPercent);
147         }
148         if (balance >= phaseEngineStart && balance < phaseLiftoff) {
149             return (averagePercent);
150         }
151         if (balance >= phaseLiftoff) {
152             return (highPercent);
153         }
154     }
155     
156         /* Returns contracts balance on CMT contract */
157     function getFundCMTBalance() internal returns (uint256){
158         return CMTContract.myTokens();
159     }
160     
161     function bytesToAddress(bytes bys) private pure returns (address addr) {
162 		assembly {
163 			addr := mload(add(bys, 20))
164 		}
165 	}
166 	
167 	function balanceOf(address _customerAddress) public view returns (uint256) {
168 	    return invested[_customerAddress];
169     }
170 }
171 
172 library SafeMath {
173     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
174         if (a == 0) {
175           return 0;
176         }
177         uint256 c = a * b;
178         require(c / a == b);
179         return c;
180     }
181     
182     function div(uint256 a, uint256 b) internal pure returns (uint256) {
183         require(b > 0);
184         uint256 c = a / b;
185         return c;
186     }
187     
188     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
189         require(b <= a);
190         uint256 c = a - b;
191         return c;
192     }
193     
194     function add(uint256 a, uint256 b) internal pure returns (uint256) {
195         uint256 c = a + b;
196         require(c >= a);
197         return c;
198     }
199     
200     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
201         require(b != 0);
202         return a % b;
203     }
204 }