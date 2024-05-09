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
13 *   5. Max invest 25 ETH per 12 hours
14 *   6. Withdraw and deposit no more 1 time per 12 hour
15 *
16 *	RECOMMENDED GAS LIMIT: 150000
17 *	RECOMMENDED GAS PRICE: https://ethgasstation.info/
18 *	
19 *	THE PROJECT HAS HIGH RISKS! 
20 *	PROJECT PAYS IF BALANCE HAS ETHER!
21 */
22 
23 contract HodlETH {
24     //use library for safe math operations
25     using SafeMath for uint;
26     
27     // records amount of invest
28     mapping (address => uint) public userInvested;
29     // records time of payment
30     mapping (address => uint) public entryTime;
31     // records withdrawal amount
32     mapping (address => uint) public withdrawAmount;
33     // records you use the referral program or not
34     mapping (address => uint) public referrerOn;
35     // advertising fund 6%
36     address advertisingFund = 0x9348739Fb4BA75fB316D3C01B9a89AbeB683162b; 
37     uint public advertisingPercent = 6;
38 	// tech support fund 2 %
39 	address techSupportFund = 0xC52d419a8cCD8b57586b67B668635faA1931e443;		
40 	uint public techSupportPercent = 2;
41 	// "hodl" mode
42     uint public startPercent = 100;			// 2.4%	per day		or 	0.1% 	per hours
43 	uint public fiveDayHodlPercent = 125;	// 3%	per day		or 	0.125% 	per hours
44     uint public tenDayHodlPercent = 150;	// 3.6%	per day		or 	0.155	per hours
45 	uint public twentyDayHodlPercent = 200;	// 4.8%	per day		or 	0.2%	per hours
46 	// bonus percent of balance
47 	uint public lowBalance = 500 ether;
48 	uint public middleBalance = 2000 ether;
49 	uint public highBalance = 3500 ether;
50     uint public soLowBalanceBonus = 25;		// 0.6%	per day		or 	0.025% 	per hours
51 	uint public lowBalanceBonus = 50;		// 1.2%	per day		or 	0.05%	per hours
52 	uint public middleBalanceBonus = 75;	// 1.8%	per day		or 	0.075%	per hours
53 	uint public highBalanceBonus = 100;		// 2.4%	per day		or 	0.1%	per hours
54 
55 	uint public countOfInvestors = 0;
56 	
57     
58     // get bonus percent
59     function _bonusPercent() public view returns(uint){
60         
61         uint balance = address(this).balance;
62         
63         if (balance < lowBalance){
64             return (soLowBalanceBonus);		// if balance less 500 ether, rate 0.6% per days
65         } 
66         if (balance > lowBalance && balance < middleBalance){
67             return (lowBalanceBonus); 		// if balance more 500 ether, rate 1.2% per days
68         } 
69         if (balance > middleBalance && balance < highBalance){
70             return (middleBalanceBonus); 	// if balance more 2000 ether, rate 1.8% per days
71         }
72         if (balance > highBalance){
73             return (highBalanceBonus);		// if balance more 3500 ether, rate 2.4% per days
74         }
75     }
76     
77     // get personal percent
78     function _personalPercent() public view returns(uint){
79         // how many days you hold
80         uint hodl = (now).sub(entryTime[msg.sender]); 
81 		
82          if (hodl < 5 days){
83             return (startPercent);			// if you don't withdraw less 5 day, your rate 2.4% per days
84         }
85 		if (hodl > 5 days && hodl < 10 days){
86             return (fiveDayHodlPercent);	// if you don't withdraw more 5 day , your rate 3% per days
87         }
88         if (hodl > 10 days && hodl < 20 days){
89             return (tenDayHodlPercent);		// if you don't withdraw more 10 day , your rate 3.6% per days
90         }
91 		if (hodl > 20 days){
92             return (twentyDayHodlPercent);	// if you don't withdraw more 20 day, your rate 4.8% per days
93         }
94     }
95     
96     // if send 0.00000911 ETH contract will return your invest, else make invest
97     function() external payable {
98         if (msg.value == 0.00000911 ether) {
99             returnInvestment();
100         } 
101 		else {
102             invest();
103         }
104     }    
105     
106    // return of deposit(userInvested - withdrawAmount - (userInvested / 10(fund fee)) , after delete user
107     function returnInvestment() timeWithdraw private{
108         if(userInvested[msg.sender] > 0){
109             uint refundAmount = userInvested[msg.sender].sub(withdrawAmount[msg.sender]).sub(userInvested[msg.sender].div(10));
110             require(userInvested[msg.sender] > refundAmount, 'You have already returned the investment');
111 			userInvested[msg.sender] = 0;
112             entryTime[msg.sender] = 0;
113             withdrawAmount[msg.sender] = 0;
114             msg.sender.transfer(refundAmount);
115         }
116     }
117     // make invest
118     function invest() timeWithdraw maxInvest  private {
119 		if (userInvested[msg.sender] == 0) {
120                 countOfInvestors += 1;
121             }
122             
123 		if (msg.value > 0 ){
124 			// call terminal    
125 			terminal();
126 			// record invested amount (msg.value) of this transaction
127 			userInvested[msg.sender] += msg.value;
128 			// record entry time
129 			entryTime[msg.sender] = now;
130 			// sending fee for advertising and tech support
131 			advertisingFund.transfer((msg.value).mul(advertisingPercent).div(100));
132 			techSupportFund.transfer((msg.value).mul(techSupportPercent).div(100));
133         
134 			// if you entered the address that invited you and didn’t do this before
135 			if (msg.data.length != 0 && referrerOn[msg.sender] != 1){
136 				//pays his bonus
137 				transferRefBonus();
138 			}
139         } else{
140 			// call terminal  
141             terminal();
142         }
143     }
144     
145     function terminal() internal {
146         // if the user received 150% or more of his contribution, delete  user
147         if (userInvested[msg.sender].mul(15).div(10) < withdrawAmount[msg.sender]){
148             userInvested[msg.sender] = 0;
149             entryTime[msg.sender] = 0;
150             withdrawAmount[msg.sender] = 0;
151         } else {
152             // you percent = bonusPercent + personalPercent, min 3% and max 7.2% per day or min 0.125% and max 0.3% per hours
153             uint bonusPercent = _bonusPercent();
154             uint personalPercent = _personalPercent();
155             uint percent = (bonusPercent).add(personalPercent);
156             // calculate profit amount as such:
157             // amount = (amount invested) * you percent / 100000 * ((now - your entry time) / 1 hour)
158             uint amount = userInvested[msg.sender].mul(percent).div(100000).mul(((now).sub(entryTime[msg.sender])).div(1 hours));
159             // record entry time
160             entryTime[msg.sender] = now;
161             // record withdraw amount
162             withdrawAmount[msg.sender] += amount;
163             // send calculated amount of ether directly to sender (aka YOU)
164             msg.sender.transfer(amount);
165         }
166         
167     }
168     
169     // convert bytes to eth address 
170 	function bytesToAddress(bytes bys) private pure returns (address addr) {
171 		assembly {
172             addr := mload(add(bys, 20))
173         }
174 	}
175 	// transfer referrer bonus of invested 
176     function transferRefBonus() private {        
177         address referrer = bytesToAddress(msg.data);
178         if (referrer != msg.sender && userInvested[referrer] != 0){
179         //referrer ON
180 		referrerOn[msg.sender] = 1;
181 		//transfer to referrer 2 % of invested
182         uint refBonus = (msg.value).mul(2).div(100);
183         referrer.transfer(refBonus);    
184         }
185     }
186     
187     modifier timeWithdraw(){
188         require(entryTime[msg.sender].add(12 hours) <= now, 'Withdraw and deposit no more 1 time per 12 hour');
189         _;
190     }
191     
192     
193     modifier maxInvest(){
194         require(msg.value <= 25 ether, 'Max invest 25 ETH per 12 hours');
195         _;
196     }
197 
198 }
199 	
200 /**
201  * @title SafeMath
202  * @dev Math operations with safety checks that throw on error
203  */
204 library SafeMath {
205 
206     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
207         uint256 c = a * b;
208         assert(a == 0 || c / a == b);
209         return c;
210     }
211 
212     function div(uint256 a, uint256 b) internal pure returns(uint256) {
213         // assert(b > 0); // Solidity automatically throws when dividing by 0
214         uint256 c = a / b;
215         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
216         return c;
217     }
218 
219     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
220         assert(b <= a);
221         return a - b;
222     }
223 
224     function add(uint256 a, uint256 b) internal pure returns(uint256) {
225         uint256 c = a + b;
226         assert(c >= a);
227         return c;
228     }
229 
230 }