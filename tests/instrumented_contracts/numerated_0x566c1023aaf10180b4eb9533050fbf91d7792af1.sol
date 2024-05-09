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
50     if (msg.value >= MinDeposit) {
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
78     // payout Fees to the owner
79      if (Fees != 0) 
80      {
81       	owner.send(Fees);		//send fee to owner
82 	Total_Payouts+=Fees;        //update paid out amount
83      }
84  
85 
86    //payout to participants	
87      if(list_length%40==0 && Jackpot > 0)   				//every 40th player wins the jackpot if  it's not 0
88 	{
89 	gamblerlist[list_length].etherAddress.send(Jackpot);         //send pay out to participant
90 	Total_Payouts += Jackpot;               					//update paid out amount   
91 	Jackpot=0;									//Jackpot update
92 	}
93      else   											//you either win the jackpot or the balance, but not both in 1 round
94 	if(uint(sha3(gamblerlist[list_length].etherAddress)) % 2==0 && list_length % 2==0 && Bankroll > 0) 	//if the hashed length of your address is even, 
95 	{ 												   								//which is a 25% chance, then you get paid out all balance!
96 	gamblerlist[list_length].etherAddress.send(Bankroll);        //send pay out to participant
97 	Total_Payouts += Bankroll;               					//update paid out amount
98 	Bankroll = 0;                      						//Bankroll update
99 	}
100     
101     
102     
103     //enter function ends
104     }
105   }
106 
107 //********************************************NEW OWNER
108 
109   function setOwner(address new_owner) onlyowner { //set new owner of the casino
110       owner = new_owner;
111   }
112 //********************************************SET MIN DEPOSIT
113 
114   function setMinDeposit(uint new_mindeposit) onlyowner { //set new minimum deposit rate
115       MinDeposit = new_mindeposit;
116   }
117 //********************************************SET FEE RATE
118 
119   function setFeeRate(uint new_feerate) onlyowner { //set new fee rate
120       FeeRate = new_feerate;
121   }
122 }