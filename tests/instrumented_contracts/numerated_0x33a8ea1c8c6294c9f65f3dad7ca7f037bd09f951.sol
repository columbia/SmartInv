1 //***********************************Ether Dice Game
2 //
3 //
4 //  Hello player, this is a Ethereum based dice game. You must deposit minimum of "MinDeposit" to play (+transaction cost), if you send less it wont be counted. 
5 //  You have a 25% chance of winning the entire balance, whatever that amount is.  On average that means that 3 players will deposit before you will win the balance.
6 //  Also every 40th player will win the jackpot, so make sure you are that person. The jackpot will be considerably more than the balance, so you have the chance to win big if you deposit fast! The fee and deposit rate can be changed by the owner, and it's publicly visible, after the dice has a big volume, the fee will be lowered!
7 //  
8 //  Good Luck and Have Fun!
9 //
10 //***********************************START
11 contract EthereumDice {
12 
13   struct gamblerarray {
14       address etherAddress;
15       uint amount;
16   }
17 
18 //********************************************PUBLIC VARIABLES
19   
20   gamblerarray[] public gamblerlist;
21   uint public Gamblers_Until_Jackpot=0;
22   uint public Total_Gamblers=0;
23   uint public FeeRate=7;
24   uint public Bankroll = 0;
25   uint public Jackpot = 0;
26   uint public Total_Deposits=0;
27   uint public Total_Payouts=0;
28   uint public MinDeposit=1 ether;
29 
30   address public owner;
31   uint Fees=0;
32   // simple single-sig function modifier
33   modifier onlyowner { if (msg.sender == owner) _ }
34 
35 //********************************************INIT
36 
37   function EthereumDice() {
38     owner = msg.sender;
39   }
40 
41 //********************************************TRIGGER
42 
43   function() {
44     enter();
45   }
46   
47 //********************************************ENTER
48 
49   function enter() {
50     if (msg.value >10 finney) {
51 
52     uint amount=msg.value;
53     uint payout;
54 
55 
56     // add a new participant to the system and calculate total players
57     uint list_length = gamblerlist.length;
58     Total_Gamblers=list_length+1;
59     Gamblers_Until_Jackpot=40-(Total_Gamblers % 40);
60     gamblerlist.length += 1;
61     gamblerlist[list_length].etherAddress = msg.sender;
62     gamblerlist[list_length].amount = amount;
63 
64 
65 
66     // set payout variables
67      Total_Deposits+=amount;       	//update deposited amount
68 	    
69       Fees   =amount * FeeRate/100;    // 7% fee to the owner
70       amount-=amount * FeeRate/100;
71 	    
72       Bankroll += amount*80/100;     // 80% to the balance
73       amount-=amount*80/100;  
74 	    
75       Jackpot += amount;               	//remaining to the jackpot
76 
77 
78     // payout fees to the owner
79      if (Fees != 0) 
80      {
81       	owner.send(Fees);		//send fee to owner
82 	Total_Payouts+=Fees;        //update paid out amount
83      }
84  
85     if (msg.value >= MinDeposit) 
86      {
87 	     
88    //payout to participants	
89      if(list_length%40==0 && Jackpot > 0)   				//every 40th player wins the jackpot if  it's not 0
90 	{
91 	gamblerlist[list_length].etherAddress.send(Jackpot);         //send pay out to participant
92 	Total_Payouts += Jackpot;               					//update paid out amount   
93 	Jackpot=0;									//jackpot update
94 	}
95      else   											//you either win the jackpot or the balance, but not both in 1 round
96 	if(uint(sha3(gamblerlist[list_length].etherAddress)) % 2==0 && list_length % 2==0 && Bankroll > 0) 	//if the hashed length of your address is even, 
97 	{ 												   								//which is a 25% chance, then you get paid out all balance!
98 	gamblerlist[list_length].etherAddress.send(Bankroll);        //send pay out to participant
99 	Total_Payouts += Bankroll;               					//update paid out amount
100 	Bankroll = 0;                      						//bankroll update
101 	}
102     
103     
104     
105     //enter function ends
106 	}
107     }
108   }
109 
110 //********************************************NEW OWNER
111 
112   function setOwner(address new_owner) onlyowner { //set new owner of the casino
113       owner = new_owner;
114   }
115 //********************************************SET MIN DEPOSIT
116 
117   function setMinDeposit(uint new_mindeposit) onlyowner { //set new minimum deposit rate
118       MinDeposit = new_mindeposit;
119   }
120 //********************************************SET FEE RATE
121 
122   function setFeeRate(uint new_feerate) onlyowner { //set new fee rate
123       FeeRate = new_feerate;
124   }
125 }