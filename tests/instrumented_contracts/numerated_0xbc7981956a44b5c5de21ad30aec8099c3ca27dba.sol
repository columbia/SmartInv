1 pragma solidity ^0.4.25;
2 
3 
4 /*
5 * ---How to use:
6 *	1. Send from ETH wallet to the smart contract address any amount ETH.
7 *	2a. Claim your profit by sending 0 ether transaction (1 time per 12 hour)
8 *	OR
9 *	2b. Send more ether to reinvest AND get your profit
10 *	2c. If you hold, the percentage grows
11 *	3. If you earn more than 150%, you can withdraw only one finish time
12 *	4. If you want withdraw invested, send 0.00000911 ether
13 *
14 *	RECOMMENDED GAS LIMIT: 150000
15 *	RECOMMENDED GAS PRICE: https://ethgasstation.info/
16 *	
17 *	THE PROJECT HAS HIGH RISKS! 
18 *	PROJECT MAKE PAYMENTS IF BALANCE HAS ETHER! 
19 */
20 
21 contract HodlETH {
22     // records amounts invested
23     mapping (address => uint) public userInvested;
24     // records blocks at which investments were made
25     mapping (address => uint) public entryTime;
26     // records how much you withdraw
27     mapping (address => uint) public withdrawnAmount;
28     //records you use the referral program or not
29     mapping (address => uint) public referrerOn;
30     // marketing fund 6%
31     address public advertisingFund = 0x01429d58058B3e84F6f264D91254EA3a96E1d2B7; 
32     uint public advertisingPercent = 6;
33 	// tech support fund 2 %
34 	address techSupportFund = 0x0D5dB78b35ecbdD22ffeA91B46a6EC77dC09EA4a;		
35 	uint public techSupportPercent = 2;
36 	// "hodl" mode
37     uint public startPercent = 25;			// 2.5%
38 	uint public fiveDayHodlPercent = 30;	// 3%
39     uint public tenDayHodlPercent = 35;		// 3.5%
40 	uint public twentyDayHodlPercent = 45;	// 4.5%
41 	// bonus percent of balance
42 	uint public lowBalance = 500 ether;
43 	uint public middleBalance = 2000 ether;
44 	uint public highBalance = 3500 ether;
45     uint public soLowBalanceBonus = 5;		// 0.5%
46 	uint public lowBalanceBonus = 10;		// 1%
47 	uint public middleBalanceBonus = 15;	// 1.5%
48 	uint public highBalanceBonus = 20;		// 2%
49 	
50 	
51     
52     // get bonus percent
53     function bonusPercent() public view returns(uint){
54         
55         uint balance = address(this).balance;
56         
57         if (balance < lowBalance){
58             return (soLowBalanceBonus);		// if balance < 500 ether return 0.5%
59         } 
60         if (balance > lowBalance && balance < middleBalance){
61             return (lowBalanceBonus); 		// if balance > 500 ether and balance < 2000 ether return 1%
62         } 
63         if (balance > middleBalance && balance < highBalance){
64             return (middleBalanceBonus); 	// if balance > 2000 ether and balance < 3500 ether return 1.5%
65         }
66         if (balance > highBalance){
67             return (highBalanceBonus);		// if balance > 3500 ether return 2%
68         }
69         
70     }
71     // get personal percent
72     function personalPercent() public view returns(uint){
73         
74         uint hodl = block.number - entryTime[msg.sender]; 
75 		// how many blocks you hold, 1 day = 6100 blocks
76          if (hodl < 30500){
77             return (startPercent);			// if hodl < 5 day, return 2.5%
78         }
79 		if (hodl > 30500 && hodl < 61000){
80             return (fiveDayHodlPercent);	// if hodl > 5 day and hodl < 10 day, return 3%
81         }
82         if (hodl > 61000 && hodl < 122000){
83             return (tenDayHodlPercent);		// if hodl > 10 day and hodl < 20 day, return 3.5%
84         }
85 		if (hodl > 122000){
86             return (twentyDayHodlPercent);	// if hodl > 20 day, return 3.5%
87         }
88         
89         
90     }
91     
92     // if send 0.00000911 ETH contract will return your invest, else make invest
93     function() external payable {
94         if (msg.value == 0.00000911 ether) {
95             returnInvestment();
96         } 
97 		else {
98             invest();
99         }
100     }    
101     
102    // return of deposit(userInvested - withdrawnAmount - (userInvested / 10(fund fee)) , after delete user record
103     function returnInvestment() timeWithdrawn private{
104         if(userInvested[msg.sender] > 0){
105             uint refundAmount = userInvested[msg.sender] - withdrawnAmount[msg.sender] - (userInvested[msg.sender] / 10);
106             require(userInvested[msg.sender] > refundAmount, 'You have already returned the investment');
107 			userInvested[msg.sender] = 0;
108             entryTime[msg.sender] = 0;
109             withdrawnAmount[msg.sender] = 0;
110             msg.sender.transfer(refundAmount);
111         }
112     }
113     // make a contribution
114     function invest() timeWithdrawn maxInvested  private {
115         if (msg.value > 0 ){
116 			// call terminal    
117 			terminal();
118 			// record invested amount (msg.value) of this transaction
119 			userInvested[msg.sender] += msg.value;
120 			// sending fee for advertising and tech support
121 			advertisingFund.transfer(msg.value * advertisingPercent / 100);
122 			techSupportFund.transfer(msg.value * techSupportPercent / 100);
123         
124 			// if you entered the address that invited you and didn’t do this before
125 			if (msg.data.length != 0 && referrerOn[msg.sender] != 1){
126 				//pays his bonus
127 				transferRefBonus();
128 			}
129         } else{
130 			// call terminal  
131             terminal();
132         }
133     }
134     
135     function terminal() internal {
136         // if the user received 150% or more of his contribution, delete the user
137         if (userInvested[msg.sender] * 15 / 10 < withdrawnAmount[msg.sender]){
138             userInvested[msg.sender] = 0;
139             entryTime[msg.sender] = 0;
140             withdrawnAmount[msg.sender] = 0;
141             referrerOn[msg.sender] = 0; 
142         } else {
143             // you percent = bonusPercent + personalPercent, min 3% and max 6.5%
144             uint percent = bonusPercent() + personalPercent();
145             // calculate profit amount as such:
146             // amount = (amount invested) * you percent * (blocks since last transaction) / 6100
147             // 6100 is an average block count per day produced by Ethereum blockchain
148             uint amount = userInvested[msg.sender] * percent / 1000 * ((block.number - entryTime[msg.sender]) / 6100);
149             // record block number
150             entryTime[msg.sender] = block.number;
151             // record withdraw amount
152             withdrawnAmount[msg.sender] += amount;
153             // send calculated amount of ether directly to sender (aka YOU)
154             msg.sender.transfer(amount);
155         }
156         
157     }
158     
159     // convert bytes to eth address 
160 	function bytesToAddress(bytes bys) private pure returns (address addr) {
161 		assembly {
162             addr := mload(add(bys, 20))
163         }
164 	}
165 	// transfer referrer bonus of invested 
166     function transferRefBonus() private {        
167         address referrer = bytesToAddress(msg.data);
168         if (referrer != msg.sender && userInvested[referrer] != 0){
169         referrerOn[msg.sender] = 1;
170         uint refBonus = msg.value * 20 / 1000;
171         referrer.transfer(refBonus);    
172         }
173     }
174     
175     modifier timeWithdrawn(){
176         require(entryTime[msg.sender] + 3050 < block.number, 'Withdraw and deposit no more 1 time per 12 hour');
177         _;
178     }
179     
180     
181     modifier maxInvested(){
182         require(msg.value <= 25 ether, 'Max invested 25 ETH per 12 hours');
183         _;
184     }
185 
186 }