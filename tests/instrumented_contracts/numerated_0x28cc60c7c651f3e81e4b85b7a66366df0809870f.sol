1 contract Ethereum_doubler
2 {
3 
4 string[8] hexComparison;							//declares global variables
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
18 uint8 lowOrHigh; // 0=low, 2=high, 4=kill, 6=n.a.
19 uint8 HashtoLowOrHigh;//hash modified to low or high 0=low, 2=high, 7= 0 or F
20  
21 
22    function  Ethereum_doubler() private 
23     { 
24         creator = msg.sender; 								
25     }
26 
27   function Set_your_game_number(string Set_your_game_number_L_or_H)			//sets game number
28  {	result=0;
29     	A=Set_your_game_number_L_or_H ;
30      	uint128 wager = uint128(msg.value); 
31 	comparisonchr(A);
32 	inputToDigit(i);
33 	checkHash();
34 	changeHashtoLowOrHigh(hashLastNumber);
35  	checkBet();
36 	returnmoneycreator(result,wager);
37 }
38 
39  
40 
41     function comparisonchr(string A) private					//changes string input to uint
42     {    hexComparison= ["L", "l", "H", "h", "K","N.A.","dummy","0 or F"];
43 	for (i = 0; i < 6; i ++) 
44 {
45 
46 	hexcomparisonchr=hexComparison[i];
47 
48     
49 
50 	bytes memory a = bytes(hexcomparisonchr);
51  	bytes memory b = bytes(A);
52         
53           
54         
55           if (a[0]==b[0])
56               return ;
57 
58 }}
59 
60 function inputToDigit(uint i) private
61 {
62 if(i==0 || i==1)
63 {lowOrHigh=0;
64 return;}
65 else if (i==2 ||i==3)
66 {lowOrHigh=2;
67 return;}
68 else if (i==4)
69 {lowOrHigh=4;
70 return;}
71 else if (i==6)
72 {lowOrHigh=6;}
73 return;}
74 
75 	function checkHash() private
76 {
77    	lastblocknumberused = (block.number-1)  ;				//Last available blockhash is in the previous block
78     	lastblockhashused = block.blockhash(lastblocknumberused);		//Cheks the last available blockhash
79 
80     	
81     	hashLastNumber=uint8(lastblockhashused & 0xf);				//Changes blockhash's last number to base ten
82 }
83 
84 	function changeHashtoLowOrHigh(uint  hashLastNumber) private
85 {
86 	if (hashLastNumber>0 && hashLastNumber<8)
87 	{HashtoLowOrHigh=0;
88 	return;}
89 	else if (hashLastNumber>7 && hashLastNumber<15)
90 	{HashtoLowOrHigh=2;
91 	return;}
92 	else
93 	{HashtoLowOrHigh=7;
94 	lastresult = "0 or F, house wins";
95 	return;}//result= 0 or F, house wins
96 	
97  
98 	 
99 }
100 
101  
102 
103 	function checkBet() private
104 
105  { 
106 	lotteryticket=lowOrHigh;
107 	player=msg.sender;
108         
109                 
110     
111   		  
112     	if(msg.value > (this.balance/4))					// maximum bet is game balance/4
113     	{
114     		lastresult = "Bet is too large. Maximum bet is the game balance/4.";
115     		lastgainloss = 0;
116     		msg.sender.send(msg.value); // return bet
117     		return;
118     	}
119 	else if(msg.value <100000000000000000)					// minimum bet is 0.1 eth
120     	{
121     		lastresult = "Minimum bet is 0.1 eth";
122     		lastgainloss = 0;
123     		msg.sender.send(msg.value); // return bet
124     		return;
125 
126 	}
127     	else if (msg.value == 0)
128     	{
129     		lastresult = "Bet was zero";
130     		lastgainloss = 0;
131     		// nothing wagered, nothing returned
132     		return;
133     	}
134     		
135     	uint128 wager = uint128(msg.value);          				// limiting to uint128 guarantees that conversion to int256 will stay positive
136     	
137  
138 
139    	 if(lotteryticket==6)							//Checks that input is L or H 
140 	{
141 	lastresult = "give a character L or H ";
142 	msg.sender.send(msg.value);
143 	lastgainloss=0;
144 	
145 	return;
146 	}
147 
148 	else if (lotteryticket==4 && msg.sender == creator)			//Creator can kill contract. Contract does not hold players money.
149 	{
150 		suicide(creator);} 
151 
152 	else if(lotteryticket != HashtoLowOrHigh)
153 	{
154 	    	lastgainloss = int(wager) * -1;
155 	    	lastresult = "Loss";
156 	    	result=1;
157 	    									// Player lost. Return nothing.
158 	    	return;
159 	}
160 	    else if(lotteryticket==HashtoLowOrHigh)
161 	{
162 	    	lastgainloss =(2*wager);
163 	    	lastresult = "Win!";
164 	    	msg.sender.send(wager * 2); 
165 		return;			 					// Player won. Return bet and winnings.
166 	} 	
167     }
168 
169 	function returnmoneycreator(uint8 result,uint128 wager) private		//If game has over 50 eth, contract will send all additional eth to owner
170 	{
171 	if (result==1&&this.balance>50000000000000000000)
172 	{creator.send(wager);
173 	return; 
174 	}
175  
176 	else if
177 	(
178 	result==1&&this.balance>20000000000000000000)				//If game has over 20 eth, contract will send œ of any additional eth to owner
179 	{creator.send(wager/2);
180 	return; }
181 	}
182  
183 /**********
184 functions below give information about the game in Ethereum Wallet
185  **********/
186  
187  	function Results_of_the_last_round() constant returns (string last_result,string Last_player_s_lottery_ticket,address last_player,string The_right_lottery_number,int Player_s_gain_or_Loss_in_Wei,string info)
188     { 
189    	last_player=player;	
190 	Last_player_s_lottery_ticket=hexcomparisonchr;
191 	The_right_lottery_number=hexComparison[HashtoLowOrHigh];
192 	last_result=lastresult;
193 	Player_s_gain_or_Loss_in_Wei=lastgainloss;
194 	info = "The right lottery number is decided by the last character of the most recent blockhash available during the game. 1-7 =Low, 8-e =High. One Eth is 10**18 Wei.";
195 	
196  
197     }
198 
199  	function Last_block_number_and_blockhash_used() constant returns (uint last_blocknumber_used,bytes32 last_blockhash_used)
200     {
201         last_blocknumber_used=lastblocknumberused;
202 	last_blockhash_used=lastblockhashused;
203 
204 
205     }
206     
207    
208 	function Game_balance_in_Ethers() constant returns (uint balance, string info)
209     { 
210         info = "Game balance is shown in full Ethers";
211     	balance=(this.balance/10**18);
212 
213     }
214     
215    
216 }