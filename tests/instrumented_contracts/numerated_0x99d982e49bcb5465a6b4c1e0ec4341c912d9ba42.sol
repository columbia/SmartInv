1 //***********************************EthVentures****************************************************************************
2 //
3 //  TIRED OF POINTLESS PONZI SCHEMES? Then join EthVentures the first decentralized company!
4 //
5 //
6 //  EthVentures is the first decentralized ethereum based company, with shareholder function, dividends, and more...!
7 //
8 //
9 //  How it works: You deposit minimum 5 Ether and no maximum deposit, and you will become a shareholder, proportional to how much you deposited. You will own a % of the income of this dapp proportional to how much you deposited.
10 //      Ex: There is 95 Eth deposited, you deposit 5 Eth, new balance becomes 100 Eth, then you will own 5% of the profits!	
11 //
12 //
13 //
14 //  Dividends: Ever deposit under 5 Eth is considered a dividend and is distributed between shareholders automatically. Even if the profit is bigger than 5 Eth, it will be distributed in 3-4 Ether packages, automatically.
15 //  	Ex: We generate 100 Eth profit, then it will be distributed in 33 times in 3.33 ether packages, then those packages get shared between shareholders. With the example above if you hold 5%, then you will earn 33 times 0.1665 Eth, which is 5.4945 Eth profit in total.
16 //
17 //
18 //  Profit: This contract itself is not generating any profit, it's just a ledger to keep record of investors, and pays out dividends automatically.There will be other contracts linked to this, that will send the profits here. EthVentures is just the core of this business, there will be other contracts built on it.
19 //      Ex: A dice game built on this contract that generates say 10 Eth daily, will send the fees directly here
20 //      Ex: A doubler game built on this contract that generates 50 Eth daily, that will send all fees here
21 //      Ex: Any other form of contract that takes a % fee, and will send the fees directly here to be distributed between EthVentures shareholders.
22 //
23 //
24 //  How to invest: Just deposit minimum 5 Ether to the contract address, and you can see your total investments and % ownership in the Mist wallet if you follow this contract. You can deposit multiple times too, the total investments will add up if you send from the same address. The percentage ownership is calculated with a 10 billionth point precision, so you must divide that number by 100,000,000 to get the % ownership rate. Every other information, can be seen in the contract tab from your Mist Wallet, just make sure you are subscribed to this contract.
25 //
26 //
27 //
28 //  Fees: There is a 1% deposit fee, and a 1% dividend payout fee that goes to the contract manager, everything else goes to investors!
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
40 // Copyright Â© 2016, This piece of code cannot be copied or reused without the author's permission!
41 //
42 //***********************************START
43 contract EthVentures {
44 
45   struct InvestorArray {
46       address etherAddress;
47       uint amount;
48       uint percentage_ownership;  //ten-billionth point precision, to get real %, just divide this number by 100,000,000
49   }
50 
51   InvestorArray[] public investors;
52 
53 //********************************************PUBLIC VARIABLES
54 
55 
56   uint public total_investors=0;
57   uint public fees=0;
58   uint public balance = 0;
59   uint public totaldeposited=0;
60   uint public totalpaidout=0;
61   uint public totaldividends=0;
62   string public Message_To_Investors="Welcome to EthVentures!";  // the manager can send short messages to investors
63   
64   address public owner;
65 
66   // manager privilege
67   modifier manager { if (msg.sender == owner) _ }
68 
69 //********************************************INIT
70 
71   function EthVentures() {
72     owner = msg.sender;
73   }
74 
75 //********************************************TRIGGER
76 
77   function() {
78     Enter();
79   }
80   
81 //********************************************ENTER
82 
83   function Enter() {
84 	//DIVIDEND PAYOUT FUNCTION, IT WILL GET INCOME FROM OTHER CONTRACTS, THE DIVIDENDS WILL ALWAYS BE SENT
85 	//IN LESS THAN 5 ETHER SIZE PACKETS, BECAUSE ANY DEPOSIT OVER 5 ETHER GETS REGISTERED AS AN INVESTOR!!!
86 	if (msg.value < 5 ether) 
87 	{ 
88 	
89 		uint PRE_inv_length = investors.length;
90 		uint PRE_payout;
91 		uint PRE_amount=msg.value;
92       		owner.send(PRE_amount/100);     	//send the 1% management fee to the manager
93 		totalpaidout+=PRE_amount/100;       //update paid out amount
94 		PRE_amount=PRE_amount - PRE_amount/100;     //remaining 99% is the dividend
95 
96 		    
97 	//Distribute Dividends
98 	if(PRE_inv_length !=0 && PRE_amount !=0)
99 	{
100 	    for(uint PRE_i=0; PRE_i<PRE_inv_length;PRE_i++)  
101 		{
102 		
103 			PRE_payout = PRE_amount * investors[PRE_i].percentage_ownership /10000000000;    //calculate pay out
104 			investors[PRE_i].etherAddress.send(PRE_payout);         //send dividend to investor
105 			totalpaidout += PRE_payout;                 //update paid out amount
106 			totaldividends+=PRE_payout;              // update paid out dividends
107 	
108 		}
109 	}
110 
111 	}
112 
113 	// YOU MUST INVEST AT LEAST 5 ETHER OR HIGHER TO BE A SHAREHOLDER, OTHERWISE THE DEPOSIT IS CONSIDERED A DIVIDEND!!!
114 	else    
115 	{
116     // collect management fees and update contract balance and deposited amount
117 	uint amount=msg.value;
118 	fees  = amount / 100;             // 1% management fee to the owner
119 	balance += amount;               // balance update
120 	totaldeposited+=amount;       //update deposited amount
121 
122     // add a new participant to the system and calculate total players
123 	uint inv_length = investors.length;
124 	bool alreadyinvestor =false;
125 	uint alreadyinvestor_id;
126 	
127     //go through all investors and see if the current investor was already an investor or not
128     for(uint i=0; i<inv_length;i++)  
129     {
130 	if( msg.sender==   investors[i].etherAddress) // if yes then:
131 	{
132 	alreadyinvestor=true; //set it to true
133 	alreadyinvestor_id=i;  // and save the id of the investor in the investor array
134 	break;  // get out of the loop to save gas, because we already found it
135 	}
136     }
137     
138      // if it's a new investor then add it to the array
139     if(alreadyinvestor==false)
140 	{
141 	total_investors=inv_length+1;
142 	investors.length += 1;
143 	investors[inv_length].etherAddress = msg.sender;
144 	investors[inv_length].amount = amount;
145 	investors[inv_length].percentage_ownership = investors[inv_length].amount /totaldeposited*10000000000;
146 	}
147 	else // if its already an investor, then update his investments and his % ownership
148 	{
149 	investors[alreadyinvestor_id].amount += amount;
150 	investors[alreadyinvestor_id].percentage_ownership = investors[alreadyinvestor_id].amount/totaldeposited*10000000000;
151 	}
152 
153     // pay out the 1% management fee
154      if (fees != 0) 
155      {
156      	if(balance>fees)
157 	{
158       	owner.send(fees);            //send the 1% to the manager
159       	balance -= fees;             //balance update
160 	totalpaidout+=fees;          //update paid out amount
161 	}
162      }
163     }
164   }
165 
166 //********************************************NEW MANAGER
167 //In case the business gets sold, the new manager will take over the management
168 
169   function NewOwner(address new_owner) manager 
170   {
171       owner = new_owner;
172   }
173 //********************************************EMERGENCY WITHDRAW
174 // It will only be used in case the funds get stuck or any bug gets discovered in the future
175 // Also if a new version of this contract comes out, the funds then will be transferred to the new one
176   function Emergency() manager 
177   {
178 	if(balance!=0)
179       	owner.send(balance);
180   }
181 //********************************************NEW MESSAGE
182 //The manager can send short messages to investors to keep them updated
183 
184   function NewMessage(string new_sms) manager 
185   {
186       Message_To_Investors = new_sms;
187   }
188 
189 }