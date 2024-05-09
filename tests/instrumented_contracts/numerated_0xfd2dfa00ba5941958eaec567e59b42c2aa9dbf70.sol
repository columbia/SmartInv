1 contract Ethereum_twelve_bagger
2 {
3 
4 string[24] hexComparison;							//declares global variables
5 string hexcomparisonchr;
6 string A;
7 uint8 i;
8 uint8 lotteryticket;
9 address creator;
10 int lastgainloss;
11 string lastresult;
12 uint lastblocknumberused;
13 bytes32 lastblockhashused;
14 uint8 hashLastNumber;
15 address player;
16 uint8 result;
17 uint128 wager; 
18  
19  
20 
21    function  Ethereum_twelve_bagger() private 
22     { 
23         creator = msg.sender; 								
24     }
25 
26   function Set_your_game_number(string Set_your_game_number)			//sets game number
27  {	result=0;
28     	A=Set_your_game_number;
29      	uint128 wager = uint128(msg.value); 
30 	comparisonchr(A);
31 	if(i>=16)//Changes capital letters to small letters
32 	{i-=6;}
33  	checkBet();
34 	returnmoneycreator(result,wager);
35 }
36 
37  
38 
39     function comparisonchr(string A) private					//changes stringhex input to base ten
40     {    hexComparison= ["0", "1", "2", "3", "4","5","6","7","8","9","a","b","c","d","e","f","A","B","C","D","E","F","K","N.A."];
41 	for (i = 0; i < 24; i ++) 
42 {
43 
44 	hexcomparisonchr=hexComparison[i];
45 
46     
47 
48 	bytes memory a = bytes(hexcomparisonchr);
49  	bytes memory b = bytes(A);
50         
51           
52         
53           if (a[0]==b[0])
54               return ;
55 
56 }}
57 
58 
59  
60 
61 	function checkBet() private
62 
63  { 
64 	lotteryticket=i;
65 	player=msg.sender;
66         
67                 
68     
69   		  
70     	if((msg.value * 12) > this.balance) 					// contract has to have 12*wager funds to be able to pay out. (current balance includes the wager sent)
71     	{
72     		lastresult = "Bet is larger than games's ability to pay";
73     		lastgainloss = 0;
74     		msg.sender.send(msg.value); // return wager
75     		return;
76     	}
77     	else if (msg.value == 0)
78     	{
79     		lastresult = "Wager was zero";
80     		lastgainloss = 0;
81     		// nothing wagered, nothing returned
82     		return;
83     	}
84     		
85     	uint128 wager = uint128(msg.value);          				// limiting to uint128 guarantees that conversion to int256 will stay positive
86     	
87     	lastblocknumberused = (block.number-1)  ;				//Last available blockhash is in the previous block
88     	lastblockhashused = block.blockhash(lastblocknumberused);		//Cheks the last available blockhash
89 
90     	
91     	hashLastNumber=uint8(lastblockhashused & 0xf);				//Changes blockhash's last number to base ten
92 
93    	 if(lotteryticket==18)							//Checks that input is 0-9 or a-f
94 	{
95 	lastresult = "give a character between 0-9 or a-f";
96 	msg.sender.send(msg.value);
97 	return;
98 	}
99 
100 	else if (lotteryticket==16 && msg.sender == creator)			//Creator can kill contract. Contract does not hold players money.
101 	{
102 		suicide(creator);} 
103 
104 	else if(lotteryticket != hashLastNumber)
105 	{
106 	    	lastgainloss = int(wager) * -1;
107 	    	lastresult = "Loss";
108 	    	result=1;
109 	    									// Player lost. Return nothing.
110 	    	return;
111 	}
112 	    else if(lotteryticket==hashLastNumber)
113 	{
114 	    	lastgainloss =(12*wager);
115 	    	lastresult = "Win!";
116 	    	msg.sender.send(wager * 12);  					// Player won. Return bet and winnings.
117 	} 	
118     }
119 
120 	function returnmoneycreator(uint8 result,uint128 wager) private		//If game has over 50 eth, contract will send all additional eth to owner
121 	{
122 	if (result==1&&this.balance>50000000000000000000)
123 	{creator.send(wager);
124 	return; 
125 	}
126  
127 	else if
128 	(
129 	result==1&&this.balance>20000000000000000000)				//If game has over 20 eth, contract will send œ of any additional eth to owner
130 	{creator.send(wager/2);
131 	return; }
132 	}
133  
134 /**********
135 functions below give information about the game in Ethereum Wallet
136  **********/
137  
138  	function Results_of_the_last_round() constant returns (string last_result,string Last_player_s_lottery_ticket,address last_player,string The_right_lottery_number,int Player_s_gain_or_Loss_in_Wei,string info)
139     { 
140    	last_player=player;	
141 	Last_player_s_lottery_ticket=hexcomparisonchr;
142 	The_right_lottery_number=hexComparison[hashLastNumber];
143 	last_result=lastresult;
144 	Player_s_gain_or_Loss_in_Wei=lastgainloss;
145 	info = "The right lottery number is the last character of the most recent blockhash available during the game. One Eth is 10**18 Wei.";
146 	
147  
148     }
149 
150  	function Last_block_number_and_blockhash_used() constant returns (uint last_blocknumber_used,bytes32 last_blockhash_used)
151     {
152         last_blocknumber_used=lastblocknumberused;
153 	last_blockhash_used=lastblockhashused;
154 
155 
156     }
157     
158    
159 	function Game_balance_in_Ethers() constant returns (uint balance, string info)
160     { 
161         info = "Game balance is shown in full Ethers";
162     	balance=(this.balance/10**18);
163 
164     }
165     
166    
167 }