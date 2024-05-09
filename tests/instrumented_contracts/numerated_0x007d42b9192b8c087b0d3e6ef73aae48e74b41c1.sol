1 //***********************************EthVentures v4****************************************************************************
2 //
3 // TIRED OF POINTLESS PONZI SCHEMES? Then join EthVentures the first decentralized company!
4 //
5 //
6 // EthVentures is the first decentralized ethereum based company, with shareholder function, dividends, and more...!
7 //
8 //
9 // How it works: You deposit minimum 2 Ether and no maximum deposit, and you will become a shareholder, proportional to how much you deposited. You will own a % of the income of this dapp proportional to how much you deposited.
10 // Ex: There is 98 Eth deposited, you deposit 2 Eth, new balance becomes 100 Eth, then you will own 2% of the profits!
11 //
12 //
13 //
14 // Dividends: Every deposit under 2 Eth is considered a dividend and is distributed between shareholders automatically. Even if the profit is bigger than 2 Eth, it will be distributed in 1-2 Ether packages, automatically.
15 // Ex: We generate 100 Eth profit daily, then it will be distributed in 50 times in 2 ether packages, then those packages get shared between shareholders. With the example above if you hold 2%, then you will earn 50 times 0.04 Eth, which is 2 Eth profit in total.
16 //
17 //
18 // Profit: This contract itself is not generating any profit, it's just a ledger to keep record of investors, and pays out dividends automatically.There will be other contracts linked to this, that will send the profits here. EthVentures is just the core of this business, there will be other contracts built on it.
19 // Ex: A dice game built on this contract that generates say 10 Eth daily, will send the fees directly here
20 // Ex: A doubler game built on this contract that generates 50 Eth daily, that will send all fees here
21 // Ex: Any other form of contract that takes a % fee, and will send the fees directly here to be distributed between EthVentures shareholders.
22 //
23 //
24 // How to invest: Just deposit minimum 2 Ether to the contract address, and you can see your total investments and % ownership in the Mist wallet if you follow this contract. You can deposit multiple times too, the total investments will add up if you send from the same address. The percentage ownership is calculated with a 10 billionth point precision, so you must divide that number by 100,000,000 to get the % ownership rate. Every other information, can be seen in the contract tab from your Mist Wallet, just make sure you are subscribed to this contract.
25 //
26 //
27 //
28 // Fees: There is a 1% deposit fee, and a 1% dividend payout fee that goes to the contract manager, everything else goes to investors!
29 //
30 //============================================================================================================================
31 //
32 // When EthVentures will be succesful, it will have tens or hundreds of different contracts, all sending the fees here to our investors, AUTOMATICALLY. It could generate even hundreds of Eth daily at some point.
33 //
34 // Imagine it as a decentralized web of income, all sending the money to 1 single point, this contract.
35 //
36 // It is literally a DECENTRALIZED MONEY GENERATOR!
37 //
38 //
39 //============================================================================================================================
40 // Copyright (c) 2016 to "BetGod" from Bitcointalk.org, This piece of code cannot be copied or reused without the author's permission!
41 //
42 // Author: https://bitcointalk.org/index.php?action=profile;u=803185
43 //
44 // This is v4 of the contract, new and improved, all possible bugs fixed!
45 //
46 //
47 //***********************************START
48 contract EthVentures4 {
49 struct InvestorArray {
50 address etherAddress;
51 uint amount;
52 uint percentage_ownership; //ten-billionth point precision, to get real %, just divide this number by 100,000,000
53 }
54 InvestorArray[] public investors;
55 //********************************************PUBLIC VARIABLES
56 uint public total_investors=0;
57 uint public fees=0;
58 uint public balance = 0;
59 uint public totaldeposited=0;
60 uint public totalpaidout=0;
61 uint public totaldividends=0;
62 string public Message_To_Investors="Welcome to EthVentures4! New and improved! All bugs fixed!"; // the manager can send short messages to investors
63 address public owner;
64 // manager privilege
65 modifier manager { if (msg.sender == owner) _ }
66 //********************************************INIT
67 function EthVentures4() {
68 owner = msg.sender;
69 }
70 //********************************************TRIGGER
71 function() {
72 Enter();
73 }
74 //********************************************ENTER
75 function Enter() {
76 //DIVIDEND PAYOUT FUNCTION, IT WILL GET INCOME FROM OTHER CONTRACTS, THE DIVIDENDS WILL ALWAYS BE SENT
77 //IN LESS THAN 2 ETHER SIZE PACKETS, BECAUSE ANY DEPOSIT OVER 2 ETHER GETS REGISTERED AS AN INVESTOR!!!
78 if (msg.value < 2 ether)
79 {
80 uint PRE_payout;
81 uint PRE_amount=msg.value;
82 owner.send(PRE_amount/100); //send the 1% management fee to the manager
83 totalpaidout+=PRE_amount/100; //update paid out amount
84 PRE_amount-=PRE_amount/100; //remaining 99% is the dividend
85 //Distribute Dividends
86 if(investors.length !=0 && PRE_amount !=0)
87 {
88 for(uint PRE_i=0; PRE_i<investors.length;PRE_i++)
89 {
90 PRE_payout = PRE_amount * investors[PRE_i].percentage_ownership /10000000000; //calculate pay out
91 investors[PRE_i].etherAddress.send(PRE_payout); //send dividend to investor
92 totalpaidout += PRE_payout; //update paid out amount
93 totaldividends+=PRE_payout; // update paid out dividends
94 }
95 Message_To_Investors="Dividends have been paid out!";
96 }
97 }
98 // YOU MUST INVEST AT LEAST 2 ETHER OR HIGHER TO BE A SHAREHOLDER, OTHERWISE THE DEPOSIT IS CONSIDERED A DIVIDEND!!!
99 else
100 {
101 // collect management fees and update contract balance and deposited amount
102 uint amount=msg.value;
103 fees = amount / 100; // 1% management fee to the owner
104 totaldeposited+=amount; //update deposited amount
105 amount-=amount/100;
106 balance += amount; // balance update
107 // add a new participant to the system and calculate total players
108 bool alreadyinvestor =false;
109 uint alreadyinvestor_id;
110 //go through all investors and see if the current investor was already an investor or not
111 for(uint i=0; i<investors.length;i++)
112 {
113 if( msg.sender== investors[i].etherAddress) // if yes then:
114 {
115 alreadyinvestor=true; //set it to true
116 alreadyinvestor_id=i; // and save the id of the investor in the investor array
117 break; // get out of the loop to save gas, because we already found it
118 }
119 }
120 // if it's a new investor then add it to the array
121 if(alreadyinvestor==false)
122 {
123 total_investors=investors.length+1;
124 investors.length += 1; //increment first
125 investors[investors.length-1].etherAddress = msg.sender;
126 investors[investors.length-1].amount = amount;
127 investors[investors.length-1].percentage_ownership = amount /totaldeposited*10000000000;
128 Message_To_Investors="New Investor has joined us!"; // a new and real investor has joined us
129 
130 for(uint k=0; k<investors.length;k++) //if smaller than incremented, goes into loop
131 {investors[k].percentage_ownership = investors[k].amount/totaldeposited*10000000000;} //recalculate % ownership
132 
133 }
134 else // if its already an investor, then update his investments and his % ownership
135 {
136 investors[alreadyinvestor_id].amount += amount;
137 investors[alreadyinvestor_id].percentage_ownership = investors[alreadyinvestor_id].amount/totaldeposited*10000000000;
138 }
139 // pay out the 1% management fee
140 if (fees != 0)
141 {
142 owner.send(fees); //send the 1% to the manager
143 totalpaidout+=fees; //update paid out amount
144 }
145 
146 }
147 }
148 //********************************************NEW MANAGER
149 //In case the business gets sold, the new manager will take over the management
150 function NewOwner(address new_owner) manager
151 {
152 owner = new_owner;
153 Message_To_Investors="The contract has a new manager!";
154 }
155 //********************************************EMERGENCY WITHDRAW
156 // It will only be used in case the funds get stuck or any bug gets discovered in the future
157 // Also if a new version of this contract comes out, the funds then will be transferred to the new one
158 function Emergency() manager
159 {
160 if(balance!=0)
161 {
162 owner.send(balance);
163 balance=0;
164 Message_To_Investors="Emergency Withdraw has been issued!";
165 }
166 }
167 //********************************************NEW MESSAGE
168 //The manager can send short messages to investors to keep them updated
169 function NewMessage(string new_sms) manager
170 {
171 Message_To_Investors = new_sms;
172 }
173 //********************************************MANUALLY ADD INVESTORS
174 //The manager can add manually the investors from the previous versions, 
175 //so that those that invested in the older versions can join us in the new and updated versions
176 function NewManualInvestor(address new_investor , uint new_amount) manager
177 {
178 totaldeposited+=new_amount; //update deposited amount manually
179 
180 total_investors=investors.length+1;
181 investors.length += 1; //increment first
182 investors[investors.length-1].etherAddress = new_investor;
183 investors[investors.length-1].amount = new_amount;
184 investors[investors.length-1].percentage_ownership = new_amount /totaldeposited*10000000000;
185 
186 Message_To_Investors="New manual Investor has been added by the Manager!"; // you can see if the newest investor was manually added or not, this will add transparency to the contract, since this function should only be used in emergency situations.
187 // This will ensure that the manager doesn't add fake investors of his own addresses.
188 }
189 //********************************************MANUAL DEPOSIT
190 //The manager can deposit manually from previous version's balances
191 function ManualDeposit() manager
192 {
193 Message_To_Investors = "Manual Deposit received from the Manager";
194 }
195 
196 //end
197 }