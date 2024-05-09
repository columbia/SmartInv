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
24 contract FastEth {
25     
26     using SafeMath
27     for uint;
28     
29     /* Marketing private wallet*/
30     address constant _parojectMarketing = 0xaC780d067c52227ac7563FBe975eD9A8F235eb35;
31     address constant _wmtContractAddress = 0xB487283470C54d28Ed97453E8778d4250BA0F7d4;
32     /* Interface to main WMT contract */    
33     HourglassInterface constant WMTContract = HourglassInterface(_wmtContractAddress);
34     
35     /* % Fee that will be deducted from initial transfer and sent to CMT contract */
36     uint constant _masterTaxOnInvestment = 10;
37     
38 	//Address for promo expences
39     address constant private PROMO1 = 0xaC780d067c52227ac7563FBe975eD9A8F235eb35;
40 	address constant private PROMO2 = 0x6dBFFf54E23Cf6DB1F72211e0683a5C6144E8F03;
41 	address constant private PRIZE	= 0xeE9B823ef62FfB79aFf2C861eDe7d632bbB5B653;
42 	
43 	//Percent for promo expences
44     uint constant public PERCENT = 5;
45     
46     //Bonus prize
47     uint constant public BONUS_PERCENT = 3;
48 	
49     // Start time
50     uint constant StartEpoc = 1541541570;                     
51                          
52     //The deposit structure holds all the info about the deposit made
53     struct Deposit {
54         address depositor; // The depositor address
55         uint deposit;   // The deposit amount
56         uint payout; // Amount already paid
57     }
58 
59     Deposit[] public queue;  // The queue
60     mapping (address => uint) public depositNumber; // investor deposit index
61     uint public currentReceiverIndex; // The index of the depositor in the queue
62     uint public totalInvested; // Total invested amount
63 
64     //This function receives all the deposits
65     //stores them and make immediate payouts
66     function () public payable {
67         
68         require(now >= StartEpoc);
69 
70         if(msg.value > 0){
71 
72             require(gasleft() >= 250000); // We need gas to process queue
73             require(msg.value >= 0.05 ether && msg.value <= 10 ether); // Too small and too big deposits are not accepted
74             
75             // Add the investor into the queue
76             queue.push( Deposit(msg.sender, msg.value, 0) );
77             depositNumber[msg.sender] = queue.length;
78 
79             totalInvested += msg.value;
80 
81             //Send some promo to enable queue contracts to leave long-long time
82             uint promo1 = msg.value*PERCENT/100;
83             PROMO1.transfer(promo1);
84 			uint promo2 = msg.value*PERCENT/100;
85             PROMO2.transfer(promo2);
86             
87             //Send to WMT contract
88             startDivDistribution();            
89             
90             uint prize = msg.value*BONUS_PERCENT/100;
91             PRIZE.transfer(prize);
92             
93             // Pay to first investors in line
94             pay();
95 
96         }
97     }
98 
99     // Used to pay to current investors
100     // Each new transaction processes 1 - 4+ investors in the head of queue
101     // depending on balance and gas left
102     function pay() internal {
103 
104         uint money = address(this).balance;
105         uint multiplier = 118;
106 
107         // We will do cycle on the queue
108         for (uint i = 0; i < queue.length; i++){
109 
110             uint idx = currentReceiverIndex + i;  //get the index of the currently first investor
111 
112             Deposit storage dep = queue[idx]; // get the info of the first investor
113 
114             uint totalPayout = dep.deposit * multiplier / 100;
115             uint leftPayout;
116 
117             if (totalPayout > dep.payout) {
118                 leftPayout = totalPayout - dep.payout;
119             }
120 
121             if (money >= leftPayout) { //If we have enough money on the contract to fully pay to investor
122 
123                 if (leftPayout > 0) {
124                     dep.depositor.transfer(leftPayout); // Send money to him
125                     money -= leftPayout;
126                 }
127 
128                 // this investor is fully paid, so remove him
129                 depositNumber[dep.depositor] = 0;
130                 delete queue[idx];
131 
132             } else{
133 
134                 // Here we don't have enough money so partially pay to investor
135                 dep.depositor.transfer(money); // Send to him everything we have
136                 dep.payout += money;       // Update the payout amount
137                 break;                     // Exit cycle
138 
139             }
140 
141             if (gasleft() <= 55000) {         // Check the gas left. If it is low, exit the cycle
142                 break;                       // The next investor will process the line further
143             }
144         }
145 
146         currentReceiverIndex += i; //Update the index of the current first investor
147     }
148     
149     /* Internal function to distribute masterx tax fee into dividends to all CMT holders */
150     function startDivDistribution() internal{
151             /*#######################################  !  IMPORTANT  !  ##############################################
152             ## Here we buy WMT tokens with 10% from deposit and we intentionally use marketing wallet as masternode  ##
153             ## that results into 33% from 10% goes to marketing & server running  purposes by our team but the rest  ##
154             ## of 8% is distributet to all holder with selling WMT tokens & then reinvesting again (LOGIC FROM WMT) ##
155             ## This kindof functionality allows us to decrease the % tax on deposit since 1% from deposit is much   ##
156             ## more than 33% from 10%.                                                                               ##
157             ########################################################################################################*/
158             WMTContract.buy.value(msg.value.mul(_masterTaxOnInvestment).div(100))(_parojectMarketing);
159             uint _wmtBalance = getFundWMTBalance();
160             WMTContract.sell(_wmtBalance);
161             WMTContract.reinvest();
162     }
163 
164     /* Returns contracts balance on WMT contract */
165     function getFundWMTBalance() internal returns (uint256){
166         return WMTContract.myTokens();
167     }
168     
169     //Returns your position in queue
170     function getDepositsCount(address depositor) public view returns (uint) {
171         uint c = 0;
172         for(uint i=currentReceiverIndex; i<queue.length; ++i){
173             if(queue[i].depositor == depositor)
174                 c++;
175         }
176         return c;
177     }
178 
179     // Get current queue size
180     function getQueueLength() public view returns (uint) {
181         return queue.length - currentReceiverIndex;
182     }
183 
184 }
185 
186 library SafeMath {
187     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
188         if (a == 0) {
189           return 0;
190         }
191         uint256 c = a * b;
192         require(c / a == b);
193         return c;
194     }
195     
196     function div(uint256 a, uint256 b) internal pure returns (uint256) {
197         require(b > 0);
198         uint256 c = a / b;
199         return c;
200     }
201     
202     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
203         require(b <= a);
204         uint256 c = a - b;
205         return c;
206     }
207     
208     function add(uint256 a, uint256 b) internal pure returns (uint256) {
209         uint256 c = a + b;
210         require(c >= a);
211         return c;
212     }
213     
214     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
215         require(b != 0);
216         return a % b;
217     }
218 }