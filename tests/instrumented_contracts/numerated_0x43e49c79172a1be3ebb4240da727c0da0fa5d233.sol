1 //***********************************EthVentures v3****************************************************************************
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
14 // Dividends: Every deposit under 2 Eth is considered a dividend and is distributed between shareholders automatically. Even if the profit is bigger than 2 Eth, it will be distributed in 3-4 Ether packages, automatically.
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
40 // Copyright (c) 2016, This piece of code cannot be copied or reused without the author's permission!
41 //
42 // This is v3 of the contract, new and improved, all possible bugs fixed!
43 //
44 //
45 //***********************************START
46 contract EthVentures3 {
47 struct InvestorArray {
48 address etherAddress;
49 uint amount;
50 uint percentage_ownership; //ten-billionth point precision, to get real %, just divide this number by 100,000,000
51 }
52 InvestorArray[] public investors;
53 //********************************************PUBLIC VARIABLES
54 uint public total_investors=0;
55 uint public fees=0;
56 uint public balance = 0;
57 uint public totaldeposited=0;
58 uint public totalpaidout=0;
59 uint public totaldividends=0;
60 string public Message_To_Investors="Welcome to EthVentures!"; // the manager can send short messages to investors
61 address public owner;
62 // manager privilege
63 modifier manager { if (msg.sender == owner) _ }
64 //********************************************INIT
65 function EthVentures3() {
66 owner = msg.sender;
67 }
68 //********************************************TRIGGER
69 function() {
70 Enter();
71 }
72 //********************************************ENTER
73 function Enter() {
74 //DIVIDEND PAYOUT FUNCTION, IT WILL GET INCOME FROM OTHER CONTRACTS, THE DIVIDENDS WILL ALWAYS BE SENT
75 //IN LESS THAN 2 ETHER SIZE PACKETS, BECAUSE ANY DEPOSIT OVER 2 ETHER GETS REGISTERED AS AN INVESTOR!!!
76 if (msg.value < 2 ether)
77 {
78 uint PRE_inv_length = investors.length;
79 uint PRE_payout;
80 uint PRE_amount=msg.value;
81 owner.send(PRE_amount/100); //send the 1% management fee to the manager
82 totalpaidout+=PRE_amount/100; //update paid out amount
83 PRE_amount=PRE_amount - PRE_amount/100; //remaining 99% is the dividend
84 //Distribute Dividends
85 if(PRE_inv_length !=0 && PRE_amount !=0)
86 {
87 for(uint PRE_i=0; PRE_i<PRE_inv_length;PRE_i++)
88 {
89 PRE_payout = PRE_amount * investors[PRE_i].percentage_ownership /10000000000; //calculate pay out
90 investors[PRE_i].etherAddress.send(PRE_payout); //send dividend to investor
91 totalpaidout += PRE_payout; //update paid out amount
92 totaldividends+=PRE_payout; // update paid out dividends
93 }
94 }
95 }
96 // YOU MUST INVEST AT LEAST 2 ETHER OR HIGHER TO BE A SHAREHOLDER, OTHERWISE THE DEPOSIT IS CONSIDERED A DIVIDEND!!!
97 else
98 {
99 // collect management fees and update contract balance and deposited amount
100 uint amount=msg.value;
101 fees = amount / 100; // 1% management fee to the owner
102 balance += amount; // balance update
103 totaldeposited+=amount; //update deposited amount
104 // add a new participant to the system and calculate total players
105 uint inv_length = investors.length;
106 bool alreadyinvestor =false;
107 uint alreadyinvestor_id;
108 //go through all investors and see if the current investor was already an investor or not
109 for(uint i=0; i<inv_length;i++)
110 {
111 if( msg.sender== investors[i].etherAddress) // if yes then:
112 {
113 alreadyinvestor=true; //set it to true
114 alreadyinvestor_id=i; // and save the id of the investor in the investor array
115 break; // get out of the loop to save gas, because we already found it
116 }
117 }
118 // if it's a new investor then add it to the array
119 if(alreadyinvestor==false)
120 {
121 total_investors=inv_length+1;
122 investors.length += 1;
123 investors[inv_length].etherAddress = msg.sender;
124 investors[inv_length].amount = amount;
125 investors[inv_length].percentage_ownership = investors[inv_length].amount /totaldeposited*10000000000;
126 for(uint k=0; k<inv_length;k++)
127 {investors[k].percentage_ownership = investors[k].amount/totaldeposited*10000000000;} //recalculate % ownership
128 }
129 else // if its already an investor, then update his investments and his % ownership
130 {
131 investors[alreadyinvestor_id].amount += amount;
132 investors[alreadyinvestor_id].percentage_ownership = investors[alreadyinvestor_id].amount/totaldeposited*10000000000;
133 }
134 // pay out the 1% management fee
135 if (fees != 0)
136 {
137 if(balance>fees)
138 {
139 owner.send(fees); //send the 1% to the manager
140 balance -= fees; //balance update
141 totalpaidout+=fees; //update paid out amount
142 }
143 }
144 }
145 }
146 //********************************************NEW MANAGER
147 //In case the business gets sold, the new manager will take over the management
148 function NewOwner(address new_owner) manager
149 {
150 owner = new_owner;
151 }
152 //********************************************EMERGENCY WITHDRAW
153 // It will only be used in case the funds get stuck or any bug gets discovered in the future
154 // Also if a new version of this contract comes out, the funds then will be transferred to the new one
155 function Emergency() manager
156 {
157 if(balance!=0)
158 {
159 owner.send(balance);
160 balance=0;
161 }
162 }
163 //********************************************NEW MESSAGE
164 //The manager can send short messages to investors to keep them updated
165 function NewMessage(string new_sms) manager
166 {
167 Message_To_Investors = new_sms;
168 }
169 }