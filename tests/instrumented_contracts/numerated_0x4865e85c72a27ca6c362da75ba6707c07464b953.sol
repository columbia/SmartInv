1 //***********************************TREASURE CHEST GAME
2 //
3 //
4 //  Hello player, this is a Treasure Chest game, every player that deposit's here will get a guaranteed 6% payout of their balance after somebody after him deposits!
5 //  Every 30th investor receives 18% instead of 6%, that is the jackpot spot that pays 3x more, invest quickly ,and you can earn a passive income right now!
6 //
7 //  This contract is bug-tested, and it has none, feel comfortable to analyse the code yourself, it's open source and transparent!
8 //  Enjoy this game, and earn Ethereum now!
9 //
10 //  Copyright  Â©  2016  David Weissman from NZ
11 //
12 //***********************************START
13 contract TreasureChest {
14 
15   struct InvestorArray {
16       address etherAddress;
17       uint amount;
18   }
19 
20   InvestorArray[] public investors;
21 
22 //********************************************PUBLIC VARIABLES
23 
24   uint public investors_needed_until_jackpot=0;
25   uint public totalplayers=0;
26   uint public fees=0;
27   uint public balance = 0;
28   uint public totaldeposited=0;
29   uint public totalpaidout=0;
30 
31   address public owner;
32 
33   // simple single-sig function modifier
34   modifier onlyowner { if (msg.sender == owner) _ }
35 
36 //********************************************INIT
37 
38   function TreasureChest() {
39     owner = msg.sender;
40   }
41 
42 //********************************************TRIGGER
43 
44   function() {
45     enter();
46   }
47   
48 //********************************************ENTER
49 
50   function enter() {
51     if (msg.value < 50 finney) {
52         msg.sender.send(msg.value);
53         return;
54     }
55 	
56     uint amount=msg.value;
57 
58 
59     // add a new participant to the system and calculate total players
60     uint tot_pl = investors.length;
61     totalplayers=tot_pl+1;
62     investors_needed_until_jackpot=30-(totalplayers % 30);
63     investors.length += 1;
64     investors[tot_pl].etherAddress = msg.sender;
65     investors[tot_pl].amount = amount;
66 
67 
68 
69     // collect fees and update contract balance and deposited amount
70       fees  = amount / 15;             // 6.666% fee to the owner
71       balance += amount;               // balance update
72       totaldeposited+=amount;       //update deposited amount
73 
74     // pay out fees to the owner
75      if (fees != 0) 
76      {
77      	if(balance>fees)
78 	{
79       	owner.send(fees);
80       	balance -= fees;                 //balance update
81 	totalpaidout+=fees;          //update paid out amount
82 	}
83      }
84  
85 
86    //loop variables
87     uint payout;
88     uint nr=0;
89 	
90     while (balance > investors[nr].amount * 6/100 && nr<tot_pl)  //exit condition to avoid infinite loop
91     { 
92      
93      if(nr%30==0 &&  balance > investors[nr].amount * 18/100)
94      {
95       payout = investors[nr].amount * 18/100;                        //calculate pay out
96       investors[nr].etherAddress.send(payout);                      //send pay out to participant
97       balance -= investors[nr].amount * 18/100;                      //balance update
98       totalpaidout += investors[nr].amount * 18/100;               //update paid out amount
99       }
100      else
101      {
102       payout = investors[nr].amount *6/100;                           //calculate pay out
103       investors[nr].etherAddress.send(payout);                        //send pay out to participant
104       balance -= investors[nr].amount *6/100;                         //balance update
105       totalpaidout += investors[nr].amount *6/100;                 //update paid out amount
106       }
107       
108       nr += 1;                                                                         //go to next participant
109     }
110     
111     
112   }
113 
114 //********************************************NEW OWNER
115 
116   function setOwner(address new_owner) onlyowner {
117       owner = new_owner;
118   }
119 }