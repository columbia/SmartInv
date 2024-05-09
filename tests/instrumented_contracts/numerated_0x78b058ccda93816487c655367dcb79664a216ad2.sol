1 //***********************************Simple Dice Game
2 //
3 //
4 //  Hello player, this is a Ethereum based dice game. You must deposit minimum of "MinDeposit" to play (+transaction cost), if you send less it wont be counted. 
5 //  You have a 25% chance of winning the entire balance, whatever that amount is.  On average that means that 3 players will deposit before you will win the balance.
6 //  Also every 40th player will win the jackpot, so make sure you are that person. The jackpot will be considerably more than the balance, so you have the chance to win big if you deposit fast! The fee and deposit rate can be changed by the owner, and it's publicly visible, after the dice has a big volume, the fee will be lowered!
7 //  
8 // Initial Minimum Deposit: 100 finney!
9 //
10 //  Good Luck and Have Fun!
11 //
12 //
13 // THIS IS AN ATTACHMENT OF THE ETHVENTURES BUSINESS: 0xee462a6717f17c57c826f1ad9b4d3813495296c9 
14 //
15 //***********************************START
16 contract SimpleDice {
17 
18   struct gamblerarray {
19       address etherAddress;
20       uint amount;
21   }
22 
23 //********************************************PUBLIC VARIABLES
24   
25   gamblerarray[] public gamblerlist;
26   uint public Gamblers_Until_Jackpot=0;
27   uint public Total_Gamblers=0;
28   uint public FeeRate=5;
29   uint public Bankroll = 0;
30   uint public Jackpot = 0;
31   uint public Total_Deposits=0;
32   uint public Total_Payouts=0;
33   uint public MinDeposit=100 finney;
34 
35   address public owner;
36   uint Fees=0;
37   // simple single-sig function modifier
38   modifier onlyowner { if (msg.sender == owner) _ }
39 
40 //********************************************INIT
41 
42   function SimpleDice() {
43     owner = 0xee462a6717f17c57c826f1ad9b4d3813495296c9;  //this contract is an attachment to EthVentures
44   }
45 
46 //********************************************TRIGGER
47 
48   function() {
49     enter();
50   }
51   
52 //********************************************ENTER
53 
54   function enter() {
55     if (msg.value >10 finney) {
56 
57     uint amount=msg.value;
58     uint payout;
59 
60 
61     // add a new participant to the system and calculate total players
62     uint list_length = gamblerlist.length;
63     Total_Gamblers=list_length+1;
64     Gamblers_Until_Jackpot=40-(Total_Gamblers % 40);
65     gamblerlist.length += 1;
66     gamblerlist[list_length].etherAddress = msg.sender;
67     gamblerlist[list_length].amount = amount;
68 
69 
70 
71     // set payout variables
72      Total_Deposits+=amount;       	//update deposited amount
73 	    
74       Fees   =amount * FeeRate/100;    // 5% fee to the owner
75       amount-=amount * FeeRate/100;
76 	    
77       Bankroll += amount*80/100;     // 80% to the balance
78       amount-=amount*80/100;  
79 	    
80       Jackpot += amount;               	//remaining to the jackpot
81 
82 
83     // payout fees to the owner
84      if (Fees != 0) 
85      {
86 	uint minimal= 1990 finney;
87 	if(Fees<minimal)
88 	{
89       	owner.send(Fees);		//send fee to owner
90 	Total_Payouts+=Fees;        //update paid out amount
91 	}
92 	else
93 	{
94 	uint Times= Fees/minimal;
95 
96 	for(uint i=0; i<Times;i++)   // send the fees out in packets compatible to EthVentures dividend function
97 	if(Fees>0)
98 	{
99 	owner.send(minimal);		//send fee to owner
100 	Total_Payouts+=Fees;        //update paid out amount
101 	Fees-=minimal;
102 	}
103 	}
104      }
105  
106     if (msg.value >= MinDeposit) 
107      {
108 	     
109    //payout to participants	
110      if(list_length%40==0 && Jackpot > 0)   				//every 40th player wins the jackpot if  it's not 0
111 	{
112 	gamblerlist[list_length].etherAddress.send(Jackpot);         //send pay out to participant
113 	Total_Payouts += Jackpot;               					//update paid out amount   
114 	Jackpot=0;									//jackpot update
115 	}
116      else   											//you either win the jackpot or the balance, but not both in 1 round
117 	if(uint(sha3(gamblerlist[list_length].etherAddress,list_length))+uint(sha3(msg.gas)) % 4 ==0 && Bankroll > 0) 	//if the hashed length of your address is even, 
118 	{ 												   								//which is a 25% chance, then you get paid out all balance!
119 	gamblerlist[list_length].etherAddress.send(Bankroll);        //send pay out to participant
120 	Total_Payouts += Bankroll;               					//update paid out amount
121 	Bankroll = 0;                      						//bankroll update
122 	}
123     
124     
125     
126     //enter function ends
127 	}
128     }
129   }
130 
131 //********************************************NEW OWNER
132 
133   function setOwner(address new_owner) onlyowner { //set new owner of the casino
134       owner = new_owner;
135   }
136 //********************************************SET MIN DEPOSIT
137 
138   function setMinDeposit(uint new_mindeposit) onlyowner { //set new minimum deposit rate
139       MinDeposit = new_mindeposit;
140   }
141 //********************************************SET FEE RATE
142 
143   function setFeeRate(uint new_feerate) onlyowner { //set new fee rate
144       FeeRate = new_feerate;
145   }
146 }